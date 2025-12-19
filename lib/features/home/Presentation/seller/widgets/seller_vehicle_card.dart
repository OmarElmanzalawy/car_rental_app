import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SellerVehicleCard extends StatelessWidget {
  const SellerVehicleCard({
    super.key,
    required this.imagePath,
    required this.pricePerDay,
    required this.statusChipColor,
    required this.statusChipLabel,
  });

  final String imagePath;
  final num pricePerDay;
  final Color statusChipColor;
  final String statusChipLabel;

  @override
  Widget build(BuildContext context) {
    final imageWidget = imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            width: 140,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 140,
                height: 90,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey.shade600,
                ),
              );
            },
          )
        : Image.asset(
            imagePath,
            width: 140,
            height: 90,
            fit: BoxFit.cover,
          );
    final formattedPrice = pricePerDay % 1 == 0
        ? pricePerDay.toInt().toString()
        : pricePerDay.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "\$$formattedPrice/day",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusChipColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusChipColor),
                      ),
                      child: Text(
                        statusChipLabel,
                        style: TextStyle(
                          color: statusChipColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Edit Listing"),
                      ),
                ),
                const SizedBox(height: 10,),
                 SizedBox(
                  width: double.maxFinite,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("View Calendar"),
                      ),
                    ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: AppColors.primary,
                //           foregroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //         ),
                //         child: const Text("Edit Listing"),
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     Expanded(
                //       child: OutlinedButton(
                //         onPressed: () {},
                //         style: OutlinedButton.styleFrom(
                //           foregroundColor: Colors.black,
                //           side: BorderSide(color: Colors.grey.shade300),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //         ),
                //         child: const Text("View Calendar"),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
