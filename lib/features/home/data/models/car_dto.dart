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
  final bool isTopDeal;



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
    required this.isTopDeal,
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
      isTopDeal: map['is_top_deal'] == true,
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
      isTopDeal: isTopDeal,
    );
  }

  //copy with
  CarDto copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? brand,
    String? model,
    int? year,
    double? pricePerDay,
    int? seats,
    GearBox? gearbox,
    FuelType? fuelType,
    List<String>? images,
    bool? available,
    DateTime? createdAt,
    double? maxSpeed,
    double? rating,
    int? totalRatingCount,
    String? description,
    bool? isTopDeal,
  }) {
    return CarDto(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      seats: seats ?? this.seats,
      gearbox: gearbox ?? this.gearbox,
      fuelType: fuelType ?? this.fuelType,
      images: images ?? this.images,
      available: available ?? this.available,
      createdAt: createdAt ?? this.createdAt,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      rating: rating ?? this.rating,
      totalRatingCount: totalRatingCount ?? this.totalRatingCount,
      description: description ?? this.description,
      isTopDeal: isTopDeal ?? this.isTopDeal,
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'brand': brand,
      'model': model,
      'year': year,
      'price_per_day': pricePerDay,
      'seats': seats,
      'gearbox': gearbox.name,
      'fuel_type': fuelType.name,
      'images': images,
      'available': available,
      'created_at': createdAt.toIso8601String(),
      'max_speed': maxSpeed,
      'rating': rating,
      'total_rating_count': totalRatingCount,
      'description': description,
      'is_top_deal': isTopDeal,
    };
  }
}
