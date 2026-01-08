import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/payment_method_option_tile.dart';
import 'package:flutter/material.dart';

class PaymentMethodsCard extends StatelessWidget {
  const PaymentMethodsCard({
    super.key,
    required this.selectedIndex,
    this.onSelect,
    this.onAddPressed,
  });

  final int selectedIndex;
  final ValueChanged<int>? onSelect;
  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          PaymentMethodOptionTile(
            iconAssetPath: "assets/icons/mastercard.png",
            title: "Master Card",
            subtitle: "******** 8463",
            isSelected: selectedIndex == 0,
            onPressed: onSelect == null ? null : () => onSelect!(0),
          ),
          const Divider(height: 1, color: AppColors.border),
          PaymentMethodOptionTile(
            iconAssetPath: "assets/icons/paypal.png",
            title: "Paypal",
            subtitle: "orb*****@gmail.com",
            isSelected: selectedIndex == 1,
            onPressed: onSelect == null ? null : () => onSelect!(1),
          ),
          const Divider(height: 1, color: AppColors.border),
          PaymentMethodOptionTile(
            iconAssetPath: "assets/icons/apple.png",
            title: "Apple Pay",
            isSelected: selectedIndex == 2,
            onPressed: onSelect == null ? null : () => onSelect!(2),
          ),
          const SizedBox(height: 14),
          _AddPaymentMethodButton(onPressed: onAddPressed),
        ],
      ),
    );
  }
}

class _AddPaymentMethodButton extends StatelessWidget {
  const _AddPaymentMethodButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.black, size: 20),
            SizedBox(width: 10),
            Text(
              "Add Payment Method",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

