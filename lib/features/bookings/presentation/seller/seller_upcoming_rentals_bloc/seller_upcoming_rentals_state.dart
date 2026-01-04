part of 'seller_upcoming_rentals_bloc.dart';

class SellerUpcomingRentalsState extends Equatable {
  const SellerUpcomingRentalsState({
    this.rentals = const [],
    this.isLoading = false,
    this.dateRange = const [],
    this.calendarStartIndex = 0,
    this.selectedDate,
  });

  final List<RentalWithCarAndUserDto> rentals;
  final bool isLoading;
  final List<DateTime> dateRange;
  final int calendarStartIndex;
  final DateTime? selectedDate;

  //copy with method
  SellerUpcomingRentalsState copyWith({
    List<RentalWithCarAndUserDto>? rentals,
    bool? isLoading,
    List<DateTime>? dateRange,
    int? calendarStartIndex,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) {
    return SellerUpcomingRentalsState(
      rentals: rentals ?? this.rentals,
      isLoading: isLoading ?? this.isLoading,
      dateRange: dateRange ?? this.dateRange,
      calendarStartIndex: calendarStartIndex ?? this.calendarStartIndex,
      selectedDate: clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
    );
  }
  
  @override
  List<Object?> get props => [rentals, isLoading, dateRange, calendarStartIndex, selectedDate];
}

