enum MessageType { text, image, emoji }

class MessageModel {
  final String id;              // Unique ID for the message
  final String text;            // Message content
  final bool isMe;              // Sent by user or not
  final DateTime timestamp;     // Time of message
  final MessageType messageType; // Type of message (text, image, emoji)
  final String? senderName;     // Optional sender name for group chats
  final bool isRead;            // Whether the message has been read

  MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.senderName,
    this.isRead = false,
  });
}
