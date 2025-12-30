import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/bookings/domain/entities/rental_model.dart';
import 'package:car_rental_app/features/chat/data/chat_remote_data_source.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BookRentalDataSource {
  Future<void> fetchUserInfo();
  Future<void> bookRentalCar(RentalModel rentalModel, CarModel carModel, String carOwnerId, String customerName);
  Future<void> saveUserInfo({String? name, String? phoneNumber});
}

class BookRentalDataSourceImpl implements BookRentalDataSource {
  final SupabaseClient client;
  BookRentalDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>?> fetchUserInfo() async {
    //check if user has a phone number or not from user metadata
    final user = client.auth.currentUser;
    if (user == null) return null;

    final userMetadata = user.userMetadata;
    if (userMetadata == null) return null;

    Map<String,dynamic>? userInfo = {};

    final phoneNumber = userMetadata['phone_number'] as String?;
    final name = userMetadata['full_name'] as String?;

    if (phoneNumber != null) {
      userInfo['phone_number'] = phoneNumber;
    }
    if (name != null) {
      userInfo['full_name'] = name;
    }
    print("fetched user info: $userInfo");
    return userInfo;
  }

  @override
  Future<void> bookRentalCar(RentalModel rentalModel, CarModel carModel, String carOwnerId, String customerName) async {
    try{

      await client.from('rentals').insert(rentalModel.toMap());

      //add system message to chat for the owner to either 
      //confirm or rejct the booking request

       //check if car owner has a chat room with the customer
      //if yes, add system message to the chat room
      //if not, create a new chat room
      //add system message to the chat room
      
      final currentUserId = client.auth.currentUser!.id;

      String user1;
      String user2;
      if (currentUserId.compareTo(carOwnerId) > 0) {
        user1 = carOwnerId;
        user2 = currentUserId;
      } else {
        user1 = currentUserId;
        user2 = carOwnerId;
      }
      
      final chatDataSource = ChatRemoteDataSourceImpl(client);

      String? existingConversationId = await chatDataSource.checkIfChatExists(user1: user1, user2: user2);
     

      if(existingConversationId == null){
        //create a new chat room
        await chatDataSource.createChat(receiverId: carOwnerId);
        existingConversationId = await chatDataSource.checkIfChatExists(user1: user1, user2: user2);
      }

      //add system message (booking_request) to chat room
      await chatDataSource.sendSystemMessage(
        conversationId: existingConversationId!,
        message: '''You have a new booking request from $customerName for your ${carModel.title}. 
        Pickup location: ${rentalModel.pickupAddress}
        Pickup time: ${rentalModel.pickupDate}
        Dropoff time: ${rentalModel.dropOffDate}
        Total price: ${rentalModel.totalPrice}
        ''',
        messageType: MessageType.bookingRequest,
        rentalId: rentalModel.id,
      );

      //mark car as not available
      await client.from("cars").update(
        {"available": false}
      ).eq("id", carModel.id);


    }catch(e){
      print("error while booking rental car");
      print(e.toString());
    }
    
  }

  @override
  Future<void> saveUserInfo({String? name, String? phoneNumber}) async {
    try{

    
    final user = client.auth.currentUser;
    if (user == null) return;

    await client.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': name,
          'phone_number': phoneNumber,
        }
      )
    );
  }catch(e){
    print("error while saving user info");
    print(e.toString());
  }
  }
}