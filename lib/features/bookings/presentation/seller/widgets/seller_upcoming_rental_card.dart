import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/status_chip.dart';
import 'package:car_rental_app/features/bookings/seller/widgets/seller_rental_progress_bar.dart';
import 'package:flutter/material.dart';

class SellerUpcomingRentalCard extends StatelessWidget {
  const SellerUpcomingRentalCard({
    super.key,
    required this.avatarImagePath,
    required this.relativeDayLabel,
    required this.renterName,
    required this.totalAmountLabel,
    required this.carTitle,
    required this.dateRangeLabel,
    required this.status,
    this.startDate,
    this.endDate,
    this.actionLabel,
    this.onActionPressed,
  });

  final String avatarImagePath;
  final String relativeDayLabel;
  final String renterName;
  final String totalAmountLabel;
  final String carTitle;
  final String dateRangeLabel;
  final RentalStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final hasAction = actionLabel != null && onActionPressed != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(avatarImagePath),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      relativeDayLabel,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      renterName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    totalAmountLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/icons/car_placeholder.png',
                  width: 74,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     TextButton(
                    onPressed: (){
                      //Todo open google maps to the pickup address location
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: Colors.transparent,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: AppColors.textPrimary,),
                        const SizedBox(width: 4),
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    )
                     ),
                    const SizedBox(height: 2),
                    Text(
                      carTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                     Text(
                    dateRangeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (status == RentalStatus.active &&
                        startDate != null &&
                        endDate != null) ...[
                      const SizedBox(height: 10),
                      SellerRentalProgressBar(
                        start: startDate!,
                        end: endDate!,
                        now: DateTime.now(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // SellerStatusPill(status: status),
               StatusChip(
                      statusChipColor: AppUtils.getStatusChipColor(status),
                      statusChipLabel: status.label,
                ),
            ],
          ),
          if (hasAction) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                label: actionLabel!,
                onPressed: onActionPressed!,
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
}

