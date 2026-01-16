import 'package:bloc/bloc.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());

  void setCurrentPage(int currentPage) {
    emit(state.copyWith(currentPage: currentPage));
  }

  void setUserRole(UserType userRole) {
    emit(state.copyWith(userRole: userRole));
  }

  

}
