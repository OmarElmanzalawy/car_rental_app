import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RentalWithCarAndUserDto {
  final String id;
  final String customerId;
  final String carId;
  final DateTime pickupDate;
  final DateTime dropOffDate;
  final double totalPrice;
  final RentalStatus status;
  final String pickupAddress;
  final LatLng pickupLoc;
  final DateTime createdAt;
  final String carTitle;
  final List<String> carImages;
  final String customerFullName;
  final String? customerProfileImage;

  //  final String id;
  // final String customerId;
  // final String carId;
  // final DateTime pickupDate;
  // final DateTime dropOffDate;
  // final double totalPrice;
  // final RentalStatus status;
  // final LatLng pickupLoc;
  // final String pickupAddress;
  // final DateTime createdAt;
  // final String carName;
  // final List<String> carImageUrl;

  RentalWithCarAndUserDto({
    required this.id,
    required this.customerId,
    required this.carId,
    required this.pickupDate,
    required this.dropOffDate,
    required this.totalPrice,
    required this.status,
    required this.pickupAddress,
    required this.createdAt,
    required this.pickupLoc,
    required this.carTitle,
    required this.carImages,
    required this.customerFullName,
    this.customerProfileImage,
  });

  //from json
  factory RentalWithCarAndUserDto.fromJson(Map<String, dynamic> map) {
    return RentalWithCarAndUserDto(
      id: map['id'] as String,
      customerId: map['customer_id'] as String,
      carId: map['car_id'] as String,
      pickupDate: DateTime.parse(map['start_date'] as String),
      dropOffDate: DateTime.parse(map['end_date'] as String),
      totalPrice: (map['total_price'] as num).toDouble(),
      status: RentalStatus.values.byName(map['status'] as String),
      pickupLoc: AppUtils.latLngFromSupabase(map['pickup_loc']),
      pickupAddress: map['pickup_address'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      carTitle: map['car_title'] as String,
      carImages: List<String>.from(map['car_images']),
      customerFullName: map['customer_full_name'] as String,
      customerProfileImage: map['customer_profile_image'] as String?,
    );
  }

}