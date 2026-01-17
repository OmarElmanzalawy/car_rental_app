import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/home/Presentation/customer/widgets/large_car_card.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/widgets.dart';

class CarsFilteredResult extends StatelessWidget {
  const CarsFilteredResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Found 12 cars",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10,),
        ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            final model = CarModel(
              id: index.toString(),
              title: "Car $index",
              description: "aegjapoegj",
              pricePerDay: 100,
              images: ["assets/onboarding/1.png"],
              ownerId: "123",
              brand: "Brand $index",
              model: "Model $index",
              year: 2020 + index,
              seats: 4 + index,
              gearbox: GearBox.automatic,
              fuelType: FuelType.petrol,
              location: "Location $index",
              available: true,
              maxSpeed: 200,
              isTopDeal: true,
              rating: 4.5 + index,
              totalRatingCount: 100 + index,
              createdAt: DateTime.now(),
            );
            return LargeCarCard(model: model);
          },
        )
      ],
    );
  }
}

class Gearbox {
}
