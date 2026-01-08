import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:car_rental_app/features/home/data/nav_bar_data_source.dart';
import 'package:meta/meta.dart';

part 'navigation_bar_state.dart';

class NavigationBarCubit extends Cubit<NavigationBarState> {
  NavigationBarCubit({
    required NavigationBarDataSource dataSource,
    required String userId,
  })  : _dataSource = dataSource,
        _userId = userId,
        super(const NavigationBarState(index: 0, unReadChatCount: 0)) {
    _unreadSub = _dataSource.watchUnReadChatCount(_userId).listen((count) {
      emit(state.copyWith(unReadChatCount: count));
    });
  }

  final NavigationBarDataSource _dataSource;
  final String _userId;

  StreamSubscription<int>? _unreadSub;

  void changeIndex(int index) {
    emit(state.copyWith(index: index));
  }

  @override
  Future<void> close() async {
    await _unreadSub?.cancel();
    return super.close();
  }

}
