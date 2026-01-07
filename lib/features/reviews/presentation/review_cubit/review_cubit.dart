import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {


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
  
}
