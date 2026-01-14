import 'dart:io';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  final bool success;
  final String message;
  AuthResult({required this.success, required this.message});
}

abstract class AuthDataSource {
  Future<AuthResult> signInWithPhone(String phoneNumber);
  Future<AuthResult> verifyPhoneOTP(String phoneNumber, String otp);
  Future<AuthResult> resendPhoneOTP(String phoneNumber);
  Future<AuthResult> signOut();
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserType userType,
  });
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  });
  Future<void> completeEmailVerification();
  Future<UserType> getUserRole();
  Future<void> navigateToAppropriateHomeScreen(BuildContext context);
}

class AuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient client;
  AuthDataSourceImpl(this.client);

  String _mapAuthException(AuthException e) {
    switch (e.code) {
      case 'invalid_login_credentials':
      case 'invalid_credentials':
        return 'Wrong email or password.';
      case 'user_already_exists':
      case 'email_exists':
        return 'An account with this email already exists.';
      case 'email_address_invalid':
        return 'Please enter a valid email address.';
      case 'weak_password':
        return 'Password is too weak.';
      case 'signup_disabled':
        return 'Sign up is currently disabled.';
      case 'over_request_rate_limit':
        return 'Too many attempts. Please try again later.';
      case 'invalid_otp':
        return 'Invalid code. Please try again.';
      case 'otp_expired':
        return 'Code expired. Please request a new one.';
      default:
        return e.message;
    }
  }

  @override
  Future<AuthResult> signInWithPhone(String phoneNumber) async {
    try {
      await client.auth.signInWithOtp(phone: phoneNumber, channel: OtpChannel.sms);
      return AuthResult(
        success: true,
        message: 'Verification code sent. Check your phone.',
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, message: _mapAuthException(e));
    } catch (_) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> verifyPhoneOTP(String phoneNumber, String otp) async {
    try {
      await client.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );
      return AuthResult(success: true, message: 'Logged in successfully.');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: _mapAuthException(e));
    } catch (_) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> resendPhoneOTP(String phoneNumber) async {
    try {
      await client.auth.resend(phone: phoneNumber, type: OtpType.sms);
      return AuthResult(
        success: true,
        message: 'Verification code sent. Check your phone.',
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, message: _mapAuthException(e));
    } catch (_) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      await client.auth.signOut();
      return AuthResult(success: true, message: 'Logged out successfully.');
    } catch (_) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserType userType,
  }) async {
    try {
      await client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: Platform.isAndroid || Platform.isIOS
            ? 'com.meshwari.app://auth-callback'
            : null,
        data: {
          'full_name': name,
          'role': userType.name,
        },
      );

      return AuthResult(
        success: true,
        message: 'Verification email sent. Check your inbox.',
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, message: _mapAuthException(e));
    } catch (_) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<void> completeEmailVerification() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        return;
      }
      if (user.email != null) {
        final confirmedAt = user.emailConfirmedAt;
        if (confirmedAt == null) {
          return;
        }
      }
      final existing =
          await client.from('users').select('id').eq('id', user.id).maybeSingle();
      if (existing != null) {
        return;
      }
      final metadata = user.userMetadata ?? {};
      final name = (metadata['full_name'] as String?) ?? '';
      final roleName = (metadata['role'] as String?) ?? 'customer';
      final role = UserType.values.firstWhere(
        (r) => r.name == roleName,
        orElse: () => UserType.customer,
      );
      final model = UserModel(
        id: user.id,
        name: name,
        email: user.email,
        password: '',
        role: role,
        createdAt: DateTime.now(),
        phoneNumber: user.phone,
      );
      await client.from('users').insert(model.toMap());
    } catch (_) {
      return;
    }
  }

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await client.auth.signInWithPassword(email: email, password: password);
      return AuthResult(success: true, message: 'Logged in successfully.');
    } on AuthException catch (e) {
      return AuthResult(success: false, message: _mapAuthException(e));
    } catch (_) {
      return AuthResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Future<void> navigateToAppropriateHomeScreen(BuildContext context) async {
    final user = client.auth.currentUser;
    if (user == null) {
      return;
    }
    await completeEmailVerification();
    final metadata = user.userMetadata ?? {};
    final roleName = (metadata['role'] as String?) ?? 'customer';
    final role = UserType.values.firstWhere(
      (r) => r.name == roleName,
      orElse: () => UserType.customer,
    );
    if(role == UserType.customer){
      context.go(AppRoutes.customerHome);
    }else{
      context.go(AppRoutes.sellerHome);
    }
  }

  @override
  Future<UserType> getUserRole() async {
    final user = client.auth.currentUser;
    if (user == null) {
      return UserType.customer;
    }
    final metadata = user.userMetadata ?? {};
    final roleName = (metadata['role'] as String?) ?? 'customer';
    final role = UserType.values.firstWhere(
      (r) => r.name == roleName,
      orElse: () => UserType.customer,
    );
    return role;
  }
}
