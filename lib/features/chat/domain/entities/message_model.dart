import 'package:car_rental_app/core/constants/enums.dart';

class MessageModel {

  final String id;
  final String messageId;
  final String senderId;
  final MessageType messageType;
  final String content;
  final String? carId;
  final String? rentalId;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.messageId,
    required this.senderId,
    required this.messageType,
    required this.content,
    this.carId,
    this.rentalId,
    required this.createdAt,
  });

  //to map to database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message_id': messageId,
      'sender_id': senderId,
      'message_type': messageType.index,
      'content': content,
      'car_id': carId,
      'rental_id': rentalId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  //from map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      messageId: map['message_id'] as String,
      senderId: map['sender_id'] as String,
      messageType: MessageType.values[map['message_type'] as int],
      content: map['content'] as String,
      carId: map['car_id'] as String?,
      rentalId: map['rental_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

}