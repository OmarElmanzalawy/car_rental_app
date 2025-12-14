import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.prefixIcon, this.cursorColor, this.borderColor, this.textColor, this.hintColor, this.fillColor, this.isFilled, this.borderRadius, this.focusColor, this.errorStyle, this.errorBorder, this.focusedErrorBorder,
    this.isEnabled = true
  });

  final String hintText;
  final bool obscureText;
  final bool isEnabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;
  final bool? isFilled;
  final double? borderRadius;
  final Color? focusColor;
  final TextStyle? errorStyle;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {

  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      obscureText: widget.obscureText,
      validator: widget.validator,
      enabled: widget.isEnabled,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: widget.textColor ?? Colors.black),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintColor ?? Colors.black.withOpacity(0.5)),
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.obscureText ? IconButton(
          icon: Icon(
            widget.obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ) : null,
        filled: widget.isEnabled ? false : true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          borderSide:  BorderSide(color: widget.borderColor ?? Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          borderSide: BorderSide(color: widget.borderColor ?? Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          borderSide: BorderSide(color: widget.focusColor ?? widget.borderColor ?? Colors.black.withOpacity(0.4), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: widget.errorBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade800, width: 2),
        ),
        errorStyle: widget.errorStyle ?? TextStyle(color: Colors.red.shade700),
        focusedErrorBorder: widget.focusedErrorBorder,
      ),
    );
  }
}