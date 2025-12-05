import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/data/services/auth_service.dart';
import 'package:car_rental_app/features/auth/Presentation/widgets/action_button.dart';
import 'package:car_rental_app/features/auth/Presentation/widgets/custom_textfield.dart';
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
                InternationalPhoneNumberInput(
                  textFieldController: _phoneController,
                  initialValue: phoneNumber,
                  onInputValidated: (value) {
                    
                      isValidNumber = value;
                    
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                    useEmoji: true,
                    setSelectorButtonAsPrefixIcon: true,
                    leadingPadding: 12,
                  ),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "This field can't be empty";
                    }else if(!isValidNumber){
                      return "Invalid phone number";
                    }
                    return null;
                  },
                  inputDecoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade800, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  ),
                  formatInput: false,
                  spaceBetweenSelectorAndTextField: 8,
                  keyboardType: TextInputType.phone,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (value) {
                    print("onFieldSubmitted: $value");
                  },
                  onInputChanged: (value) async {
                    try {
                      phoneNumber = value;
                    } catch (_) {}
                  },
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
