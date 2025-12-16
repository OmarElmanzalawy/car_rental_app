part of 'bookings_cubit.dart';

class BookingsState extends Equatable {
  const BookingsState({
    this.bookings = const [], this.isLoading, this.hasError,
    this.status
    });

  final List<Rentalwithcardto> bookings;
  final bool? isLoading;
  final bool? hasError;
  final RentalStatus? status;

  //copy with helper function
  BookingsState copyWith({
    List<Rentalwithcardto>? bookings,
    bool? isLoading,
    bool? hasError,
  }){
    return BookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  @override
  List<Object?> get props => [bookings,isLoading,hasError];
  


}


