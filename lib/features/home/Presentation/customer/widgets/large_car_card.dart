import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/home/Presentation/customer/widgets/glass_capsule.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class LargeCarCard extends StatelessWidget {
  const LargeCarCard({super.key,required this.model});

  // final String carImagePath;  
  final CarModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.carDetail,extra: model),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 260,
              height: 190,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage("assets/images/test_cars/${model.images!.first}"),
                  fit: BoxFit.cover
                  ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Wrap(
            spacing: 10,
            runSpacing: 5,
            children: [
              Capsule(text: "${model.seats} Seater",isGlass: false,backgroundColor: Colors.grey.shade300,textColor: Colors.black54,),
              Capsule(text: model.gearbox == GearBox.automatic ? "Automatic" : "Manual",isGlass: false,backgroundColor: Colors.grey.shade300,textColor: Colors.black54,),
              Capsule(text: model.fuelType == FuelType.petrol ? "Petrol" : model.fuelType == FuelType.electric ? "Electric" : model.fuelType == FuelType.hybrid ? "Hybrid" : "Natural Gas",isGlass: false,backgroundColor: Colors.grey.shade300,textColor: Colors.black54,),
            ],
          ),
          const SizedBox(height: 8,),
          Text(model.title, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          const SizedBox(height: 5,),
          Row(
            children: [
              Text("${model.rating}", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              Icon(Icons.star, color: Colors.amber,),
              Text("(${model.totalRatingCount})", style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),),
            ],
          ),
          const SizedBox(height: 5,),
          RichText(
            text: TextSpan(
              text: "\$${model.pricePerDay.toStringAsFixed(0)}/",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "day",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}