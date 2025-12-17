part of 'add_listing_bloc.dart';

enum ListingSubmissionStatus{
  initial,
  loading,
  success,
  failure,
}


class AddListingState extends Equatable {
  const AddListingState({
    this.currentPage = 0,
    this.selectedBrand,
    this.selectedGearbox = GearBox.automatic,
    this.selectedFuelType = FuelType.petrol,
    this.pickedImages = const [],
    this.submissionStatus = ListingSubmissionStatus.initial,
  });

  final int currentPage;
  final String? selectedBrand;
  final GearBox? selectedGearbox;
  final FuelType? selectedFuelType;
  final List<XFile> pickedImages;
  final ListingSubmissionStatus submissionStatus;

  AddListingState copyWith({
    int? currentPage,
    String? selectedBrand,
    bool selectedBrandChanged = false,
    GearBox? selectedGearbox,
    bool selectedGearboxChanged = false,
    FuelType? selectedFuelType,
    bool selectedFuelTypeChanged = false,
    List<XFile>? pickedImages,
    ListingSubmissionStatus? submissionStatus,
  }) {
    return AddListingState(
      currentPage: currentPage ?? this.currentPage,
      selectedBrand:
          selectedBrandChanged ? selectedBrand : this.selectedBrand,
      selectedGearbox:
          selectedGearboxChanged ? selectedGearbox : this.selectedGearbox,
      selectedFuelType:
          selectedFuelTypeChanged ? selectedFuelType : this.selectedFuelType,
      pickedImages: pickedImages ?? this.pickedImages,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        selectedBrand,
        selectedGearbox,
        selectedFuelType,
        pickedImages,
        submissionStatus
      ];
}
