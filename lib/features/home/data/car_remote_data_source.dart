import 'package:car_rental_app/features/home/data/models/car_dto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CarRemoteDataSource {
  Future<List<CarDto>> fetchAll();
  Future<List<CarDto>> fetchFeatured();
  Future<List<CarDto>> fetchByBrand(String brand);
  Stream<List<CarDto>> fetchSellerListings();
  Future<bool> addCarListing(CarDto carDto, List<XFile> images);
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
    final res = await client.from('cars').select().eq('is_top_deal', true);
    return (res as List).map((e) => CarDto.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CarDto>> fetchByBrand(String brand) async {
    final res = await client.from('cars').select().eq('brand', brand);
    return (res as List).map((e) => CarDto.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<String> _uploadImage(XFile image,bool isTransparent) async {
    final bytes = await image.readAsBytes();

    //compress image
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 80,
      minHeight: 500,
      minWidth: 500,
      format: isTransparent? CompressFormat.png : CompressFormat.jpeg,
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
    final imageUrls = await Future.wait(images.map( (e) => _uploadImage(e, e.name.endsWith('.png'))));

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

  @override
  Stream<List<CarDto>> fetchSellerListings() {
    return client
        .from('cars')
        .stream(primaryKey: ['id'])
        .eq('owner_id', client.auth.currentUser!.id)
        .order('created_at')
        .map((maps) {
          return (maps as List)
              .map((e) => CarDto.fromMap(e as Map<String, dynamic>))
              .toList();
        });
  }
}
