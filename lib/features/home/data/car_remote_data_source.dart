import 'package:car_rental_app/features/home/data/models/car_dto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CarRemoteDataSource {
  Future<List<CarDto>> fetchAll();
  Future<List<CarDto>> fetchFeatured();
  Future<List<CarDto>> fetchByBrand(String brand);
  Future<void> addCarListing(CarDto carDto, List<XFile> images);
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

  Future<String> _uploadImage(XFile image) async {
    final bytes = await image.readAsBytes();

    //compress image
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 80,
      minHeight: 500,
      minWidth: 500,
      );

    final fileName = "${client.auth.currentUser?.id}_${image.name}";
    final filePath = 'cars/$fileName';
    await client.storage.from('app_uploads').uploadBinary(filePath, compressedBytes);
    return client.storage.from('app_uploads').getPublicUrl(filePath);
  }

  @override
  Future<bool> addCarListing(CarDto carDto, List<XFile> images) async {
    try{
    //upload cars to supabase storage
    //get public urls to add later to database
    final imageUrls = await Future.wait(images.map(_uploadImage));

    // modify cardto to include image urls
    CarDto model = carDto.copyWith(images: imageUrls);

    //insert car to database
    await client.from('cars').insert(model.toMap());

    return true;
    }catch(e){
      print("error while adding car listing");
      print(e.toString());
      return false;
    }
  }
}