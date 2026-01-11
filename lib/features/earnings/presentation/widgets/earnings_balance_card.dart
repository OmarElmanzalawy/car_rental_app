import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:flutter/material.dart';

class EarningsBalanceCard extends StatelessWidget {
  const EarningsBalanceCard({
    super.key,
    required this.availableBalanceText,
    required this.withdrawnText,
    required this.lifetimeText,
    this.onWithdrawPressed,
  });

  final String availableBalanceText;
  final String withdrawnText;
  final String lifetimeText;
  final VoidCallback? onWithdrawPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: ActionButton(
                  label: 'Withdraw',
                  isDense: true,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: onWithdrawPressed ?? () {},
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Available',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            availableBalanceText,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Lifetime',
                  value: lifetimeText,
                  icon: Icons.auto_graph_rounded,
                  iconColor: AppColors.primary,
                  bg: AppColors.primaryLight.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'Withdrawn',
                  value: withdrawnText,
                  icon: Icons.payments_outlined,
                  iconColor: Colors.black,
                  bg: AppColors.silverAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bg,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

