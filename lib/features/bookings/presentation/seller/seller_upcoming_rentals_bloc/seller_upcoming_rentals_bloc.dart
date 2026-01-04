import 'package:bloc/bloc.dart';
import 'package:car_rental_app/features/bookings/data/bookings_data_source.dart';
import 'package:car_rental_app/features/bookings/data/models/rental_with_car_and_user_dto.dart';
import 'package:equatable/equatable.dart';
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
        selectedDate: today,
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
    emit(state.copyWith(selectedDate: _dateOnly(event.date)));
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
}
