import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/home/data/test_models.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StartupService {

  static Future<void> init()async{
    WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhndnZ0dnJidnd1dXpveHh5bnRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NzYzNTUsImV4cCI6MjA4MDM1MjM1NX0.4T2uHbXlaukVXLDXvoJ4gMJq8ZTFONLMlcIPqAGv4AI",
    url: "https://xgvvtvrbvwuuzoxxyntk.supabase.co"
    );
  }

  // //Inserts the test cars into the supabase database
  // //FOR TESTING PURPOSES ONLY
  // static Future<void> insertCarsIntoSupabase()async{
  //   final client = Supabase.instance.client;
  //   final uuid = const Uuid();
  //   final List<CarModel> cars = [
  //     ...TestModels.testCompactCars,
  //     ...TestModels.testLargeCars,
  //   ];
  //   final rows = cars.map((c) => {
  //     'id': uuid.v5(Uuid.NAMESPACE_URL, 'cars:${c.id}:${c.title}:${c.year}'),
  //     //Change later to match the seller id
  //     'owner_id': uuid.v5(Uuid.NAMESPACE_URL, 'owners:${c.ownerId}'),
  //     'title': c.title,
  //     'brand': c.brand,
  //     'model': c.model,
  //     'year': c.year.toString(),
  //     'price_per_day': c.pricePerDay,
  //     'seats': c.seats,
  //     'gearbox': c.gearbox.name,
  //     'fuel_type': c.fuelType.value,
  //     'images': c.images ?? <String>[],
  //     'available': c.available,
  //     'created_at': c.createdAt.toUtc().toIso8601String(),
  //     'max_speed': c.maxSpeed,
  //     'total_rating_count': c.totalRatingCount,
  //     'description': c.description,
  //     'rating': c.rating,
  //   }).toList();
  //   await client.from('cars').upsert(rows, onConflict: 'id', ignoreDuplicates: true);
  // }

}
