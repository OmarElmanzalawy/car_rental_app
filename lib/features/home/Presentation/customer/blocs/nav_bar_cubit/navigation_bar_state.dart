part of 'navigation_bar_cubit.dart';

@immutable
class NavigationBarState {
  final int index;
  final int unReadChatCount;

  const NavigationBarState({
    required this.index,
    required this.unReadChatCount,
  });

  NavigationBarState copyWith({
    int? index,
    int? unReadChatCount,
  }) {
    return NavigationBarState(
      index: index ?? this.index,
      unReadChatCount: unReadChatCount ?? this.unReadChatCount,
    );
  }
}
