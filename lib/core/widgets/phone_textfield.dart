import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneTextfield extends StatefulWidget {
  const PhoneTextfield({
    super.key,
    required this.initialCountry,
    required this.phoneNumber,
    required this.phoneController,
    this.validator,
    this.errorMessage,
    this.enabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.enabled = true,
    this.onSubmit,
    this.onChanged,
    this.onValidated,
  });

  final TextEditingController phoneController;
  final String initialCountry;
  final PhoneNumber phoneNumber;
  final String? Function(String?)? validator;
  final String? errorMessage;
  final bool enabled;
  final void Function(String)? onSubmit;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<bool>? onValidated;


  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;

  @override
  State<PhoneTextfield> createState() => _PhoneTextfieldState();
}

class _PhoneTextfieldState extends State<PhoneTextfield> {
  bool _isValidNumber = false;
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      textFieldController: widget.phoneController,
      initialValue: widget.phoneNumber,
      onInputValidated: (value) {
        if (_isValidNumber != value) {
          setState(() => _isValidNumber = value);
        }
        widget.onValidated?.call(value);
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
        useEmoji: true,
        setSelectorButtonAsPrefixIcon: true,
        leadingPadding: 12,
      ),
      validator: widget.validator ??
          (p0) {
            if (p0 == null || p0.isEmpty) {
              return "This field can't be empty";
            } else if (!_isValidNumber) {
              return "Invalid phone number";
            }
            return null;
          },
      inputDecoration: InputDecoration(
        enabled: widget.enabled,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        hintText: "Enter your phone number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textPrimary, width: 2),
            ),
        errorBorder: widget.errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade800, width: 2),
            ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      ),
      formatInput: false,
      spaceBetweenSelectorAndTextField: 8,
      keyboardType: TextInputType.phone,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: widget.onSubmit,
      onInputChanged: (value) {
        widget.onChanged?.call(value);
      },
      errorMessage: widget.errorMessage ?? 'Invalid phone number',
    );
}
}
