import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/custom_textfield.dart';
import 'package:car_rental_app/core/widgets/status_chip.dart';
import 'package:car_rental_app/features/bookings/data/models/RentalWithCarDto.dart';
import 'package:car_rental_app/features/reviews/presentation/review_cubit/review_cubit.dart';
import 'package:car_rental_app/features/reviews/presentation/widgets/review_star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.rental});

  final Rentalwithcardto rental;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final showDetails = rating > 0;
    // final tags = context.read<ReviewCubit>().tagsForRating;

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(),
      body: BlocProvider(
        create: (context) => ReviewCubit(),
        child: Material(
          color: AppColors.background,
          child: SafeArea(
            child: BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                print("bloc rebuild");
                return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: size.height * 0.75,
                                  ),
                                      child:  Column(
                                        children: [
                                          const SizedBox(height: 18),
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: AppColors.silverAccent,
                                            backgroundImage: CachedNetworkImageProvider(
                                              widget.rental.carImageUrl.first,
                                            ),
                                          ),
                                          const SizedBox(height: 22),
                                          Text(
                                            "How was your rental of ${widget.rental.carName}?",
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          state.showDetails
                                              ? Text(
                                                  state.headlineForRating,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.primary,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(height: 12),
                                          ReviewStar(
                                            value: state.rating,
                                            onChanged: (v) {
                                              print(v);
                                              context.read<ReviewCubit>().updateRating(v);
                                              context.read<ReviewCubit>().showDetails();
                                            },
                                          ),
                                          if (state.showDetails) ...[
                                            const SizedBox(height: 18),
                                            Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              children: state.tagsForRating
                                                  .map(
                                                    (t) => StatusChip(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                      statusChipColor:
                                                          state.selectedTags.contains(t)
                                                          ? AppColors.primary
                                                          : Colors.grey.shade300,
                                                      textColor: state.selectedTags.contains(t)
                                                          ? AppColors.primary
                                                          : Colors.black,
                                                      statusChipLabel: t,
                                                      onPressed: () => context.read<ReviewCubit>().toggleTag(t),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                            const SizedBox(height: 24),
                                            Divider(color: Colors.grey.shade300, height: 1),
                                            const SizedBox(height: 20),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Description",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              height: 130,
                                              child: CustomTextfield(
                                                hintText: "Leave a note (optional)",
                                                controller: notesController,
                                                cursorColor: AppColors.primary,
                                                borderColor: Colors.black54,
                                                focusColor: AppColors.primary,
                                                isMultiline: true,
                                                fillColor: AppColors.surface,
                                                isFilled: true,
                                                borderRadius: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        ],
                                      )
                                  //   },
                                  ),
                                ),
                              ),
                               if (state.showDetails)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                    child: SizedBox(
                      width: double.infinity,
                      child: ActionButton(
                        isLiquidGlass: true,
                        liquidGlassSize: AdaptiveButtonSize.large,
                        label: "Done",
                        onPressed: () {},
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                          ],
                            );
              },
            ),
               
            ),
          ),
        ),
    );
  }
}
