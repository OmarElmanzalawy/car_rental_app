///Represents a single earning record for a seller
///
///Any amount of money earned by the seller in a single transaction
class SellerEarningModel {

  final String id;
  final String sellerId;
  final String rentalId;
  final String carId;
  final double grossAmount;
  final double platformFee;
  final double netAmount;
  final DateTime createdAt;

  SellerEarningModel({
    required this.id,
    required this.sellerId,
    required this.rentalId,
    required this.carId,
    required this.grossAmount,
    required this.platformFee,
    required this.netAmount,
    required this.createdAt,
  });

}