import 'package:flutter/material.dart';

class SellerStatTile extends StatelessWidget {
  const SellerStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.delta,
    required this.isPositive,
  });

  final String label;
  final String value;
  final String delta;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final Color changeColor = isPositive ? Colors.green : Colors.red;
    final IconData changeIcon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(changeIcon, color: changeColor, size: 16),
              const SizedBox(width: 4),
              Text(
                delta,
                style: TextStyle(color: changeColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }
}