import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/status_chip.dart';
import 'package:car_rental_app/features/bookings/data/models/rental_with_car_and_user_dto.dart';
import 'package:car_rental_app/features/bookings/seller/widgets/seller_rental_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SellerUpcomingRentalCard extends StatelessWidget {
  const SellerUpcomingRentalCard({
    super.key,
    required this.rental,
    this.actionLabel,
    this.onActionPressed,
  });

  final RentalWithCarAndUserDto rental;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final hasAction = actionLabel != null && onActionPressed != null;
    final totalAmountLabel = '\$${rental.totalPrice.toStringAsFixed(0)}';
    final dateRangeLabel =
        '${AppUtils.toDayMonth(rental.pickupDate)} - ${AppUtils.toDayMonth(rental.dropOffDate)}';
    final relativeDayLabel = _relativeDayLabel(rental: rental);
    // final avatarUrl = rental.customerProfileImage.trim();
    final carImageUrl = rental.carImages.isNotEmpty ? rental.carImages.first.trim() : '';

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
                backgroundImage:
                    rental.customerProfileImage != null ? CachedNetworkImageProvider(rental.customerProfileImage!) : null,
                backgroundColor: rental.customerProfileImage == null ? AppColors.silverAccent : null,
                child: rental.customerProfileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 22,
                        color: Colors.black54,
                      )
                    : null,
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
                      rental.customerFullName,
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
                child: carImageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: carImageUrl,
                        width: 74,
                        height: 56,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(
                              value: progress.progress,
                            ),
                          );
                        },
                        errorWidget: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/icons/car_placeholder.png',
                            width: 74,
                            height: 56,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
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
                          rental.pickupAddress,
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
                      rental.carTitle,
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
                        rental.pickupDate.isBefore(rental.dropOffDate)) ...[
                      const SizedBox(height: 10),
                      SellerRentalProgressBar(
                        start: rental.pickupDate,
                        end: rental.dropOffDate,
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

  RentalStatus get status => rental.status;

  String _relativeDayLabel({required RentalWithCarAndUserDto rental}) {
    if (rental.status == RentalStatus.active) return 'Ongoing';

    final today = _dateOnly(DateTime.now());
    final pickup = _dateOnly(rental.pickupDate);
    final diffDays = pickup.difference(today).inDays;

    if (diffDays == 0) return 'Today';
    if (diffDays == 1) return 'Tomorrow';
    if (diffDays == -1) return 'Yesterday';
    return '${pickup.day}/${pickup.month}';
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
