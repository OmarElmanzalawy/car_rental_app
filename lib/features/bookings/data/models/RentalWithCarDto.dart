
//This class is used to map the response from supabase to a dart object that contains 
//additional info about the car rented by the customer unlike the RentalModel class
//This will be used to display the car info in the bookings screen
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Rentalwithcardto {

  final String id;
  final String customerId;
  final String carId;
  final DateTime pickupDate;
  final DateTime dropOffDate;
  final double totalPrice;
  final RentalStatus status;
  final LatLng pickupLoc;
  final String pickupAddress;
  final DateTime createdAt;
  final String carName;
  final List<String> carImageUrl;
  final bool reivewSubmitted;

  Rentalwithcardto({
    required this.id,
    required this.customerId,
    required this.carId,
    required this.pickupDate,
    required this.dropOffDate,
    required this.totalPrice,
    required this.status,
    required this.pickupLoc,
    required this.pickupAddress,
    required this.createdAt,
    required this.carName,
    required this.carImageUrl,
    required this.reivewSubmitted
  });

  factory Rentalwithcardto.fromMap(Map<String, dynamic> map) {
    return Rentalwithcardto(
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
      carName: map['car_title'] as String,
      carImageUrl: List<String>.from(map['car_images'] as List),
      reivewSubmitted: map['review_submitted'] as bool,
    );
  }



}