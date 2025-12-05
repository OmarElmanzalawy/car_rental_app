import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/data/services/auth_service.dart';
import 'package:car_rental_app/features/auth/Presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key, required this.phoneNumber});

  final TextEditingController _otpController = TextEditingController();
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 220,
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 44),
              const SizedBox(height: 24),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.silverAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.sms_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter Code',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'We sent a verification code to your phone number \n$phoneNumber.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                cursorColor: AppColors.textPrimary,
                style: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 38,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '-  -  -  -  -  -',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.3),letterSpacing: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppColors.textPrimary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  onPressed: ()async{
                  print("resesnd click");
                  final response = await AuthService.resendPhoneOTP(phoneNumber);
                  if(response.success){
                    showPlatformDialog(
                      context: context,
                      builder: (context) => PlatformAlertDialog(
                        title: Text("Success"),
                        content: Text(response.message),
                        actions: [
                          PlatformDialogAction(
                            child: Text("OK"),
                            onPressed: () => context.pop(),
                          ),
                        ],
                      ),
                    );
                  }
                }, child: Text("Resend Code"),),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  label: 'Next',
                  onPressed: () async{
                    
                    final response = await AuthService.verifyPhoneOTP(phoneNumber, _otpController.text,context);
                    if(response.success){
                      context.go(AppRoutes.home);
                    }
                  },
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
