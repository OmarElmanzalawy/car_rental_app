import 'package:bloc/bloc.dart';
import 'package:car_rental_app/features/profile/data/profile_remote_data_source.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'customer_profile_state.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  CustomerProfileCubit() : super(CustomerProfileState());

  Future<void> init()async{
    await getProfileInfo();
    await getProfilePictureUrl();
  }

  Future<XFile?> selectProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? profilePicture = await picker.pickImage(source: ImageSource.gallery);
    print(profilePicture);
    return profilePicture;
  }

  Future<void> updateProfilePicture(XFile? profilePicture)async{
    print("upload to supabase storage");
    emit(state.copyWith(isFetchingProfilePicture: true));
    // upload to supabase storage
    final imageUrl = await ProfileRemoteDataSourceImpl(Supabase.instance.client).uploadProfilePicture(profilePicture);

    if(imageUrl != null){
      emit(state.copyWith(profilePictureUrl: imageUrl,isFetchingProfilePicture: false));
    }
  }

  Future<void> getProfilePictureUrl() async {
    emit(state.copyWith(isFetchingProfilePicture: true));
    final profilePictureUrl = await ProfileRemoteDataSourceImpl(Supabase.instance.client).getProfilePictureUrl();
    if(profilePictureUrl != null){
      emit(state.copyWith(profilePictureUrl: profilePictureUrl,isFetchingProfilePicture: false));
    }
  }
 
 Future<void> getProfileInfo()async{
    emit(state.copyWith(isLoading: true));
    final displayName = ProfileRemoteDataSourceImpl(Supabase.instance.client).getDisplayName();
    final phoneNumber = ProfileRemoteDataSourceImpl(Supabase.instance.client).getPhoneNumber();
    final email = Supabase.instance.client.auth.currentUser?.email;
    if(displayName != null || phoneNumber != null || email != null){
      emit(state.copyWith(displayName: displayName,phoneNumber: phoneNumber,email: email,isLoading: false));
    }
 }

}
