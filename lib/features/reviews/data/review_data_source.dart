import 'package:car_rental_app/features/reviews/data/models/review_dto.dart';
import 'package:car_rental_app/features/reviews/domain/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ReviewDataSource {

  Future<bool> submitReview({
    required ReviewDto reviewDto,
  });

  Future<List<ReviewModel>> getReviews(String carId);

  Future<String> getProfileImageUrl(String userId);

  Future<String> getReviewerName(String userId);
}

//impl
class ReviewDataSourceImpl implements ReviewDataSource {

  final SupabaseClient client;

  ReviewDataSourceImpl(this.client);

  @override
  Future<bool> submitReview({required ReviewDto reviewDto}) async {
    
    try{
      await client.from("reviews").insert(reviewDto.toJson());
      //update review_submitted to true
      await client.from("rentals").update({"review_submitted": true}).eq("id", reviewDto.rentalId);
      return true;
    }catch(e){
      print("Error happened while submitting review \n${e.toString()}");
      return false;
    }
  }

  @override
  Future<List<ReviewModel>> getReviews(String carId) async {
    try{
      final response = await client.from("reviews").select().eq("car_id", carId);
      return response.map((e) => ReviewDto.fromJson(e).toDomain()).toList();
    }catch(e){
      print("Error happened while getting reviews \n${e.toString()}");
      return [];
    }
  }

  @override
  Future<String> getProfileImageUrl(String userId) async {
    try{
      final response = await client.from("users").select("profile_image").eq("id", userId).single();
      return response["profile_image"] as String;
    }catch(e){
      print("Error happened while getting profile image url \n${e.toString()}");
      return "";
    }
  }

  @override
  Future<String> getReviewerName(String userId) async {
    try{
      final response = await client.from("users").select("full_name").eq("id", userId).single();
      return response["full_name"] as String;
    }catch(e){
      print("Error happened while getting reviewer name \n${e.toString()}");
      return "";
    }
  }
}