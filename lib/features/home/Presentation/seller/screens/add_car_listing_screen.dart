import 'dart:async';

import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/home/Presentation/seller/blocs/add_listing_bloc/add_listing_bloc.dart';
import 'package:car_rental_app/features/home/Presentation/seller/widgets/add_listing_contact_step.dart';
import 'package:car_rental_app/features/home/Presentation/seller/widgets/add_listing_details_step.dart';
import 'package:car_rental_app/features/home/Presentation/seller/widgets/add_listing_images_step.dart';
import 'package:car_rental_app/features/home/data/models/car_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddCarListingScreen extends StatefulWidget {
  const AddCarListingScreen({super.key});

  @override
  State<AddCarListingScreen> createState() => _AddCarListingScreenState();
}

class _AddCarListingScreenState extends State<AddCarListingScreen> {
  final PageController _pageController = PageController();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _pricePerDayController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _maxSpeedController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  PhoneNumber _phoneNumber = PhoneNumber(isoCode: "EG");

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _pricePerDayController.dispose();
    _seatsController.dispose();
    _maxSpeedController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    context.read<AddListingBloc>().add(AddListingPageChanged(index));
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickMultipleImages() async {
    final images = await _imagePicker.pickMultiImage();
    if (!mounted) return;
    if (images.isEmpty) return;

    context.read<AddListingBloc>().add(AddListingImagesAdded(images));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AddListingBloc, AddListingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.silverAccent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(onPressed: (){
                          context.pop();
                        }, icon: Icon(Icons.close,size: 30,)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          _StepDot(
                            isActive: state.currentPage == 0,
                            label: "Details",
                          ),
                          const SizedBox(width: 8),
                          _StepDot(
                            isActive: state.currentPage == 1,
                            label: "Images",
                          ),
                          const SizedBox(width: 8),
                          _StepDot(
                            isActive: state.currentPage == 2,
                            label: "Contact",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          AddListingDetailsStep(
                            titleController: _titleController,
                            modelController: _modelController,
                            yearController: _yearController,
                            pricePerDayController: _pricePerDayController,
                            seatsController: _seatsController,
                            maxSpeedController: _maxSpeedController,
                            descriptionController: _descriptionController,
                            selectedBrand: state.selectedBrand,
                            onBrandChanged: (v) =>
                                context.read<AddListingBloc>().add(
                                      AddListingBrandChanged(v),
                                    ),
                            selectedGearbox: state.selectedGearbox,
                            onGearboxChanged: (v) =>
                                context.read<AddListingBloc>().add(
                                      AddListingGearboxChanged(v),
                                    ),
                            selectedFuelType: state.selectedFuelType,
                            onFuelTypeChanged: (v) =>
                                context.read<AddListingBloc>().add(
                                      AddListingFuelTypeChanged(v),
                                    ),
                          ),
                          AddListingImagesStep(
                            pickedImages: state.pickedImages,
                            onAddImages: () {
                              unawaited(_pickMultipleImages());
                            },
                            onRemovePickedImage: (index) {
                              context
                                  .read<AddListingBloc>()
                                  .add(AddListingPickedImageRemoved(index));
                            },
                          ),
                          AddListingContactStep(
                            phoneController: _phoneController,
                            phoneNumber: _phoneNumber,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: Row(
                        children: [
                          if (state.currentPage > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    _goToPage(state.currentPage - 1),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text("Back"),
                              ),
                            ),
                          if (state.currentPage > 0) const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (state.currentPage < 2) {
                                  _goToPage(state.currentPage + 1);
                                } else {
                                  print("submit");
                                  //validate form
                
                                  // submit the form
                                  final carDto = CarDto(
                                    id: Uuid().v4(),
                                    ownerId: Supabase.instance.client.auth.currentUser!.id,
                                    title: _titleController.text,
                                    brand: state.selectedBrand!, 
                                    model: _modelController.text, 
                                    year: int.parse(_yearController.text), 
                                    pricePerDay: double.parse(_pricePerDayController.text), 
                                    seats: int.parse(_seatsController.text), 
                                    gearbox: state.selectedGearbox!, 
                                    fuelType: state.selectedFuelType!, 
                                    images: [], 
                                    available: true, 
                                    createdAt: DateTime.now(), 
                                    maxSpeed: double.parse(_maxSpeedController.text), 
                                    rating: 0.0, 
                                    totalRatingCount: 0, 
                                    description: _descriptionController.text,
                                    );
                                  context.read<AddListingBloc>().add(
                                    AddListingSubmit(
                                      carDto: carDto,
                                      images: state.pickedImages,
                                    )
                                    );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                state.currentPage < 2 ? "Next" : "Submit",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //loading overlay
                state.submissionStatus == ListingSubmissionStatus.loading ? 
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        
                      ),
                    ),
                  ),
                )
                : const SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.isActive, required this.label});
  final bool isActive;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
