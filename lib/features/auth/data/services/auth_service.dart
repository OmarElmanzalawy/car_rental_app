import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  final bool success;
  final String message;
  AuthResult({required this.success, required this.message});
}

class AuthService {

  static Future<AuthResult> signInWithPhone(String phoneNumber)async{
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

  static Future<AuthResult> signUpWithEmail({required String email, required String password}) async{
    final supabase = Supabase.instance.client;
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: "com.meshwari.app://auth-callback",
      );
      return AuthResult(success: true, message: "Verification email sent. Check your inbox.");
    } on AuthException catch (e) {
      print(e.code);
      print(e.message);
      return AuthResult(success: false, message: e.message);
    } catch (e) {
      print("error signing up");
      return AuthResult(success: false, message: "Something went wrong. Please try again.");
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
}
