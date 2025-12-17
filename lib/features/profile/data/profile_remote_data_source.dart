import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<String?> uploadProfilePicture(XFile? profilePicture);
  Future<String?> getProfilePictureUrl();
  String? getPhoneNumber();
  String? getDisplayName();
  Future<void> updatePhoneNumber(String phoneNumber);
  Future<void> updateDisplayName(String displayName);
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final SupabaseClient client;

  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<String?> uploadProfilePicture(XFile? profilePicture) async {
    try{
    if (profilePicture == null) {
      return null;
    }
    final bytes = await profilePicture.readAsBytes();
    final String fileName = "${client.auth.currentUser!.id}.jpg";

    final String filePath = "profile_images/$fileName";

    await client.storage.from("app_uploads").uploadBinary(
      filePath,
       bytes,
       fileOptions: FileOptions(upsert: true,contentType: "image/jpeg"),
       );

    final imageUrl = client.storage.from("app_uploads").getPublicUrl(filePath);
    
    //update user metadata
    await client.auth.updateUser(
      UserAttributes(
        data: {
          "profile_picture_url": imageUrl,
        }
      )
    );

    return imageUrl;
    }catch(e){
      print("error while uploading profile image to supabase storage");
      print(e.toString());
      return null;
    }
  }
  
  @override
  Future<String?> getProfilePictureUrl() async {
    try{
    final user = client.auth.currentUser;
    if (user == null) {
      return null;
    }
    final profilePictureUrl = user.userMetadata?["profile_picture_url"] as String?;
    print("fetched profilePictureUrl: $profilePictureUrl");
    return profilePictureUrl;
    }catch(e){
      print("error while getting profile image url from supabase storage");
      print(e.toString());
      return null;
    }
  }

  @override
  String? getPhoneNumber() {
    try{
    final user = client.auth.currentUser;
    if (user == null) {
      return null;
    }
    final phoneNumber = user.userMetadata?["phone_number"] as String?;
    return phoneNumber;
    }catch(e){
      print("error while getting phone number from supabase storage");
      print(e.toString());
      return null;
    }
  }

  @override
  String? getDisplayName(){
    try{
    final user = client.auth.currentUser;
    if (user == null) {
      return null;
    }
    final displayName = user.userMetadata?["full_name"] as String?;
    return displayName;
    }catch(e){
      print("error while getting display name from supabase storage");
      print(e.toString());
      return null;
    }
  }

  @override
  Future<void> updatePhoneNumber(String phoneNumber) async {
    // update phone number in supabase
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    // update display name in supabase
  }

}