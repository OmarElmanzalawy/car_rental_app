part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
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
  List<Object> get props => [conversationId];
}

final class ChatInitiationFailure extends ChatState {
  const ChatInitiationFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
