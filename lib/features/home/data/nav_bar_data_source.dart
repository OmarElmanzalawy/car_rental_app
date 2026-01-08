import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NavigationBarDataSource {
  Future<int> getUnReadChatCount(String userId);
  Stream<int> watchUnReadChatCount(String userId);
}

//impl
class NavigationBarDataSourceImpl implements NavigationBarDataSource {

  final SupabaseClient client;

  NavigationBarDataSourceImpl(this.client);
  @override
  Future<int> getUnReadChatCount(String userId) async {
    final rows = await client
        .from('conversations')
        .select('user_1,user_2,user_1_unread_count,user_2_unread_count')
        .or('user_1.eq.$userId,user_2.eq.$userId');

    int total = 0;
    for (final row in rows) {
      final map = row as Map<String, dynamic>;
      final u1 = map['user_1'] as String?;
      final u2 = map['user_2'] as String?;
      final u1Count = (map['user_1_unread_count'] as int?) ?? 0;
      final u2Count = (map['user_2_unread_count'] as int?) ?? 0;

      if (u1 == userId) {
        total += u1Count;
      } else if (u2 == userId) {
        total += u2Count;
      }
    }
    return total;
  }

  @override
  Stream<int> watchUnReadChatCount(String userId) {
    int sumForColumn(List<Map<String, dynamic>> rows, String column) {
      int total = 0;
      for (final row in rows) {
        total += (row[column] as int?) ?? 0;
      }
      return total;
    }

    return Stream<int>.multi((controller) {
      int user1Total = 0;
      int user2Total = 0;

      final sub1 = client
          .from('conversations')
          .stream(primaryKey: ['id'])
          .eq('user_1', userId)
          .listen(
        (rows) {
          final maps = rows.cast<Map<String, dynamic>>();
          user1Total = sumForColumn(maps, 'user_1_unread_count');
          controller.add(user1Total + user2Total);
        },
        onError: controller.addError,
      );

      final sub2 = client
          .from('conversations')
          .stream(primaryKey: ['id'])
          .eq('user_2', userId)
          .listen(
        (rows) {
          final maps = rows.cast<Map<String, dynamic>>();
          user2Total = sumForColumn(maps, 'user_2_unread_count');
          controller.add(user1Total + user2Total);
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await sub1.cancel();
        await sub2.cancel();
      };
    });
  }
}
