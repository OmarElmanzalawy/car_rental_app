import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:flutter/material.dart';

class RentalStatusTimeBar extends StatelessWidget {
  const RentalStatusTimeBar({
    super.key,
    required this.status,
    required this.pickupDate,
    required this.dropOffDate,
  });

  final RentalStatus status;
  final DateTime pickupDate;
  final DateTime dropOffDate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    late final _BarStyle style;
    late final String label;

    if (status == RentalStatus.canceled) {
      style = _BarStyle(
        background: Colors.redAccent.withOpacity(0.2),
        foreground: Colors.redAccent,
        icon: Icons.block,
      );
      label = 'Expired';
    } else if (status == RentalStatus.active) {
      style = _BarStyle(
        background: Colors.greenAccent.withOpacity(0.2),
        foreground: Colors.green.shade700,
        icon: Icons.access_time,
      );
      label = _timeUntilLabel(
        now: now,
        target: dropOffDate,
        suffix: 'until drop-off',
        timePassedLabel: 'Drop-off time passed',
      );
    } else {
      style = _BarStyle(
        background: AppColors.primaryLight,
        foreground: AppColors.textPrimary,
        icon: Icons.access_time,
      );
      label = now.isAfter(pickupDate) ? 'Pickup time passed' : _timeUntilLabel(now: now, target: pickupDate, suffix: 'left for pickup');
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(style.icon, size: 16, color: style.foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: style.foreground,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarStyle {
  const _BarStyle({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}

String _timeUntilLabel({
  required DateTime now,
  required DateTime target,
  required String suffix,
  String timePassedLabel = 'Time passed',
}) {
  final diffMinutes = target.difference(now).inMinutes;
  if (diffMinutes <= 0) return timePassedLabel;

  const minutesPerHour = 60;
  const minutesPerDay = 60 * 24;

  if (diffMinutes < minutesPerDay) {
    final hours = (diffMinutes / minutesPerHour).ceil();
    return '${hours}h $suffix';
  }

  final days = (diffMinutes / minutesPerDay).ceil();
  return '${days}d $suffix';
}
