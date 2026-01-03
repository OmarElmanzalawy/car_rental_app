import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/bookings/data/models/RentalWithCarDto.dart';
import 'package:car_rental_app/features/bookings/presentation/blocs/bookings/bookings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RentalCard extends StatelessWidget {
  const RentalCard({
    super.key,
    required this.rental,
  });

  // final String title;
  // final String statusLabel;
  // final String dateText;
  // final String timeText;
  // final String locationText;
  // final String statusBarText;
  // final String totalText;
  // final String? imageUrl;

  final Rentalwithcardto rental;

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
                child: Text(rental.carName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(AppUtils.capitalize(rental.status.name), style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
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
            child:  CachedNetworkImage(
              imageUrl:  rental.carImageUrl.first ?? 'assets/images/logo.png',
              errorWidget: (context, error, stackTrace) {
                return Image.asset('assets/images/logo.png', fit: BoxFit.cover);
              },
              fit: BoxFit.cover,
              ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text( AppUtils.toDayMonth(rental.pickupDate), style: const TextStyle(fontSize: 13, color: Colors.black)),
              const SizedBox(width: 14),
              Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(AppUtils.toReadableTime(rental.pickupDate), style: const TextStyle(fontSize: 13, color: Colors.black)),
              const SizedBox(width: 14),
              Icon(Icons.place, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(rental.pickupAddress, style: const TextStyle(fontSize: 13, color: Colors.black), overflow: TextOverflow.ellipsis)),
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
                Text(AppUtils.timeLeftForPickup(rental.pickupDate), style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
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
                  Text('\$${rental.totalPrice.toStringAsFixed(1)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                ],
              ),
              const Spacer(),
              _OutlinedPill(label: 'Reschedule'),
              const SizedBox(width: 8),
              _OutlinedPill(
                label: 'Cancel',
                borderColor: Colors.redAccent,
                textColor: Colors.redAccent,
                onPressed: () {
                  //show alert dialogue
                  DialogueService.showAdaptiveAlertDialog(
                    context, 
                    title: 'Cancel Booking', 
                    content: 'Are you sure you want to cancel this booking?', 
                    actions: [
                      AlertAction(
                        title: 'Back',
                        onPressed: () {},

                        ),
                      AlertAction(
                        title: 'Cancel Booking',
                      style: AlertActionStyle.destructive,
                       onPressed: () async{
                        await context.read<BookingsCubit>().cancelBooking(rentalId: rental.id,carId: rental.carId);
                      }), 
                    ],
                  );

                  //if user confirms then cancel booking
                },
                ),
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
  const _OutlinedPill({required this.label, this.borderColor, this.textColor,this.onPressed});
  final String label;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Color border = borderColor ?? AppColors.border;
    final Color text = textColor ?? Colors.black;
    return OutlinedButton(
      onPressed: onPressed ?? () {},
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
