import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/chat/domain/entities/conversation_model.dart';
import 'package:car_rental_app/features/chat/domain/entities/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage({
    required MessageModel messageModel,
  });

  Future<void> resetUnreadCount({
    required String conversationId,
    required String userId,
  });

  Future<void> sendSystemMessage({
    required String conversationId,
    required String message,
    required MessageType messageType,
    String? rentalId,
  });

  Future<List<ConversationModel>> getConversations();

  Stream<List<MessageModel>> getMessages({
    required String conversationId
  });

  Future<String?> checkIfChatExists({
    required String user1,
    required String user2,
  });

  Future<bool> createChat({
    required String receiverId,
  });

  Future<void> updateRentalStatus({
    required String rentalId,
    required RentalStatus status,
  });

}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient client;

  ChatRemoteDataSourceImpl(this.client);

  @override
  Future<void> sendMessage({
    required MessageModel messageModel,
  }) async {
    await client.from("messages").insert(messageModel.toMap());
    //update conversation updated_at column
    await client.from("conversations").update({
      "updated_at": DateTime.now().toIso8601String(),
    }).eq("id", messageModel.conversationId);
  }

  @override
  Future<void> resetUnreadCount({
    required String conversationId,
    required String userId,
  }) async {
    final row = await client
        .from('conversations')
        .select('user_1,user_2')
        .eq('id', conversationId)
        .maybeSingle();

    if (row == null) {
      return;
    }

    final user1 = row['user_1'] as String?;
    final user2 = row['user_2'] as String?;

    final String? column = user1 == userId
        ? 'user_1_unread_count'
        : user2 == userId
            ? 'user_2_unread_count'
            : null;

    if (column == null) {
      return;
    }

    await client.from('conversations').update({column: 0}).eq('id', conversationId);
  }

  @override
  Future<void> sendSystemMessage({
    required String conversationId,
    required String message,
    required MessageType messageType,
    String? rentalId
  }) async {
    final messageModel = MessageModel(
      id: const Uuid().v4(),
      conversationId: conversationId,
      content: message,
      //system message sender id is null
      senderId: null,
      messageType: messageType,
      createdAt: DateTime.now(),
      rentalId: rentalId
    );
    await sendMessage(messageModel: messageModel);
  }

  @override
  Future<void> updateRentalStatus({
    required String rentalId,
    required RentalStatus status,

  }) async {
    await client.from('rentals').update({'status': status.name}).eq('id', rentalId);

    final String? carId = (await client.from('rentals').select('car_id').eq('id', rentalId).maybeSingle())?['car_id'];

    print("fetched carId from rentals table: $carId");

    if (status == RentalStatus.approved && carId != null){
      //mark car as not available
      await client.from("cars").update(
        {"available": false}
      ).eq("id", carId as String);
    }
  }



//fetch messages of a conversation
@override
  Stream<List<MessageModel>> getMessages({required String conversationId}) {
    
   final res = client.from("messages").stream(primaryKey: ["id"]).eq("conversation_id", conversationId);

    return res.map((rows) => rows.map(MessageModel.fromMap).toList());
  }

@override
Future<List<ConversationModel>> getConversations() async {
  final currentUserId = client.auth.currentUser!.id;

  final res = await client
      .from('conversations')
      .select('*')
      .or('user_1.eq.$currentUserId,user_2.eq.$currentUserId')
      .order('updated_at', ascending: false);

  final conversations = res.map(ConversationModel.fromMap).toList();

  if (conversations.isEmpty) {
    return const [];
  }

  final otherUsersIds = conversations
      .map((conv) => conv.user1 == currentUserId ? conv.user2 : conv.user1)
      .toSet()
      .toList();

  final usersRes = await client
      .from('users')
      .select('id, full_name, profile_image')
      .inFilter('id', otherUsersIds);

  final Map<String, Map<String, dynamic>> usersById = {
    for (final row in usersRes)
      (row['id'] as String): row as Map<String, dynamic>,
  };

  final lastMessageEntries = await Future.wait(
    conversations.map((c) async {
      final row = await client
          .from('messages')
          .select('content, created_at')
          .eq('conversation_id', c.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return MapEntry(c.id, row);
    }),
  );

  final Map<String, Map<String, dynamic>?> lastMessageByConversationId = {
    for (final entry in lastMessageEntries)
      entry.key: entry.value as Map<String, dynamic>?,
  };

  return conversations.map((c) {
    final otherUserId = c.user1 == currentUserId ? c.user2 : c.user1;
    final u = usersById[otherUserId];

    final last = lastMessageByConversationId[c.id];
    final lastMessage = last?['content'] as String?;


    return ConversationModel(
      id: c.id,
      user1: c.user1,
      user2: c.user2,
      updatedAt: c.updatedAt,
      user1UnreadCount: c.user1UnreadCount,
      user2UnreadCount: c.user2UnreadCount,
      otherUserId: otherUserId,
      otherUserName: u?['full_name'] as String?,
      otherUserProfileImage: u?['profile_image'] as String?,
      lastMessage: lastMessage,
    );
  }).toList();
}



  @override
  Future<String?> checkIfChatExists({
  required String user1,
  required String user2,
}) async {
  final res = await client
      .from('conversations')
      .select('id')
      .eq('user_1', user1)
      .eq('user_2', user2)
      .maybeSingle();

  return res?['id'] as String?;
}

  @override
  Future<bool> createChat({
    required String receiverId,
  })async{

    String user1;
    String user2;

    final currentUserId = client.auth.currentUser!.id;

    //always make user1 be the smaller id
    //this is to ensure that the chat id is always the same regardless of the order of the users
    if (currentUserId.compareTo(receiverId) < 0) {
      user1 = currentUserId;
      user2 = receiverId;
    } else {
      user1 = receiverId;
      user2 = currentUserId;
    }

    //check if chat exists
    final chatId = await checkIfChatExists(user1: user1, user2: user2);
    if (chatId != null) {
      //if it does do nothing
      print("chat already exists with id: $chatId");
      return false;
    }

    print("creating new chat...");

    final conversationModel = ConversationModel(
      id: Uuid().v4(),
      user1: user1,
      user2: user2,
      updatedAt: DateTime.now(),
    );

    //if it don't then create new chat
    await client.from('conversations').insert(conversationModel.toMap());

    print("successfully created new chat");

    return true;
  }
}
