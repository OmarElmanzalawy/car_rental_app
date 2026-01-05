import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/features/bookings/data/bookings_data_source.dart';
import 'package:car_rental_app/features/bookings/data/models/rental_with_car_and_user_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'seller_upcoming_rentals_event.dart';
part 'seller_upcoming_rentals_state.dart';

class SellerUpcomingRentalsBloc extends Bloc<SellerUpcomingRentalsEvent, SellerUpcomingRentalsState> {

  final BookingsDatSourceImpl dataSource = BookingsDatSourceImpl(client: Supabase.instance.client);

  SellerUpcomingRentalsBloc() : super(const SellerUpcomingRentalsState()) {
    on<SellerUpcomingCalendarStarted>(_onCalendarStarted);
    on<SellerUpcomingCalendarPrevPage>(_onCalendarPrevPage);
    on<SellerUpcomingCalendarNextPage>(_onCalendarNextPage);
    on<SellerUpcomingCalendarDateSelected>(_onCalendarDateSelected);
    on<SellerUpcomingRentalsFetched>(_onRentalsFetched);
    on<SellerUpcomingConfirmPickupEvent>(_onConfirmPickup);
    on<SellerUpcomingConfirmDropoffEvent>(_onConfirmDropoff);
  }

  Future<void> _onConfirmPickup(
    SellerUpcomingConfirmPickupEvent event,
    Emitter<SellerUpcomingRentalsState> emit,
  ) async {
    try{
      await dataSource.confirmPickup(event.rentalId);
      DialogueService.showAdaptiveSnackBar(event.context, message: "Pickup Confirmed", type: AdaptiveSnackBarType.info);
    }catch(e){
      DialogueService.showAdaptiveSnackBar(event.context, message: e.toString(),type: AdaptiveSnackBarType.error);
    }
    
    //reload rentals,
    add(SellerUpcomingRentalsFetched());
    
  }

  Future<void> _onConfirmDropoff(
    SellerUpcomingConfirmDropoffEvent event,
    Emitter<SellerUpcomingRentalsState> emit,
  ) async {
    try{
      await dataSource.confirmDropoff(event.rentalId);
      DialogueService.showAdaptiveSnackBar(event.context, message: "Dropoff Confirmed", type: AdaptiveSnackBarType.info);
    }catch(e){
      DialogueService.showAdaptiveSnackBar(event.context, message: e.toString(),type: AdaptiveSnackBarType.error);
    }

    //reload rentals,
    add(SellerUpcomingRentalsFetched());
    
  }

  Future<void> _onRentalsFetched(
    SellerUpcomingRentalsFetched event,
    Emitter<SellerUpcomingRentalsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final rentals = await dataSource.fetchSellerUpcomingRentals();
    emit(state.copyWith(isLoading: false, rentals: rentals));
  }

  void _onCalendarStarted(
    SellerUpcomingCalendarStarted event,
    Emitter<SellerUpcomingRentalsState> emit,
  ) {
    final today = _dateOnly(DateTime.now());
    final range = _generateDateRange(
      anchor: today,
      daysBefore: event.daysBefore,
      daysAfter: event.daysAfter,
    );

    final todayIndex = event.daysBefore;
    emit(
      state.copyWith(
        dateRange: range,
        calendarStartIndex: todayIndex,
        clearSelectedDate: true,
      ),
    );
  }

  void _onCalendarPrevPage(
    SellerUpcomingCalendarPrevPage event,
    Emitter<SellerUpcomingRentalsState> emit,
  ) {
    final pageSize = event.pageSize <= 0 ? 1 : event.pageSize;
    final nextIndex = (state.calendarStartIndex - pageSize).clamp(0, state.dateRange.length);
    emit(state.copyWith(calendarStartIndex: nextIndex));
  }

  void _onCalendarNextPage(
    SellerUpcomingCalendarNextPage event,
    Emitter<SellerUpcomingRentalsState> emit,
  ) {
    final pageSize = event.pageSize <= 0 ? 1 : event.pageSize;
    final maxStart = (state.dateRange.length - 1).clamp(0, state.dateRange.length);
    final nextIndex = (state.calendarStartIndex + pageSize).clamp(0, maxStart);
    emit(state.copyWith(calendarStartIndex: nextIndex));
  }

  void _onCalendarDateSelected(
    SellerUpcomingCalendarDateSelected event,
    Emitter<SellerUpcomingRentalsState> emit,
  ) {
    final selected = _dateOnly(event.date);
    final current = state.selectedDate;
    if (current != null && _isSameDay(current, selected)) {
      emit(state.copyWith(clearSelectedDate: true));
      return;
    }

    emit(state.copyWith(selectedDate: selected));
  }

  List<DateTime> _generateDateRange({
    required DateTime anchor,
    required int daysBefore,
    required int daysAfter,
  }) {
    final start = anchor.subtract(Duration(days: daysBefore));
    final end = anchor.add(Duration(days: daysAfter));
    final totalDays = end.difference(start).inDays;
    return List<DateTime>.generate(
      totalDays + 1,
      (i) => _dateOnly(start.add(Duration(days: i))),
      growable: false,
    );
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
