import 'package:car_rental_app/core/widgets/phone_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddListingContactStep extends StatelessWidget {
  const AddListingContactStep({
    super.key,
    required this.phoneController,
    required this.phoneNumber,
  });

  final TextEditingController phoneController;
  final PhoneNumber phoneNumber;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Contact Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            "Renters will contact you using this phone number for this listing.",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 16),
          PhoneTextfield(
            initialCountry: phoneNumber.isoCode ?? "EG",
            phoneNumber: phoneNumber,
            phoneController: phoneController,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

