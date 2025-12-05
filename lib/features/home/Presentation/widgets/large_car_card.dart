import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/glass_capsule.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LargeCarCard extends StatelessWidget {
  const LargeCarCard({super.key, required this.carImagePath});

  final String carImagePath;  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.carDetail),
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
                  image: AssetImage(carImagePath),
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
              Capsule(text: "4 Seater",isGlass: false,backgroundColor: Colors.grey.shade300,textColor: Colors.black54,),
              Capsule(text: "Automatic",isGlass: false,backgroundColor: Colors.grey.shade300,textColor: Colors.black54,),
              Capsule(text: "Petrol",isGlass: false,backgroundColor: Colors.grey.shade300,textColor: Colors.black54,),
            ],
          ),
          const SizedBox(height: 8,),
          Text("BMW F80 340I XDRIVE 2018", style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          const SizedBox(height: 5,),
          Row(
            children: [
              Text("4.5", style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              Icon(Icons.star, color: Colors.amber,),
              Text("(4.5k)", style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),),
            ],
          ),
          const SizedBox(height: 5,),
          RichText(
            text: TextSpan(
              text: "\$500/",
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