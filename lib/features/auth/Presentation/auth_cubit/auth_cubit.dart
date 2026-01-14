import 'package:bloc/bloc.dart';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/features/auth/data/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthDataSource _authService;
  AuthCubit({required AuthDataSource authService})
      : _authService = authService,
        super(const AuthState());

  Future<void> signUpWithEmail(
    BuildContext context, {
    required String email,
    required String password,
    required String name,
    required UserType userType,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final result = await _authService.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      userType: userType,
    );
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
    DialogueService.showAdaptiveSnackBar(
      context,
      message: result.message,
      type: result.success ? AdaptiveSnackBarType.success : AdaptiveSnackBarType.error,
    );
  }

  Future<void> signInWithEmail(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final result = await _authService.signInWithEmail(email: email, password: password);
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
    if (!result.success) {
      DialogueService.showAdaptiveSnackBar(
        context,
        message: result.message,
        type: AdaptiveSnackBarType.error,
      );
      return;
    }
    await _authService.navigateToAppropriateHomeScreen(context);
  }

  Future<void> sendPhoneOtp(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final result = await _authService.signInWithPhone(phoneNumber);
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
    if (!result.success) {
      DialogueService.showAdaptiveSnackBar(
        context,
        message: result.message,
        type: AdaptiveSnackBarType.error,
      );
      return;
    }
    context.push(AppRoutes.verifyOtp, extra: phoneNumber);
  }

  Future<void> verifyPhoneOtp(
    BuildContext context, {
    required String phoneNumber,
    required String otp,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final result = await _authService.verifyPhoneOTP(phoneNumber, otp);
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
    if (!result.success) {
      DialogueService.showAdaptiveSnackBar(
        context,
        message: result.message,
        type: AdaptiveSnackBarType.error,
      );
      return;
    }
    await _authService.navigateToAppropriateHomeScreen(context);
  }

  Future<void> resendPhoneOtp(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final result = await _authService.resendPhoneOTP(phoneNumber);
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
    DialogueService.showAdaptiveSnackBar(
      context,
      message: result.message,
      type: result.success ? AdaptiveSnackBarType.success : AdaptiveSnackBarType.error,
    );
  }

  Future<void> signOut(BuildContext context) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    final result = await _authService.signOut();
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
    if (!result.success) {
      DialogueService.showAdaptiveSnackBar(
        context,
        message: result.message,
        type: AdaptiveSnackBarType.error,
      );
      return;
    }
    context.go(AppRoutes.login);
  }
}
