import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Capsule extends StatelessWidget {
  Capsule({
    super.key,
    required this.text,
    this.isGlass = true,
    this.backgroundColor,
    this.textColor,
    this.includeCarLogo = false,
    this.onTap,
    this.isSelected
  });

  final String text;
  final bool isGlass;
  Color? backgroundColor;
  Color? textColor;
  final bool includeCarLogo;
  final VoidCallback? onTap;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isSelected == true ? AppColors.surface : isGlass
              ? backgroundColor?.withOpacity(0.2) ??
                  Colors.grey.shade200.withOpacity(0.2)
              : backgroundColor ?? Colors.grey.shade200,
        ),
        child: Row(
          children: [
            if (includeCarLogo)
              Image.asset(
                'assets/logos/${text.toLowerCase()}.png',
                height: 15,
                width: 15,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(height: 15, width: 15);
                },
              ),
            const SizedBox(width: 4),
            Text(text, style: TextStyle(color: isSelected == true ? AppColors.primary : textColor ?? Colors.white)),
          ],
        ),
      ),
    );
  }
}
