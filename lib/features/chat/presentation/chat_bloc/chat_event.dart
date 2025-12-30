part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

final class InitiateChatRequested extends ChatEvent {
  const InitiateChatRequested({required this.ownerId});

  final String ownerId;

  @override
  List<Object> get props => [ownerId];
}

final class ChatMessagesSubscribed extends ChatEvent {
  const ChatMessagesSubscribed({required this.conversationId});

  final String conversationId;

  @override
  List<Object> get props => [conversationId];
}

final class LoadConversationsRequested extends ChatEvent {
  const LoadConversationsRequested();
}

final class SendMessageEvent extends ChatEvent {
  const SendMessageEvent({required this.messageModel});

  final MessageModel messageModel;

  @override
  List<Object?> get props => [messageModel];
}

final class BookingRequestResponded extends ChatEvent {
  const BookingRequestResponded({
    required this.rentalId,
    required this.status,
  });

  final String rentalId;
  final RentalStatus status;

  @override
  List<Object?> get props => [rentalId, status];
}
