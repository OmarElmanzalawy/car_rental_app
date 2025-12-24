import 'package:car_rental_app/features/chat/domain/entities/conversation_model.dart';
import 'package:car_rental_app/features/chat/domain/entities/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage({
    required MessageModel messageModel,
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

}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient client;

  ChatRemoteDataSourceImpl(this.client);

  @override
  Future<void> sendMessage({
    required MessageModel messageModel,
  }) async {
    await client.from("messages").insert(messageModel.toMap());
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

  return res
      .map(ConversationModel.fromMap)
      .toList();
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
