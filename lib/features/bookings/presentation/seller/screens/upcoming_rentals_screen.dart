import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/bookings/presentation/seller/seller_upcoming_rentals_bloc/seller_upcoming_rentals_bloc.dart';
import 'package:car_rental_app/features/bookings/presentation/seller/widgets/seller_calendar_strip.dart';
import 'package:car_rental_app/features/bookings/presentation/seller/widgets/seller_upcoming_rental_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingRentalsScreen extends StatelessWidget {
  const UpcomingRentalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SellerUpcomingRentalsBloc()..add(const SellerUpcomingCalendarStarted())..add(SellerUpcomingRentalsFetched()),
      child: const _UpcomingRentalsView(),
    );
  }
}

class _UpcomingRentalsView extends StatelessWidget {
  const _UpcomingRentalsView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headerHeight = size.height * 0.25;

    const tileWidth = 54.0;
    const spacing = 10.0;
    const horizontalPadding = 16.0;
    final availableWidth = size.width - (horizontalPadding * 2);
    final pageSize = ((availableWidth + spacing) / (tileWidth + spacing)).floor().clamp(1, 20);

    return BlocBuilder<SellerUpcomingRentalsBloc, SellerUpcomingRentalsState>(
      builder: (context, state) {
        final start = state.calendarStartIndex.clamp(0, state.dateRange.isEmpty ? 0 : state.dateRange.length - 1);
        final end = (start + pageSize).clamp(0, state.dateRange.length);
        final visibleDates =
            state.dateRange.isEmpty ? const <DateTime>[] : state.dateRange.sublist(start, end);

        final canGoPrev = start > 0;
        final canGoNext = end < state.dateRange.length;
        final calendarRangeLabel = visibleDates.isEmpty
            ? ''
            : '${AppUtils.toDayMonth(visibleDates.first)} - ${AppUtils.toDayMonth(visibleDates.last)}, ${visibleDates.last.year}';
        final displayedRentals = state.selectedDate == null ? state.rentals : state.selectedRentals;

        return Container(
          color: AppColors.background,
          // RefreshIndicator(
          // color: AppColors.primary,
          // backgroundColor: AppColors.background,
          // onRefresh: () async {
          //   await context.read<BookingsCubit>().getBookings(Supabase.instance.client.auth.currentUser!.id);
          // },
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
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: canGoPrev
                                        ? () => context
                                            .read<SellerUpcomingRentalsBloc>()
                                            .add(
                                              SellerUpcomingCalendarPrevPage(
                                                pageSize: pageSize,
                                              ),
                                            )
                                        : null,
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Calendar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: canGoNext
                                        ? () => context
                                            .read<SellerUpcomingRentalsBloc>()
                                            .add(
                                              SellerUpcomingCalendarNextPage(
                                                pageSize: pageSize,
                                              ),
                                            )
                                        : null,
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                calendarRangeLabel,
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
                          dates: visibleDates,
                          selectedDate: state.selectedDate,
                          onChanged: (date) => context
                              .read<SellerUpcomingRentalsBloc>()
                              .add(SellerUpcomingCalendarDateSelected(date: date)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: AppColors.primary,
          backgroundColor: AppColors.background,
          onRefresh: () async {
            context.read<SellerUpcomingRentalsBloc>().add(SellerUpcomingRentalsFetched());
          },
                    child: Container(
                      width: double.infinity,
                      color: AppColors.background,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 16,
                        ),
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
                            Expanded(
                              child:   state.isLoading ?
                                    ListView.separated(
                                      itemCount: 5,
                                      padding: EdgeInsets.zero,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        return const SellerUpcomingRentalShimmerCard();
                                      },
                                    ) :
                                  
                                
                                  displayedRentals.isEmpty ?
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.event,
                                            size: 80,
                                            color: Colors.grey.shade700,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            state.selectedDate == null
                                                ? 'No upcoming bookings'
                                                : 'No bookings for this date',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ) :
                                  
                                
                                  ListView.separated(
                                    itemCount: displayedRentals.length,
                                    padding: const EdgeInsets.only(bottom: 24),
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final rental = displayedRentals[index];
                                      
                                      print("${rental.carTitle} pick up time: ${rental.pickupDate.hour}:${rental.pickupDate.minute}");

                                      final isPickUpWithin3Hours = AppUtils.isWithin2Hours(rental.pickupDate);
                                      final isDropoffWithin3Hours = AppUtils.isWithin2Hours(rental.dropOffDate);
                                      final canConfirmPickup = rental.status == RentalStatus.approved && isPickUpWithin3Hours;
                                      final canConfirmDropoff = rental.status == RentalStatus.active && isDropoffWithin3Hours;

                                      print(isDropoffWithin3Hours ? 'Return time is within 3 hours' : 'Return time is not within 3 hours');
                                      print(isPickUpWithin3Hours ? 'Pick up time is within 3 hours' : 'Pick up time is not within 3 hours');
                                  
                                      return SellerUpcomingRentalCard(
                                        rental: rental,
                                        actionLabel: canConfirmPickup
                                            ? 'Confirm pickup'
                                            : (canConfirmDropoff ? 'Confirm return' : null),
                                        onActionPressed: (canConfirmPickup || canConfirmDropoff)
                                            ? () async {

                                          if (canConfirmPickup) {
                                            //invoke pickup confirmed event
                                            await DialogueService.showAdaptiveAlertDialog(
                                              context,
                                              title: 'Confirm Pickup',
                                              content: 'You are confirming that the car has been picked up at the specified time. This action cannot be undone.',
                                              actions: [
                                                AlertAction(
                                                  title: "Confirm",
                                                  onPressed: () {
                                                    context.read<SellerUpcomingRentalsBloc>().add(SellerUpcomingConfirmPickupEvent(rentalId: rental.id, context: context));
                                                  },
                                                  style: AlertActionStyle.primary,
                                                  ),
                                                  AlertAction(
                                                  title: "Cancel",  
                                                  onPressed: (){
                                                    
                                                  },
                                                  )
                                              ]
                                            );
                                          } else if (canConfirmDropoff) {
                                            //invoke return confirmed event
                                            await DialogueService.showAdaptiveAlertDialog(
                                              context,
                                              title: 'Confirm Dropoff',
                                              content: 'You are confirming that the car has been dropped off at the specified time. This action cannot be undone.',
                                              actions: [
                                                AlertAction(
                                                  title: "Confirm",
                                                  onPressed: (){
                                                    context.read<SellerUpcomingRentalsBloc>().add(SellerUpcomingConfirmDropoffEvent(rentalId: rental.id,context: context));
                                                  },
                                                  style: AlertActionStyle.success,
                                                  ),
                                                  AlertAction(
                                                  title: "Cancel",
                                                  onPressed: (){
                                                    
                                                  },
                                                  )
                                              ]
                                            );
                                          }
                                        }
                                            : null
                                        ) ;
                                    },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        );
      },
    );
  }
}
