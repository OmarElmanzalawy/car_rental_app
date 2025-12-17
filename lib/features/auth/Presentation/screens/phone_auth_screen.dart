import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/widgets/phone_textfield.dart';
import 'package:car_rental_app/features/auth/data/services/auth_service.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uuid/uuid_value.dart';

class PhoneAuthScreen extends StatefulWidget {
  PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String initialCountry = 'EG';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'EG');
  bool isValidNumber = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background, 
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 220,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.silverAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.phone_iphone,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Continue with Phone',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in or sign up with your phone number.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 24),
                PhoneTextfield(
                  initialCountry: initialCountry, 
                  phoneNumber: phoneNumber, 
                  phoneController: _phoneController,
                  errorMessage: 'Invalid phone number',
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    label: 'Next',
                    onPressed: () async{
                      print(phoneNumber.phoneNumber);
                      if(_formKey.currentState!.validate()){
                        final response = await AuthService.signInWithPhone(phoneNumber.phoneNumber!);
                        if(response.success){
                          context.push(
                            AppRoutes.verifyOtp,
                            extra: phoneNumber.phoneNumber,
                          );
                        }else{
                          showPlatformDialog(
                            context: context,
                            builder: (context) => PlatformAlertDialog(
                              title: const Text('Error'),
                              content: Text(response.message),
                              actions: [
                                PlatformDialogAction(
                                  child: PlatformText('OK'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
