import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/earnings/domain/entities/seller_transaction_model.dart';

class SellerTransactionDto {

  final String id;
  final String sellerId;
  final TransactionType type;
  final double amount;
  final DateTime createdAt;
  final String? rentalId;

  SellerTransactionDto({
    required this.id,
    required this.sellerId,
    required this.type,
    required this.amount,
    required this.createdAt,
    this.rentalId,
  });

  factory SellerTransactionDto.fromJson(Map<String, dynamic> json) => SellerTransactionDto(
    id: json["id"],
    sellerId: json["seller_id"],
    type: TransactionType.values.firstWhere((e) => e.value == json["type"]),
    amount: (json["amount"] as num).toDouble(),
    createdAt: DateTime.parse(json["created_at"]),
    rentalId: json["rental_id"],
  );

  ///Converts the DTO to a domain model
  SellerTransactionModel toDomain() {
    return SellerTransactionModel(
      id: id,
      sellerId: sellerId,
      type: type,
      amount: amount,
      createdAt: createdAt,
      rentalId: rentalId,
    );
  }

}
