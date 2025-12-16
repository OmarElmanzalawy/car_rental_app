import 'package:car_rental_app/features/bookings/data/models/RentalWithCarDto.dart';
import 'package:car_rental_app/features/bookings/domain/entities/rental_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BookingsDataSource {
  Future<List<Rentalwithcardto>> fetchBookings(String customerId);
  Future<void> cancelBookings(String bookingId);
}

class BookingsDatSourceImpl extends BookingsDataSource{
  final SupabaseClient client;

  BookingsDatSourceImpl({required this.client});


  //fetch booked cars from supabase
  @override
  Future<List<Rentalwithcardto>> fetchBookings(String customerId) async {
  final response = await client
      .from('rentals_with_car')
      .select('*')
      .eq('customer_id', customerId);

  return response
      .map<Rentalwithcardto>((e) => Rentalwithcardto.fromMap(e))
      .toList();
}
  

  @override
  Future<void> cancelBookings(String bookingId) async {

  }

}
