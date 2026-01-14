import 'package:car_rental_app/features/earnings/data/models/seller_withdrawal_dto.dart';

class SellerWithdrawalModel {
  final String id;
  final String sellerId;
  final double amount;
  final DateTime createdAt;
  
  SellerWithdrawalModel({
    required this.id,
    required this.sellerId,
    required this.amount,
    required this.createdAt,
  });

  //to dto
  SellerWithdrawalDto toDto() => SellerWithdrawalDto(
    id: id,
    sellerId: sellerId,
    amount: amount,
    createdAt: createdAt,
  );
}