import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/widgets/adaptive_drop_down_menu.dart';
import 'package:car_rental_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class AddListingDetailsStep extends StatelessWidget {
  const AddListingDetailsStep({
    super.key,
    required this.titleController,
    required this.modelController,
    required this.yearController,
    required this.pricePerDayController,
    required this.seatsController,
    required this.maxSpeedController,
    required this.descriptionController,
    required this.selectedBrand,
    required this.onBrandChanged,
    required this.selectedGearbox,
    required this.onGearboxChanged,
    required this.selectedFuelType,
    required this.onFuelTypeChanged,
  });

  final TextEditingController titleController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController pricePerDayController;
  final TextEditingController seatsController;
  final TextEditingController maxSpeedController;
  final TextEditingController descriptionController;

  final String? selectedBrand;
  final ValueChanged<String?> onBrandChanged;
  final GearBox? selectedGearbox;
  final ValueChanged<GearBox?> onGearboxChanged;
  final FuelType? selectedFuelType;
  final ValueChanged<FuelType?> onFuelTypeChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Car Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          CustomTextfield(
            hintText: "Title (e.g. Tesla Model 3)",
            controller: titleController,
            cursorColor: AppColors.primary,
            isFilled: true,
            fillColor: Colors.white,
          ),
          const SizedBox(height: 12),
          AdaptiveDropDownMenu<String>(
            label: "Brand",
            hintText: "Select brand",
            value: selectedBrand,
            onChanged: onBrandChanged,
            items: const [
              AdaptiveDropDownItem(value: "Tesla", label: "Tesla"),
              AdaptiveDropDownItem(value: "BMW", label: "BMW"),
              AdaptiveDropDownItem(value: "Toyota", label: "Toyota"),
              AdaptiveDropDownItem(value: "Ford", label: "Ford"),
              AdaptiveDropDownItem(value: "Lamborghini", label: "Lamborghini"),
            ],
          ),
          const SizedBox(height: 12),
          CustomTextfield(
            hintText: "Model",
            controller: modelController,
            cursorColor: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextfield(
                  hintText: "Year",
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextfield(
                  hintText: "Price per day",
                  controller: pricePerDayController,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextfield(
                  hintText: "Seats",
                  controller: seatsController,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextfield(
                  hintText: "Max speed (km/h)",
                  controller: maxSpeedController,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Gearbox",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _OptionCard(
                  label: "Automatic",
                  icon: Icons.settings_suggest_outlined,
                  selected: selectedGearbox == GearBox.automatic,
                  onTap: () => onGearboxChanged(GearBox.automatic),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OptionCard(
                  label: "Manual",
                  icon: Icons.settings_outlined,
                  selected: selectedGearbox == GearBox.manual,
                  onTap: () => onGearboxChanged(GearBox.manual),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Fuel Type",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _OptionCard(
                      label: "Petrol",
                      icon: Icons.local_gas_station_outlined,
                      selected: selectedFuelType == FuelType.petrol,
                      onTap: () => onFuelTypeChanged(FuelType.petrol),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _OptionCard(
                      label: "Electric",
                      icon: Icons.electric_car_outlined,
                      selected: selectedFuelType == FuelType.electric,
                      onTap: () => onFuelTypeChanged(FuelType.electric),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _OptionCard(
                      label: "Hybrid",
                      icon: Icons.electric_bike_outlined,
                      selected: selectedFuelType == FuelType.hybrid,
                      onTap: () => onFuelTypeChanged(FuelType.hybrid),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _OptionCard(
                      label: "Natural Gas",
                      icon: Icons.propane_tank_outlined,
                      selected: selectedFuelType == FuelType.naturalGas,
                      onTap: () => onFuelTypeChanged(FuelType.naturalGas),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12,),
          Text("Description",style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: CustomTextfield(
              isMultiline: true,
              hintText: "Enter a description for your car",
              controller: descriptionController,
              cursorColor: AppColors.primary,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

