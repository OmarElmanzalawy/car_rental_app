import 'package:bloc/bloc.dart';
import 'package:car_rental_app/features/reviews/data/review_data_source.dart';
import 'package:car_rental_app/features/reviews/domain/review_model.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {

  final ReviewDataSourceImpl dataSource = ReviewDataSourceImpl(Supabase.instance.client);

  ReviewCubit() : super(ReviewState());

  void updateRating(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void showDetails() {
    if (!state.showDetails) {
      emit(state.copyWith(showDetails: true));
    }
  }

  void toggleTag(String tag) {
    final Set<String> newSelectedTags = Set.from(state.selectedTags);
    if (newSelectedTags.contains(tag)) {
      newSelectedTags.remove(tag);
    } else {
      newSelectedTags.add(tag);
    }
    emit(state.copyWith(selectedTags: newSelectedTags));
  }

  void submitReview(ReviewModel model) async{
    emit(state.copyWith(isSubmitting: true));
    final bool isSuccess = await dataSource.submitReview(reviewDto: model.toReviewDto());
    emit(state.copyWith(isSubmitting: false, isSuccess: isSuccess));
  }

  void fetchReviews(String carId) async{
    final List<ReviewModel> reviews = await dataSource.getReviews(carId);
    emit(state.copyWith(reviews: reviews));
  }

  Future<String> fetchProfileImageUrl(String userId) async{
    final String url = await dataSource.getProfileImageUrl(userId);
    return url;
  }

  Future<String> fetchReviewerName(String userId) async{
    final String name = await dataSource.getReviewerName(userId);
    return name;
  }
  
}
