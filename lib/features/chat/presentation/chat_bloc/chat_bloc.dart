import 'package:car_rental_app/features/chat/data/chat_remote_data_source.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({ChatRemoteDataSource? chatRemoteDataSource})
      : _chatRemoteDataSource =
            chatRemoteDataSource ?? ChatRemoteDataSourceImpl(Supabase.instance.client),
        super(const ChatInitial()) {
    on<InitiateChatRequested>(_onInitiateChatRequested);
  }

  final ChatRemoteDataSource _chatRemoteDataSource;

  Future<void> _onInitiateChatRequested(
    InitiateChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    print("chat initiation started");
    emit(const ChatInitiationLoading());
    try {
      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      if (currentUserId == null) {
        emit(const ChatInitiationFailure('User not authenticated'));
        return;
      }

      final String user1;
      final String user2;

      if (currentUserId.compareTo(event.ownerId) < 0) {
        user1 = currentUserId;
        user2 = event.ownerId;
      } else {
        user1 = event.ownerId;
        user2 = currentUserId;
      }

      final existingConversationId =
          await _chatRemoteDataSource.checkIfChatExists(user1: user1, user2: user2);

      if (existingConversationId != null) {
        emit(ChatInitiated(existingConversationId));
        return;
      }

      await _chatRemoteDataSource.createChat(receiverId: event.ownerId);

      final createdConversationId =
          await _chatRemoteDataSource.checkIfChatExists(user1: user1, user2: user2);

      if (createdConversationId == null) {
        emit(const ChatInitiationFailure('Failed to create conversation'));
        return;
      }

      emit(ChatInitiated(createdConversationId));
    } catch (e) {
      emit(ChatInitiationFailure(e.toString()));
    }
  }
}
