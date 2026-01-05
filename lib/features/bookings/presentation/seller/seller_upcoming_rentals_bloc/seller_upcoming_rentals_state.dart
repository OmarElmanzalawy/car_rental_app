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

  //getter for selected rentals
  List<RentalWithCarAndUserDto> get selectedRentals {
    if (selectedDate == null) return [];
    final dayStart = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );
    final dayEnd = dayStart.add(const Duration(days: 1));

    return rentals.where((rental) {
      final start = rental.pickupDate;
      final end = rental.dropOffDate;
      return start.isBefore(dayEnd) && end.isAfter(dayStart);
    }).toList();
  } 

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
