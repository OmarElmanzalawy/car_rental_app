part of 'review_cubit.dart';

class ReviewState extends Equatable {
  const ReviewState({
    this.rating = 0,
    this.showDetails = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.selectedTags = const {},
    this.reviews = const [],
    });

  final int rating;
  final bool showDetails;
  final bool isSubmitting;
  final bool isSuccess;
  final Set<String> selectedTags;
  final List<ReviewModel> reviews;

    String get headlineForRating {
    switch (rating) {
      case 1:
        return "Not great";
      case 2:
        return "Could be better";
      case 3:
        return "Decent rental";
      case 4:
        return "Great rental";
      case 5:
        return "Excellent rental";
      default:
        return "";
    }
  }

  List<String> get tagsForRating {
    return const [
      "Cleanliness",
      "Vehicle condition",
      "Pickup",
      "Dropoff",
      "Communication",
      "Price",
      "Other",
    ];
  }

  ReviewState copyWith({
    int? rating,
    bool? showDetails,
    bool? isSubmitting,
    bool? isSuccess,
    Set<String>? selectedTags,
    List<ReviewModel>? reviews,
  }) {
    return ReviewState(
      rating: rating ?? this.rating,
      showDetails: showDetails ?? this.showDetails,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      selectedTags: selectedTags ?? this.selectedTags,
      isSuccess: isSuccess ?? this.isSuccess,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object> get props => [rating, showDetails, isSubmitting, selectedTags, isSuccess, reviews];
}

