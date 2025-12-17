part of 'customer_profile_cubit.dart';

class CustomerProfileState extends Equatable {
  const CustomerProfileState({
    this.displayName,
    this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.isLoading = true,
    this.isFetchingProfilePicture = true,
  }
  );

  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final bool isLoading; 
  final bool isFetchingProfilePicture;

  CustomerProfileState copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    bool? isLoading,
    bool? isFetchingProfilePicture,
  }) {
    return CustomerProfileState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isLoading: isLoading ?? this.isLoading,
      isFetchingProfilePicture: isFetchingProfilePicture ?? this.isFetchingProfilePicture,
    );
  }

  @override
  List<Object?> get props => [displayName, email, phoneNumber, profilePictureUrl,isLoading,isFetchingProfilePicture];
}
