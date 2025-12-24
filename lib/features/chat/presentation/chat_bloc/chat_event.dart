part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class InitiateChatRequested extends ChatEvent {
  const InitiateChatRequested({required this.ownerId});

  final String ownerId;

  @override
  List<Object> get props => [ownerId];
}
