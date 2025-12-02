import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messaging_app/Model/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(message.timestamp);

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.senderName != null && !message.isMe)
              Text(
                message.senderName!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            _messageContent(),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: message.isMe ? Colors.white70 : Colors.black54,
                  ),
                ),
                if (message.isMe)
                  Icon(
                    message.isRead ? Icons.done_all : Icons.check,
                    size: 12,
                    color: message.isRead ? Colors.white : Colors.white70,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageContent() {
    switch (message.messageType) {
      case MessageType.emoji:
        return Text(
          message.text,
          style: const TextStyle(fontSize: 24),
        );
      case MessageType.image:
        return Image.network(
          message.text,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        );
      case MessageType.text:
      return Text(
          message.text,
          style: TextStyle(
            color: message.isMe ? Colors.white : Colors.black,
          ),
        );
    }
  }
}
