import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/core/widgets/adaptive_custom_segment_control.dart';
import 'package:car_rental_app/features/bookings/presentation/blocs/bookings/bookings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_app/features/bookings/presentation/widgets/rental_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AdaptiveScaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.background,
          onRefresh: () async {
            await context.read<BookingsCubit>().getBookings(Supabase.instance.client.auth.currentUser!.id);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "My Bookings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AdaptiveCustomSegmentControl(
                    labels: ['Upcoming', 'Complete', 'Cancelled'],
                    selectedIndex: 0,
                    onValueChanged: (value){}
                  ),
                  const SizedBox(height: 14),
                  BlocBuilder<BookingsCubit, BookingsState>(
                    builder: (context, state) {
                      return state.isLoading ? 
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            children: List.generate(
                              3, 
                              (index) => Container(
                                height: 200,
                                width: size.width,
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              )
                            ),
                          ),
                        )
                      : state.bookings.isEmpty
                      ? const Center(
                          child: Text(
                            "No Bookings",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Column(
                          children: state.bookings.map((booking) => 
                          RentalCard(
                            imageUrl: booking.carImageUrl.first,
                            title: booking.carName,
                            statusLabel: booking.status.name,
                            dateText: AppUtils.toDayMonth(booking.pickupDate),
                            timeText: AppUtils.toReadableTime(booking.pickupDate),
                            locationText: booking.pickupAddress,
                            statusBarText: AppUtils.timeLeftForPickup(booking.pickupDate),
                            totalText: '\$${booking.totalPrice.toStringAsFixed(1)}',
                          )).toList(),
                        );
                    },
                  ),
                  // RentalCard(
                  //   title: 'Audi Q7',
                  //   subtitle: 'Luxury',
                  //   statusLabel: 'Upcoming',
                  //   dateText: 'Oct 8, 2025',
                  //   timeText: '2:00 PM',
                  //   locationText: '123 Main St',
                  //   statusBarText: '2d left until pickup',
                  //   totalText: '\$245',
                  //   imageUrl: 'assets/images/test_cars/supra.png',
                  // ),
                  // const SizedBox(height: 12),
                  // RentalCard(
                  //   title: 'Audi Q7',
                  //   subtitle: 'Luxury',
                  //   statusLabel: 'Upcoming',
                  //   dateText: 'Oct 12, 2025',
                  //   timeText: '10:00 AM',
                  //   locationText: 'Downtown Garage',
                  //   statusBarText: '5d left until pickup',
                  //   totalText: '\$245',
                  //   imageUrl: 'assets/images/test_cars/bmw.jpg',
                  // ),
                  const SizedBox(height: 80,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


