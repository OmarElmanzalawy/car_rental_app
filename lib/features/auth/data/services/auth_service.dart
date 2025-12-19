import 'dart:io';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  final bool success;
  final String message;
  AuthResult({required this.success, required this.message});
}

class AuthService {

  static Future<AuthResult> signInWithPhone(String phoneNumber)  async{
    try{
      print("AuthFunction phone: $phoneNumber");
      final supabase = Supabase.instance.client;
      await supabase.auth.signInWithOtp(
        phone: phoneNumber,
        channel: OtpChannel.sms
      );

      return AuthResult(success: true, message: "Verification code sent. Check your inbox.");
    } on AuthException catch (e) {
      print(e.code);
      print(e.message);
      return AuthResult(success: false, message: e.message);
    } catch (_) {
      return AuthResult(success: false, message: "Something went wrong. Please try again.");
    }
  }

  static Future<AuthResult> verifyPhoneOTP(String phoneNumber, String otp,BuildContext context)async{
    try{
      final supabase = Supabase.instance.client;
      await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );
      return AuthResult(success: true, message: "Logged in successfully.");
    } on AuthException catch (e) {
      print(e.code);
      print(e.message);
      if(e.code == "invalid_otp"){
        showPlatformDialog(
          context: context,
          builder: (context) => PlatformAlertDialog(
            title: Text("Invalid OTP"),
            content: Text("The OTP you entered is invalid. Please try again."),
            actions: [
              PlatformDialogAction(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
      else if(e.code == "otp_expired"){
        showPlatformDialog(
          context: context,
          builder: (context) => PlatformAlertDialog(
            title: Text("OTP Expired"),
            content: Text("The OTP you entered has expired. Please request a new one."),
            actions: [
              PlatformDialogAction(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
      return AuthResult(success: false, message: e.message);
    } catch (_) {
      return AuthResult(success: false, message: "Something went wrong. Please try again.");
    }
  }

  static Future<AuthResult> resendPhoneOTP(String phoneNumber)async{
    try{
      final supabase = Supabase.instance.client;
      await supabase.auth.resend(
        phone: phoneNumber,
        type: OtpType.sms,
      );
      print("success resend otp code");
      return AuthResult(success: true, message: "Verification code sent. Check your phone.");
      
    } on AuthException catch (e) {
      print(e.code);
      print(e.message);
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      print(e.toString());
      return AuthResult(success: false, message: "Something went wrong. Please try again.");
    }
  }

  static Future<AuthResult> signOut()async{
    try{
      final supabase = Supabase.instance.client;
      await supabase.auth.signOut();
      return AuthResult(success: true, message: "Logged out successfully.");
    } catch (e) {
      print("error while logging out");
      print(e.toString());
      return AuthResult(success: false, message: "Something went wrong. Please try again.");
    }
  }

  static Future<AuthResult> signUpWithEmail({required String email, required String password,required String name,required UserType userType}) async{
    final supabase = Supabase.instance.client;
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: Platform.isAndroid || Platform.isIOS ? "com.meshwari.app://auth-callback" : null,
        data: {
          "full_name": name,
          "role": userType.name,
        },
      );

      return AuthResult(success: true, message: "Verification email sent. Check your inbox.");
    } on AuthException catch (e) {
      print(e.code);
      print(e.message);
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      print("error signing up");
      print(e.toString());
      return AuthResult(success: false, message: "Something went wrong. Please try again.");
    }
  }

  static Future<void> completeEmailVerification()async{

    print("complete email verification function triggered");

    try{
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        print("No user found");
        return;
      }
      if (user.email != null) {
        final confirmedAt = user.emailConfirmedAt;
        if (confirmedAt == null) {
          return;
        }
        print("user is verified at: $confirmedAt");
      }
      final existing = await supabase
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();
      if (existing != null) {
        return;
      }
      final metadata = user.userMetadata ?? {};
      print(metadata.isEmpty ? "user has no metadata: $metadata": "user has valid metadata $metadata");
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
      await supabase.from('users').insert(model.toMap());
    }catch(e){
      print("error completing email verification");
      print(e.toString());
    }
  }

  static Future<AuthResult> signInWithEmail({required String email, required String password}) async{
    final supabase = Supabase.instance.client;
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return AuthResult(success: true, message: "Logged in successfully.");
    } on AuthException catch (e) {
      return AuthResult(success: false, message: e.message);
    } catch (_) {
      return AuthResult(success: false, message: "Something went wrong. Please try again.");
    }
  }

  //function that navigates to the appropriate home screen based on the user role
  //invoked after successful login
  static Future<void> navigateToAppropriateHomeScreen(BuildContext context)async{
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("No user found");
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

  static Future<UserType> getUserRole()async{
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("No user found");
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
