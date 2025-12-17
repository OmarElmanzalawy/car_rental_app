import 'package:flutter/material.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.noBackgroundColor = false
  });

  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool noBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final Widget right = trailing ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null)
              Text(
                value!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            if (showChevron)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(Icons.chevron_right, color: Colors.black45),
              ),
          ],
        );
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: noBackgroundColor ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: noBackgroundColor ? null : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const Spacer(),
            right,
          ],
        ),
      ),
    );
  }
}
