import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/bookings/presentation/seller/widgets/seller_calendar_strip.dart';
import 'package:car_rental_app/features/bookings/presentation/seller/widgets/seller_upcoming_rental_card.dart';
import 'package:flutter/material.dart';

class UpcomingRentalsScreen extends StatelessWidget {
  const UpcomingRentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headerHeight = size.height * 0.24;

    final days = <SellerCalendarDay>[
      const SellerCalendarDay(weekday: 'Mon', day: 26),
      const SellerCalendarDay(weekday: 'Tue', day: 27),
      const SellerCalendarDay(weekday: 'Wed', day: 28),
      const SellerCalendarDay(weekday: 'Thu', day: 29),
      const SellerCalendarDay(weekday: 'Fri', day: 30),
      const SellerCalendarDay(weekday: 'Sat', day: 31),
      const SellerCalendarDay(weekday: 'Sun', day: 1),
    ];

    final bookings = <_UpcomingRentalUiModel>[
      const _UpcomingRentalUiModel(
        relativeDayLabel: 'Today',
        renterName: 'Alice Green',
        totalAmountLabel: '\$240',
        carTitle: 'Land Rover LR3',
        dateRangeLabel: 'Oct 28 - Oct 30',
        status: RentalStatus.approved,
        actionLabel: 'Confirm Pickup (Oct 28, 10:00 AM)',
      ),
      const _UpcomingRentalUiModel(
        relativeDayLabel: 'Ongoing',
        renterName: 'Bob Johnson',
        totalAmountLabel: '\$360',
        carTitle: 'Audi R8',
        dateRangeLabel: 'Oct 27 - Oct 29',
        status: RentalStatus.active,
        actionLabel: 'Confirm Return (Oct 29, 04:00 PM)',
      ),
      const _UpcomingRentalUiModel(
        relativeDayLabel: 'Yesterday',
        renterName: 'Charlie Brown',
        totalAmountLabel: '\$200',
        carTitle: 'Tesla Model 3',
        dateRangeLabel: 'Oct 26 - Oct 28',
        status: RentalStatus.completed,
      ),
    ];

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: headerHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade600,
                            Colors.grey.shade900,
                            // Colors.blue.shade600,
                          ],
                        ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Calendar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                        'Oct 26 - Nov 1, 2025',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    SellerCalendarStrip(
                      days: days,
                      selectedIndex: 2,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upcoming bookings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListView.separated(
                      itemCount: bookings.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return SellerUpcomingRentalCard(
                          avatarImagePath: 'assets/images/profile.jpg',
                          relativeDayLabel: booking.relativeDayLabel,
                          renterName: booking.renterName,
                          totalAmountLabel: booking.totalAmountLabel,
                          carTitle: booking.carTitle,
                          dateRangeLabel: booking.dateRangeLabel,
                          status: booking.status,
                          actionLabel: booking.actionLabel,
                          onActionPressed: booking.actionLabel == null ? null : () {},
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingRentalUiModel {
  const _UpcomingRentalUiModel({
    required this.relativeDayLabel,
    required this.renterName,
    required this.totalAmountLabel,
    required this.carTitle,
    required this.dateRangeLabel,
    required this.status,
    this.actionLabel,
  });

  final String relativeDayLabel;
  final String renterName;
  final String totalAmountLabel;
  final String carTitle;
  final String dateRangeLabel;
  final RentalStatus status;
  final String? actionLabel;
}
