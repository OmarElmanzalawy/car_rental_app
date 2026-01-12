import 'package:car_rental_app/features/earnings/domain/entities/seller_earning_model.dart';

class SellerEarningDto {
  final String id;
  final String sellerId;
  final String rentalId;
  final String carId;
  final double grossAmount;
  final double platformFee;
  final double netAmount;
  final DateTime createdAt;

  SellerEarningDto({
    required this.id,
    required this.sellerId,
    required this.rentalId,
    required this.carId,
    required this.grossAmount,
    required this.platformFee,
    required this.netAmount,
    required this.createdAt,
  });

  ///Converts the DTO to a domain model
  SellerEarningModel toDomain() {
    return SellerEarningModel(
      id: id,
      sellerId: sellerId,
      rentalId: rentalId,
      carId: carId,
      grossAmount: grossAmount,
      platformFee: platformFee,
      netAmount: netAmount,
      createdAt: createdAt,
    );
  }

  ///Converts the JSON map to a DTO
  factory SellerEarningDto.fromJson(Map<String, dynamic> json) {
    return SellerEarningDto(
      id: json['id'],
      sellerId: json['seller_id'],
      rentalId: json['rental_id'],
      carId: json['car_id'],
      grossAmount: (json['gross_amount'] as num).toDouble(),
      platformFee: (json['platform_fee'] as num).toDouble(),
      netAmount: (json['net_earning'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
