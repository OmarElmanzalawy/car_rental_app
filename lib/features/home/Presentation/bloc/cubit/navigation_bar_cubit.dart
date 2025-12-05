import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_bar_state.dart';

class NavigationBarCubit extends Cubit<NavigationBarState> {
  NavigationBarCubit() : super(const NavigationBarInitial());

  void changeIndex(int index) {
    emit(NavigationBarChanged(index));
  }
}
