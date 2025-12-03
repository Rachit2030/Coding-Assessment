
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messaging_app/Model/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMe = message.isMe;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: 
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Message Bubble (NO timestamp inside)
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: const EdgeInsets.only(bottom: 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMe 
                    ? [const Color(0xFF4FC3F7), const Color(0xFF0288D1)]
                    : [const Color(0xFF26A69A), const Color(0xFF00796B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (isMe ? const Color(0xFF0288D1) : const Color(0xFF00796B))
                        .withOpacity(isDark ? 0.4 : 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMe 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sender name (only for received messages)
                  if (message.senderName != null && !isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  
                  // Message content ONLY
                  _messageContent(context),
                ],
              ),
            ),
          ),
        ),
        
        // REAL SYSTEM TIMESTAMP - Outside bubble
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isMe ? 2 : 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isMe 
              ? MainAxisAlignment.end 
              : MainAxisAlignment.start,
            children: [
              Text(
                _getRealSystemTime(),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                Icon(
                  message.isRead ? Icons.done_all : Icons.done,
                  size: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Get REAL system timestamp (updates every second)
  String _getRealSystemTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm').format(now);
  }

  Widget _messageContent(BuildContext context) {
    return switch (message.messageType) {
      MessageType.emoji => Text(
          message.text,
          style: const TextStyle(fontSize: 28, height: 1.2),
          textAlign: TextAlign.center,
        ),
      MessageType.image => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            message.text,
            width: 180,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.white70,
                size: 50,
              ),
            ),
          ),
        ),
      MessageType.text || _ => Text(
          message.text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
    };
  }
}
