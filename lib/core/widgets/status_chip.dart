import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final Color statusChipColor;
  final String statusChipLabel;

  const StatusChip({
    super.key,
    required this.statusChipColor,
    required this.statusChipLabel,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
                      padding: const EdgeInsets.symmetric(
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
                          color: statusChipColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
  }
}