import 'package:car_rental_app/core/constants/enums.dart';

class SellerTransactionModel {

  final String id;
  final String sellerId;
  final TransactionType type;
  final double amount;
  final DateTime createdAt;
  final String? rentalId;

  SellerTransactionModel({
    required this.id,
    required this.sellerId,
    required this.type,
    required this.amount,
    required this.createdAt,
    this.rentalId,
  });

}