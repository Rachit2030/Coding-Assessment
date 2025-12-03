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
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Message Bubble
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                // BETTER CHAT COLORS
                gradient: LinearGradient(
                  colors: isMe 
                    ? [Colors.blue.shade500, Colors.blue.shade700]  // Clean Blue
                    : [Colors.green.shade400, Colors.green.shade600], // Fresh Green
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (isMe ? Colors.blue.shade700 : Colors.green.shade600)
                        .withOpacity(isDark ? 0.5 : 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                  
                  // Message content
                  _messageContent(context),
                ],
              ),
            ),
          ),
        ),
        
        // TIMESTAMP - Theme Adaptive (Outside bubble)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: isMe ? 1 : 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                _getRealSystemTime(),
                style: TextStyle(
                  fontSize: 11,
                  color: isDark 
                    ? Colors.white.withOpacity(0.8)      // Bright white in dark
                    : Colors.grey[700]!,                 // Dark grey in light
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                Icon(
                  message.isRead ? Icons.done_all : Icons.done,
                  size: 12,
                  color: isDark 
                    ? Colors.white.withOpacity(0.8)      // Bright white in dark
                    : Colors.grey[700]!,                 // Dark grey in light
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Get REAL system timestamp (HH:mm format)
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
                gradient: LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey.shade600,
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
