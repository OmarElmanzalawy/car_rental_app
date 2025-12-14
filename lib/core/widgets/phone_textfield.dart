import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneTextfield extends StatelessWidget {
  PhoneTextfield({super.key, required this.initialCountry, required this.phoneNumber,required this.phoneController,this.validator,this.errorMessage,this.enabledBorder,this.errorBorder,this.focusedBorder,this.enabled = true,this.onSubmit});

  final TextEditingController phoneController;
  bool isValidNumber = false;
  String initialCountry;
  PhoneNumber phoneNumber;
  String? Function(String?)? validator;
  final String? errorMessage;
  final bool enabled;
  final void Function(String)? onSubmit;


  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;


  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
                  textFieldController: phoneController,
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
                  validator: validator ?? (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "This field can't be empty";
                    }else if(!isValidNumber){
                      return "Invalid phone number";
                    }
                    return null;
                  },
                  inputDecoration:  InputDecoration(
                    enabled: enabled,
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                    hintText: "Enter your phone number",
                    // filled: true,
                    // fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: enabledBorder ?? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: focusedBorder ?? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
                    ),
                    errorBorder: errorBorder ?? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade800, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  ),
                  formatInput: false,
                  spaceBetweenSelectorAndTextField: 8,
                  keyboardType: TextInputType.phone,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: onSubmit ?? (value) {
                    // phoneNumber = phoneNumber.
                    // print("onFieldSubmitted: $value");
                  },
                  onInputChanged: (value) async {
                    try {
                      phoneNumber = value;
                    } catch (_) {}
                  },
                  errorMessage: errorMessage ?? 'Invalid phone number',
                );
  }
}