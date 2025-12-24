part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {
  const ChatInitial();
}

final class ChatInitiationLoading extends ChatState {
  const ChatInitiationLoading();
}

final class ChatInitiated extends ChatState {
  const ChatInitiated(this.conversationId);

  final String conversationId;
  

  @override
  List<Object?> get props => [conversationId];
}

final class ChatInitiationFailure extends ChatState {
  const ChatInitiationFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class ChatMessagesLoading extends ChatState {
  const ChatMessagesLoading();
}

final class ChatMessagesLoaded extends ChatState {
  const ChatMessagesLoaded(this.messages);

  final List<MessageModel> messages;

  @override
  List<Object?> get props => [messages];
}

final class ChatMessagesFailure extends ChatState {
  const ChatMessagesFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class ChatConversationsLoading extends ChatState {
  const ChatConversationsLoading();
}

final class ChatConversationsLoaded extends ChatState {
  const ChatConversationsLoaded(this.conversations);

  final List<ConversationModel> conversations;

  @override
  List<Object?> get props => [conversations];
}

final class ChatConversationsFailure extends ChatState {
  const ChatConversationsFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
