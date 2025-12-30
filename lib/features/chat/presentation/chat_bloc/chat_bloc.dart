import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/chat/data/chat_remote_data_source.dart';
import 'package:car_rental_app/features/chat/domain/entities/conversation_model.dart';
import 'package:car_rental_app/features/chat/domain/entities/message_model.dart';
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
    on<ChatMessagesSubscribed>(_onChatMessagesSubscribed);
    on<LoadConversationsRequested>(_onLoadConversationsRequested);
    on<SendMessageEvent>(_onSendMessageEvent);
    on<BookingRequestResponded>(_onBookingRequestResponded);
  }

  final ChatRemoteDataSource _chatRemoteDataSource;

  Future<void> _onSendMessageEvent(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRemoteDataSource.sendMessage(messageModel: event.messageModel);
    } catch (e) {
      emit(ChatMessagesFailure(e.toString()));
    }
  }

  Future<void> _onLoadConversationsRequested(
    LoadConversationsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatConversationsLoading());
    try {
      final List<ConversationModel> conversations =
          await _chatRemoteDataSource.getConversations();
      emit(ChatConversationsLoaded(conversations));
    } catch (e) {
      emit(ChatConversationsFailure(e.toString()));
    }
  }

  Future<void> _onInitiateChatRequested(
    InitiateChatRequested event,
    Emitter<ChatState> emit,
  ) async {
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

  Future<void> _onChatMessagesSubscribed(
    ChatMessagesSubscribed event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatMessagesLoading());

    await emit.forEach<List<MessageModel>>(
      _chatRemoteDataSource.getMessages(conversationId: event.conversationId),
      onData: (messages) {
        final sorted = [...messages]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return ChatMessagesLoaded(sorted);
      },
      onError: (error, _) => ChatMessagesFailure(error.toString()),
    );
  }

  Future<void> _onBookingRequestResponded(
    BookingRequestResponded event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatBookingActionInProgress(rentalId: event.rentalId));
    try {
      await _chatRemoteDataSource.updateRentalStatus(
        rentalId: event.rentalId,
        status: event.status,
      );
      emit(
        ChatBookingActionSuccess(
          rentalId: event.rentalId,
          status: event.status,
        ),
      );
    } catch (e) {
      emit(ChatBookingActionFailure(rentalId: event.rentalId, message: e.toString()));
    }
  }
}
