import 'package:car_rental_app/features/reviews/domain/review_model.dart';

class ReviewDto {
  final String id;
  final String rentalId;
  final String reviewerId;
  final String carId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  ReviewDto({
    required this.id,
    required this.rentalId,
    required this.reviewerId,
    required this.carId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) {
    return ReviewDto(
      id: json['id'],
      rentalId: json['rental_id'],
      reviewerId: json['reviewer_id'],
      carId: json['car_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rental_id': rentalId,
      'reviewer_id': reviewerId,
      'car_id': carId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ReviewModel toDomain() {
    return ReviewModel(
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