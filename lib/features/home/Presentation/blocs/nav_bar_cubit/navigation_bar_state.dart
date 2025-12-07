part of 'navigation_bar_cubit.dart';

@immutable
sealed class NavigationBarState {
  final int index;
  const NavigationBarState(this.index);
}

final class NavigationBarInitial extends NavigationBarState {
  const NavigationBarInitial() : super(0);
}

final class NavigationBarChanged extends NavigationBarState {
  const NavigationBarChanged(super.index);
}
