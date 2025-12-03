import 'package:hive/hive.dart';

part 'message_model.g.dart'; // Generated file

@HiveType(typeId: 0)
enum MessageType {
  @HiveField(0) text,
  @HiveField(1) image,
  @HiveField(2) emoji,
}

@HiveType(typeId: 1)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isMe;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final MessageType messageType;

  @HiveField(5)
  final String? senderName;

  @HiveField(6)
  final bool isRead;

  MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.isRead = false,
    this.senderName,
  });

  // Helper for ChatBubble timestamp display
  String get formattedTime => _formatTime(timestamp);

  static String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
