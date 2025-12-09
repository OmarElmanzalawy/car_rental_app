import 'package:car_rental_app/core/constants/enums.dart';

class CarModel {
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
  final String location;
  final List<String>? images;
  final bool available;
  final DateTime createdAt;
  final double maxSpeed;
  final double rating;
  final int totalRatingCount;
  final String description;

  CarModel({
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
    required this.location,
    this.images,
    required this.available,
    required this.createdAt,
    required this.maxSpeed, 
    required this.rating,
    required this.totalRatingCount,
    required this.description,
  });

}