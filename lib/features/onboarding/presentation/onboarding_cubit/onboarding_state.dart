part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.userRole,
  });

  final int currentPage;
  final UserType? userRole;

  //copy with method
  OnboardingState copyWith({
    int? currentPage,
    UserType? userRole,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      userRole: userRole ?? this.userRole,
    );
  }


  @override
  List<Object?> get props => [currentPage, userRole];
}

