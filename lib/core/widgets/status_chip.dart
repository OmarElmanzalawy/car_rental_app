import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final Color statusChipColor;
  final String statusChipLabel;
  final VoidCallback? onPressed;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const StatusChip({
    super.key,
    required this.statusChipColor,
    required this.statusChipLabel,
    this.onPressed,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed ?? (){},
      child: Container(
                        padding: padding ?? const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusChipColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusChipColor),
                        ),
                        child: Text(
                          statusChipLabel,
                          style: TextStyle(
                            color: textColor ?? statusChipColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
    );
  }
}