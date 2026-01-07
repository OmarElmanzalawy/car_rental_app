part of 'seller_upcoming_rentals_bloc.dart';

abstract class SellerUpcomingRentalsEvent extends Equatable {
  const SellerUpcomingRentalsEvent();

  @override
  List<Object> get props => [];
}

class SellerUpcomingRentalsFetched extends SellerUpcomingRentalsEvent {
  
}

class SellerUpcomingConfirmPickupEvent extends SellerUpcomingRentalsEvent {

  final String rentalId;
  final BuildContext context;

  const SellerUpcomingConfirmPickupEvent({required this.rentalId, required this.context});

  @override
  List<Object> get props => [rentalId];
}

class SellerUpcomingConfirmDropoffEvent extends SellerUpcomingRentalsEvent {
  final String rentalId;
  //we need this here to mark the car as available after dropoff confirmation
  final String carId;
  final BuildContext context;

  const SellerUpcomingConfirmDropoffEvent({required this.rentalId, required this.carId, required this.context});

  @override
  List<Object> get props => [rentalId,carId];
}

class SellerUpcomingCalendarStarted extends SellerUpcomingRentalsEvent {
  const SellerUpcomingCalendarStarted({
    this.daysBefore = 20,
    this.daysAfter = 20,
  });

  final int daysBefore;
  final int daysAfter;

  @override
  List<Object> get props => [daysBefore, daysAfter];
}

class SellerUpcomingCalendarPrevPage extends SellerUpcomingRentalsEvent {
  const SellerUpcomingCalendarPrevPage({required this.pageSize});

  final int pageSize;

  @override
  List<Object> get props => [pageSize];
}

class SellerUpcomingCalendarNextPage extends SellerUpcomingRentalsEvent {
  const SellerUpcomingCalendarNextPage({required this.pageSize});

  final int pageSize;

  @override
  List<Object> get props => [pageSize];
}

class SellerUpcomingCalendarDateSelected extends SellerUpcomingRentalsEvent {
  const SellerUpcomingCalendarDateSelected({required this.date});

  final DateTime date;

  @override
  List<Object> get props => [date];
}

class SellerUpcomingFilterRentalsByDateEvent extends SellerUpcomingRentalsEvent {
  const SellerUpcomingFilterRentalsByDateEvent({
    required this.date
  });

  final DateTime date;

  @override
  List<Object> get props => [date];
}
