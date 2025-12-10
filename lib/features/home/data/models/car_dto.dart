import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';

//The prupose of this dto class (data transfer object) is to separate the data from the domain layer
//from the data source layer. This way, we can change the data source layer without affecting the domain layer.

class CarDto {
  final String id;
  final String ownerId;
  final String title;
  final String brand;
  final String model;
  final int year;
  final double pricePerDay;
  final int seats;
  final GearBox gearbox;
  final FuelType fuelType;
  final List<String> images;
  final bool available;
  final DateTime createdAt;
  final double maxSpeed;
  final double rating;
  final int totalRatingCount;
  final String description;

  CarDto({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.brand,
    required this.model,
    required this.year,
    required this.pricePerDay,
    required this.seats,
    required this.gearbox,
    required this.fuelType,
    required this.images,
    required this.available,
    required this.createdAt,
    required this.maxSpeed,
    required this.rating,
    required this.totalRatingCount,
    required this.description,
  });

  factory CarDto.fromMap(Map<String, dynamic> map) {
    return CarDto(
      id: map['id'] as String,
      ownerId: map['owner_id'] as String,
      title: map['title'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      year: int.parse(map['year'] as String),
      pricePerDay: (map['price_per_day'] as num).toDouble(),
      seats: map['seats'] as int,
      gearbox: GearBox.values.byName(map['gearbox'] as String),
      fuelType: FuelType.values.byName(map['fuel_type'] as String),
      images: List<String>.from(map['images'] ?? const []),
      available: map['available'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      maxSpeed: (map['max_speed'] as num).toDouble(),
      rating: (map['rating'] as num).toDouble(),
      totalRatingCount: (map['total_rating_count'] as num).toInt(),
      description: map['description'] as String,
    );
  }

  CarModel toEntity() {
    return CarModel(
      id: id,
      ownerId: ownerId,
      title: title,
      brand: brand,
      model: model,
      year: year,
      pricePerDay: pricePerDay,
      seats: seats,
      gearbox: gearbox,
      fuelType: fuelType,
      location: '',
      images: images,
      available: available,
      createdAt: createdAt,
      maxSpeed: maxSpeed,
      rating: rating,
      totalRatingCount: totalRatingCount,
      description: description,
    );
  }
}