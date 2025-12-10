import 'package:car_rental_app/features/home/data/models/car_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CarRemoteDataSource {
  Future<List<CarDto>> fetchAll();
  Future<List<CarDto>> fetchFeatured();
  Future<List<CarDto>> fetchByBrand(String brand);
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final SupabaseClient client;
  CarRemoteDataSourceImpl(this.client);

  @override
  Future<List<CarDto>> fetchAll() async {
    final res = await client.from('cars').select();
    return (res as List).map((e) => CarDto.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CarDto>> fetchFeatured() async {
    final res = await client.from('cars').select().gte('rating', 4.3);
    return (res as List).map((e) => CarDto.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CarDto>> fetchByBrand(String brand) async {
    final res = await client.from('cars').select().eq('brand', brand);
    return (res as List).map((e) => CarDto.fromMap(e as Map<String, dynamic>)).toList();
  }
}