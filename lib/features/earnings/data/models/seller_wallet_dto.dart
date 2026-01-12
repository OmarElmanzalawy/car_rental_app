import 'package:car_rental_app/features/earnings/domain/entities/seller_wallet_model.dart';

class SellerWalletDto {

  final String sellerId;
  //Withdrawable balance
  final double availableBalance;
  final double withdrawnBalance;
  final DateTime updatedAt;

  ///Converts the DTO to a domain model
  SellerWalletModel toDomain() {
    return SellerWalletModel(
      sellerId: sellerId,
      availableBalance: availableBalance,
      withdrawnBalance: withdrawnBalance,
      updatedAt: updatedAt,
    );
  }

  ///Converts the JSON map to a DTO
  factory SellerWalletDto.fromJson(Map<String, dynamic> json) {
    return SellerWalletDto(
      sellerId: json['seller_id'],
      availableBalance: (json['available_balance'] as num).toDouble(),
      withdrawnBalance: (json['withdrawn_balance'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  SellerWalletDto({
    required this.sellerId,
    required this.availableBalance,
    required this.withdrawnBalance,
    required this.updatedAt,
  });

}
