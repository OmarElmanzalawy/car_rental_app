import 'package:car_rental_app/features/reviews/data/models/review_dto.dart';

class ReviewModel {

  final String id;
  final String rentalId;
  final String reviewerId;
  final String carId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.rentalId,
    required this.reviewerId,
    required this.carId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  ReviewDto toReviewDto() {
    return ReviewDto(
      id: id,
      rentalId: rentalId,
      reviewerId: reviewerId,
      carId: carId,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
    );
  }

}