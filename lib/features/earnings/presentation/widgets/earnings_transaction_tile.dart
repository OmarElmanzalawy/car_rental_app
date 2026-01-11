import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EarningsTransactionTile extends StatelessWidget {
  const EarningsTransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amountText,
    required this.icon,
    required this.iconBackground,
    required this.amountColor,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String amountText;
  final IconData icon;
  final Color iconBackground;
  final Color amountColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              amountText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

