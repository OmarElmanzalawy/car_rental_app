import 'package:car_rental_app/core/constants/app_colors.dart';
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
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
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
                                            .add(SellerUpcomingCalendarPrevPage(pageSize: pageSize))
                                        : null,
                                    icon: const Icon(Icons.chevron_left, color: Colors.white),
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
                                            .add(SellerUpcomingCalendarNextPage(pageSize: pageSize))
                                        : null,
                                    icon: const Icon(Icons.chevron_right, color: Colors.white),
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
                Container(
                  width: double.infinity,
                  color: AppColors.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
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
                        if (state.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          )
                        else if (state.rentals.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No upcoming bookings',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            itemCount: state.rentals.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final rental = state.rentals[index];
                              return SellerUpcomingRentalCard(
                                rental: rental,
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
      },
    );
  }
}
