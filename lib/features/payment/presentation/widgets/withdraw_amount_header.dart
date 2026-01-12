import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/withdraw_dotted_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithdrawAmountHeader extends StatelessWidget {
  const WithdrawAmountHeader({
    super.key,
    required this.amountController,
    this.title = 'Enter Amount',
  });

  final TextEditingController amountController;
  final String title;
  

  @override
  Widget build(BuildContext context) {
    return WithdrawDottedBackground(
      // dotColor: Colors.black,
      // dotOpacity: 0.5,
      // dotRadius: 3,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              _AmountField(controller: amountController),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final selectionColor = Colors.white.withValues(alpha: 0.35);
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 60,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    );

    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: selectionColor,
        cursorColor: Colors.white,
        selectionHandleColor: Colors.white.withValues(alpha: 0.9),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        selectionControls: materialTextSelectionControls,
        style: textStyle,
        inputFormatters: [
          TextInputFormatter.withFunction((old,newVal){
            //add $ to the beginning of the text
            print(old.text);
            print(newVal.text);
            if (newVal.text.isNotEmpty && !newVal.text.contains("\$")){
              return newVal.copyWith(text: "\$${newVal.text}" );
            }else if(newVal.text.contains("\$") && newVal.text.length <=1){
            return newVal.copyWith(text: newVal.text.replaceAll("\$", ""));
            }else{
              return newVal;
            }
          })
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '\$0',
          hintStyle:
              textStyle.copyWith(color: Colors.white.withValues(alpha: 0.65)),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

