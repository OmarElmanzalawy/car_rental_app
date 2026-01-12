import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WithdrawFromAccountTile extends StatelessWidget {
  const WithdrawFromAccountTile({
    super.key,
    required this.bankName,
    required this.maskedAccountNumber,
    required this.balanceText,
    required this.isSelected,
    this.leading,
    this.onPressed,
  });

  final String bankName;
  final String maskedAccountNumber;
  final String balanceText;
  final bool isSelected;
  final Widget? leading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.primaryLight : AppColors.border;
    final backgroundColor = isSelected
        ? AppColors.primaryLight.withValues(alpha: 0.35)
        : AppColors.surface;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            _LeadingSlot(child: leading),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    maskedAccountNumber,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.48),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  balanceText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                shape: BoxShape.circle,
                border: isSelected
                    ? null
                    : Border.all(
                        color: Colors.black.withValues(alpha: 0.18),
                        width: 2,
                      ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadingSlot extends StatelessWidget {
  const _LeadingSlot({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: child ??
          Icon(
            Icons.account_balance_outlined,
            color: Colors.black.withValues(alpha: 0.75),
            size: 22,
          ),
    );
  }
}

