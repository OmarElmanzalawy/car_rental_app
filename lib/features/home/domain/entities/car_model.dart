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

  factory CarModel.fromMap(Map<String,dynamic> map){
    return CarModel(
      id: map['id'],
      ownerId: map['owner_id'],
      title: map['title'],
      brand: map['brand'],
      model: map['model'],
      year: int.parse(map['year']),
      pricePerDay: map['price_per_day'],
      seats: map['seats'],
      gearbox: GearBox.values.firstWhere((element) => element.name == map['gearbox']),
      fuelType: FuelType.values.firstWhere((element) => element.value == map['fuel_type']),
      location: map['location'],
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      available: map['available'],
      createdAt: DateTime.parse(map['created_at']),
      maxSpeed: map['max_speed'],
      rating: map['rating'],
      totalRatingCount: map['total_rating_count'],
      description: map['description'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id': this.id,
      //Change later to match the seller id
      'owner_id': this.ownerId,
      'title': this.title,
      'brand': this.brand,
      'model': this.model,
      'year': this.year.toString(),
      'price_per_day': this.pricePerDay,
      'seats': this.seats,
      'gearbox': this.gearbox.name,
      'fuel_type': this.fuelType.value,
      'images': this.images ?? <String>[],
      'available': this.available,
      'created_at': this.createdAt.toUtc().toIso8601String(),
      'max_speed': this.maxSpeed,
      'total_rating_count': this.totalRatingCount,
      'description': this.description,
      'rating': this.rating,
    };
  }

}