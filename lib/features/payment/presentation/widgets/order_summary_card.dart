import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.orderAmount,
    required this.promoCode,
    required this.delivery,
    required this.tax,
    required this.totalAmount,
  });

  final double orderAmount;
  final double promoCode;
  final double delivery;
  final double tax;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _SummaryRow(label: "Order Amount", value: _money(orderAmount)),
          const SizedBox(height: 12),
          _SummaryRow(label: "Promo-code", value: "-${_money(promoCode)}"),
          const SizedBox(height: 12),
          _SummaryRow(label: "Delivery", value: _money(delivery)),
          const SizedBox(height: 12),
          _SummaryRow(label: "Tax", value: _money(tax)),
          const SizedBox(height: 12),
          Divider(color: Colors.black.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 12),
          _SummaryRow(
            label: "Total Amount",
            value: _money(totalAmount),
            isEmphasis: true,
          ),
        ],
      ),
    );
  }

  String _money(double value) => "\$ ${value.toStringAsFixed(2)}";
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
  });

  final String label;
  final String value;
  final bool isEmphasis;

  @override
  Widget build(BuildContext context) {
    final valueColor = isEmphasis ? const Color(0xFFF26B3A) : Colors.black;

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isEmphasis ? 15 : 14,
            fontWeight: isEmphasis ? FontWeight.w700 : FontWeight.w500,
            color: isEmphasis ? Colors.black : AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isEmphasis ? 18 : 14,
            fontWeight: isEmphasis ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

