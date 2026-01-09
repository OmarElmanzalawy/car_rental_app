class ConversationModel {
  final String id;
  final String user1;
  final String user2;
  final DateTime updatedAt;
  final int user1UnreadCount;
  final int user2UnreadCount;

  final String? otherUserId;
  final String? otherUserName;
  final String? otherUserProfileImage;

  final String? lastMessage;

  ConversationModel({
    required this.id,
    required this.user1,
    required this.user2,
    required this.updatedAt,
    this.user1UnreadCount = 0,
    this.user2UnreadCount = 0,

    this.otherUserId,
    this.otherUserName,
    this.otherUserProfileImage,
    this.lastMessage
  });

  //to map to database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_1': user1,
      'user_2': user2,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  //from map
  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] as String,
      user1: map['user_1'] as String,
      user2: map['user_2'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      user1UnreadCount: (map['user_1_unread_count'] as num?)?.toInt() ?? 0,
      user2UnreadCount: (map['user_2_unread_count'] as num?)?.toInt() ?? 0,
    );
  }
}
