part of 'bookings_cubit.dart';

class BookingsState extends Equatable {
  const BookingsState({
    this.bookings = const [],
    this.isLoading = true,
    this.hasError,
    this.selectedStatus,
    this.selectedFilterIndex = 0,
    });

  final List<Rentalwithcardto> bookings;
  final bool isLoading;
  final bool? hasError;
  final RentalStatus? selectedStatus;
  final int selectedFilterIndex;

  List<Rentalwithcardto> get visibleBookings {
    final status = selectedStatus;
    if (status == null) return bookings;
    return bookings.where((b) => b.status == status).toList(growable: false);
  }

  //copy with helper function
  BookingsState copyWith({
    List<Rentalwithcardto>? bookings,
    bool? isLoading,
    bool? hasError,
    RentalStatus? selectedStatus,
    bool clearSelectedStatus = false,
    int? selectedFilterIndex,
  }){
    return BookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      selectedStatus: clearSelectedStatus ? null : (selectedStatus ?? this.selectedStatus),
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
    );
  }

  @override
  List<Object?> get props => [
    bookings,
    isLoading,
    hasError,
    selectedStatus,
    selectedFilterIndex,
  ];
  


}

