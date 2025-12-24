import 'package:car_rental_app/core/constants/enums.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String? senderId;
  final MessageType messageType;
  final String content;
  final String? carId;
  final String? rentalId;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.messageType,
    required this.content,
    this.carId,
    this.rentalId,
    required this.createdAt,
  });

  static MessageType _parseMessageType(dynamic raw) {
    if (raw is int) {
      return MessageType.values[raw];
    }
    if (raw is String) {
      return MessageType.values.firstWhere(
        (t) => t.value == raw,
        orElse: () => MessageType.text,
      );
    }
    return MessageType.text;
  }

  static DateTime _parseCreatedAt(dynamic raw) {
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.parse(raw);
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    return DateTime.now();
  }

  //to map to database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'type': messageType.value,
      'content': content,
      'car_id': carId,
      'rental_id': rentalId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  //from map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    final rawType = map['type'] ?? map['message_type'];
    return MessageModel(
      id: map['id'] as String,
      conversationId: (map['conversation_id'] ?? map['conversationId']) as String,
      senderId: map['sender_id'] as String?,
      messageType: _parseMessageType(rawType),
      content: map['content'] as String,
      carId: map['car_id'] as String?,
      rentalId: map['rental_id'] as String?,
      createdAt: _parseCreatedAt(map['created_at']),
    );
  }

}
