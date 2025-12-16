import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/bookings/data/bookings_data_source.dart';
import 'package:car_rental_app/features/bookings/data/models/RentalWithCarDto.dart';
import 'package:car_rental_app/features/bookings/domain/entities/rental_model.dart';
import 'package:equatable/equatable.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingsDataSource repository;
  BookingsCubit(this.repository) : super(BookingsState());
  
  
  void getBookings(String customerId) async {
    emit(state.copyWith(isLoading: true));
    // try {
      final bookings = await repository.fetchBookings(customerId);
      emit(state.copyWith(bookings: bookings, isLoading: false));
    // } catch (e) {
      // print("Error fetching bookings: ${e.toString()}");
      // emit(state.copyWith(hasError: true, isLoading: false));
    // }
  }
  @override
  Future<void> close() {
    return super.close();
  }

}
