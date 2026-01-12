import 'package:car_rental_app/features/earnings/data/models/seller_earning_dto.dart';
import 'package:car_rental_app/features/earnings/data/models/seller_transaction_dto.dart';
import 'package:car_rental_app/features/earnings/data/models/seller_wallet_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class  EarningsDataSource {
  Stream<SellerWalletDto> getSellerWallet(String sellerId);
  Future<void> withdrawBalance(String sellerId, double amount);
  Stream<List<SellerTransactionDto>> getSellerTransactions(String sellerId); 
  Future<List<SellerEarningDto>> getSellerEarnings(String sellerId);
  Future<List<Map<String, dynamic>>> getRentalHistoryDetails(List<String> rentalIds);
}

class EarningsDataSourceImpl implements EarningsDataSource {

  final SupabaseClient client;

  EarningsDataSourceImpl(this.client);

  @override
  Stream<SellerWalletDto> getSellerWallet(String sellerId) {
    final response = client.from('seller_wallets')
      .stream(primaryKey: ["seller_id"])
      .eq('seller_id', sellerId);
      

    return response.map((lst) {
      if (lst.isEmpty) {
        return SellerWalletDto(
          sellerId: sellerId,
          availableBalance: 0,
          withdrawnBalance: 0,
          updatedAt: DateTime.now(),
        );
      }
      return lst.map((e) => SellerWalletDto.fromJson(e)).first;
    });
  }

  @override
  Future<void> withdrawBalance(String sellerId, double amount) async {
    // TODO: implement withDrawBalance
    
  }

  @override
  Future<List<SellerEarningDto>> getSellerEarnings(String sellerId) async {
    final response = await client.from('seller_earnings')
      .select()
      .eq('seller_id', sellerId)
      .order('created_at', ascending: false);

    return response.map((e) => SellerEarningDto.fromJson(e)).toList();
  }

  @override
  Stream<List<SellerTransactionDto>> getSellerTransactions(String sellerId) {
    final response = client.from('seller_transactions')
      .stream(primaryKey: ["id"])
      .eq('seller_id', sellerId)
      .order("created_at", ascending: false);
      

    return response.map((lst) => lst.map((e) => SellerTransactionDto.fromJson(e)).toList());  
  }

  @override
  Future<List<Map<String, dynamic>>> getRentalHistoryDetails(
    List<String> rentalIds,
  ) async {
    if (rentalIds.isEmpty) {
      return const [];
    }

    final rentalsRes = await client
        .from('rentals')
        .select('id,end_date,car_id')
        .inFilter('id', rentalIds);

    final rentals = rentalsRes.cast<Map<String, dynamic>>();
    final carIds = rentals
        .map((e) => e['car_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();

    final carsRes = carIds.isEmpty
        ? const []
        : await client.from('cars').select('id,title').inFilter('id', carIds);

    final cars = carsRes.cast<Map<String, dynamic>>();
    final carsById = <String, String>{
      for (final c in cars) (c['id'] as String): (c['title'] as String? ?? ''),
    };

    return rentals
        .map((r) {
          final rentalId = r['id'] as String;
          final carId = r['car_id'] as String?;
          final title = carId == null ? '' : (carsById[carId] ?? '');
          return <String, dynamic>{
            'rental_id': rentalId,
            'car_title': title,
            'end_date': r['end_date'],
          };
        })
        .toList();
  }
}
