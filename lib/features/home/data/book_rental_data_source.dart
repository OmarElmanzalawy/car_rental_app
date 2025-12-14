import 'package:car_rental_app/features/home/domain/entities/rental_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BookRentalDataSource {
  Future<void> fetchUserInfo();
  Future<void> bookRentalCar(RentalModel rental);
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
  Future<void> bookRentalCar(RentalModel rentalModel) async {
    try{
      await client.from('rentals').insert(rentalModel.toMap());
    }catch(e){
      print("error while booking rental car");
      print(e.toString());
    }
    
  }

  //TODO COMPLETE THIS FUNCTION
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