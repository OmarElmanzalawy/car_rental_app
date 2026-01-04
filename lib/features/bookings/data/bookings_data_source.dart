import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/bookings/data/models/RentalWithCarDto.dart';
import 'package:car_rental_app/features/bookings/data/models/rental_with_car_and_user_dto.dart';
import 'package:car_rental_app/features/bookings/domain/entities/rental_model.dart';
import 'package:car_rental_app/features/chat/data/chat_remote_data_source.dart';
import 'package:car_rental_app/features/chat/domain/entities/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class BookingsDataSource {
  Future<List<Rentalwithcardto>> fetchBookings(String customerId);
  Future<void> cancelBookings({required String rentalId,required String carId});
  Future<Map<String,dynamic>> fetchCarModel(String carId);
  Future<List<RentalWithCarAndUserDto>> fetchSellerUpcomingRentals();
}

class BookingsDatSourceImpl extends BookingsDataSource{
  final SupabaseClient client;

  BookingsDatSourceImpl({required this.client});

  @override
  Future<List<RentalWithCarAndUserDto>> fetchSellerUpcomingRentals() async {
    final response = await client
      .from('rentals_with_car_and_user')
      .select('*')
      .eq('seller_id', client.auth.currentUser!.id);

    return response
      .map<RentalWithCarAndUserDto>((e) => RentalWithCarAndUserDto.fromJson(e))
      .toList();
  }

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

Future<Map<String,dynamic>> fetchCarModel(String carId)async{
  final response = await client
      .from('cars')
      .select('*')
      .eq('id', carId)
      .single();

  return response;
}



 @override
Future<void> cancelBookings({required String rentalId,required String carId}) async {

  try{

    final chatService = ChatRemoteDataSourceImpl(client);

  // 1. Fetch car_id FIRST
  final rental = await client
      .from("rentals")
      .select("car_id")
      .eq("id", rentalId)
      .single();

  final String carId = rental["car_id"];

  // 2. change rental status to cancelled
  await client.from("rentals").update({"status": RentalStatus.canceled.name}).eq("id", rentalId);

  // 3. Mark car as available
  await client
      .from("cars")
      .update({"available": true})
      .eq("id", carId);

  // 4. get car owner id
  final String carOwnerId = (await client
      .from("cars")
      .select("owner_id")
      .eq("id", carId)
      .single())["owner_id"];

  // 5. fetch conversation id 
      final String currentUserId = client.auth.currentUser!.id;
      final String user1;
      final String user2;

      if (currentUserId.compareTo(carOwnerId) < 0) {
        user1 = currentUserId;
        user2 = carOwnerId;
      } else {
        user1 = carOwnerId;
        user2 = currentUserId;
      }

    final chatId = await chatService.checkIfChatExists(user1: user1, user2: user2);

      if(chatId == null){
        return;
      }

    print("chat found, sending system message...");

  // 6. send an info system message to the customer
  chatService.sendSystemMessage(
    conversationId: chatId,
    messageType: MessageType.info,
    message: "Booking has been cancelled by customer",
  );

}catch(e){
  print("something went wrong while canceling the booking");
  print(e.toString());
}
}

}
