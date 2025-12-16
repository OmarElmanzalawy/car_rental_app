import 'package:flutter/material.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';

class RentalCard extends StatelessWidget {
  const RentalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.dateText,
    required this.timeText,
    required this.locationText,
    required this.statusBarText,
    required this.totalText,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String statusLabel;
  final String dateText;
  final String timeText;
  final String locationText;
  final String statusBarText;
  final String totalText;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(statusLabel, style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.silverAccent.withOpacity(0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(imageUrl ?? 'assets/images/logo.png', fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(dateText, style: const TextStyle(fontSize: 13, color: Colors.black)),
              const SizedBox(width: 14),
              Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(timeText, style: const TextStyle(fontSize: 13, color: Colors.black)),
              const SizedBox(width: 14),
              Icon(Icons.place, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(locationText, style: const TextStyle(fontSize: 13, color: Colors.black), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(statusBarText, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(totalText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                ],
              ),
              const Spacer(),
              _OutlinedPill(label: 'Reschedule'),
              const SizedBox(width: 8),
              _OutlinedPill(label: 'Cancel', borderColor: Colors.redAccent, textColor: Colors.redAccent),
              const SizedBox(width: 8),
              _FilledPill(label: 'Detail'),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutlinedPill extends StatelessWidget {
  const _OutlinedPill({required this.label, this.borderColor, this.textColor});
  final String label;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Color border = borderColor ?? AppColors.border;
    final Color text = textColor ?? Colors.black;
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.w600)),
    );
  }
}

class _FilledPill extends StatelessWidget {
  const _FilledPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
