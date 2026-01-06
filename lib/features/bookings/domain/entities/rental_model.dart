import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RentalModel {
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

  RentalModel({
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
  });

  factory RentalModel.fromMap(Map<String, dynamic> map) {
    return RentalModel(
      id: map['id'] as String,
      customerId: map['customer_id'] as String,
      carId: map['car_id'] as String,
      pickupDate: DateTime.parse(map['start_date'] as String),
      dropOffDate: DateTime.parse(map['end_date'] as String),
      totalPrice: (map['total_price'] as num).toDouble(),
      status: RentalStatus.values.byName(map['status'] as String),
      pickupLoc: AppUtils.latLngFromSupabase(map['pickup_loc'] as String),
      pickupAddress: map['pickup_address'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'customer_id': customerId,
      'car_id': carId,
      'start_date': pickupDate.toIso8601String(),
      'end_date': dropOffDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status.name,
      'pickup_loc': AppUtils.latLngToWkt(pickupLoc),
      'pickup_address': pickupAddress,
      'created_at': createdAt.toIso8601String(),
    };
  }

}