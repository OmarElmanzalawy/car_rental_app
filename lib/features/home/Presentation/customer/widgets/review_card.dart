import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/reviews/domain/review_model.dart';
import 'package:car_rental_app/features/reviews/presentation/review_cubit/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewCard extends StatefulWidget {
  const ReviewCard({
    super.key,
    required this.reviewModel,
  });


  final ReviewModel reviewModel;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {

  String? profileImage;
  String? reviewerName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviewerInfo();
  }

  Future<void> _loadReviewerInfo() async {
    try {
      final cubit = context.read<ReviewCubit>();
      final results = await Future.wait([
        cubit.fetchProfileImageUrl(widget.reviewModel.reviewerId),
        cubit.fetchReviewerName(widget.reviewModel.reviewerId),
      ]);
      if (!mounted) return;
      setState(() {
        profileImage = results[0];
        reviewerName = results[1];
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = (profileImage ?? '').isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.silverAccent,
            backgroundImage: hasImage ? NetworkImage(profileImage!) : null,
            child: hasImage
                ? null
                : Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoading ? "Loading..." : (reviewerName ?? "Customer"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _Stars(value: widget.reviewModel.rating),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      timeago.format(widget.reviewModel.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.reviewModel.comment,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final isFilled = index < value;
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 16,
            color: isFilled ? Colors.amber : AppColors.border,
          ),
        );
      }),
    );
  }
}
