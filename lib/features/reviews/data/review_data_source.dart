import 'package:car_rental_app/features/reviews/data/models/review_dto.dart';
import 'package:car_rental_app/features/reviews/domain/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ReviewDataSource {

  Future<void> submitReview({
    required ReviewDto reviewDto,
  });

  Future<List<ReviewDto>?> getReviews(String carId);
}

//impl
class ReviewDataSourceImpl implements ReviewDataSource {

  final SupabaseClient client;

  ReviewDataSourceImpl(this.client);

  @override
  Future<void> submitReview({required ReviewDto reviewDto}) async {
    
    try{
      await client.from("reviews").insert(reviewDto.toJson());
    }catch(e){
      print("Error happened while submitting review \n${e.toString()}");
    }
  }

  @override
  Future<List<ReviewDto>?> getReviews(String carId) async {
    try{
      final response = await client.from("reviews").select().eq("car_id", carId);
      return response.map((e) => ReviewDto.fromJson(e)).toList();
    }catch(e){
      print("Error happened while getting reviews \n${e.toString()}");
      return null;
    }
  }
}