class SellerWithdrawalDto {

  final String id;
  final String sellerId;
  final double amount;
  final DateTime createdAt;

  SellerWithdrawalDto({
    required this.id,
    required this.sellerId,
    required this.amount,
    required this.createdAt,
  });

  //to json
  Map<String, dynamic> toJson() => {
    'id': id,
    'seller_id': sellerId,
    'withdrawal_amount': amount,
    'created_at': createdAt.toIso8601String(),
  };
}