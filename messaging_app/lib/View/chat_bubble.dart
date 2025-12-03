// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:messaging_app/Model/message_model.dart';

// class ChatBubble extends StatelessWidget {
//   final MessageModel message;
//   const ChatBubble({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final isMe = message.isMe;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         // Message Bubble
//         Align(
//           alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.75,
//               ),
//               margin: const EdgeInsets.only(bottom: 4),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: isMe 
//                     ? [Colors.blue.shade500, Colors.blue.shade700]
//                     : [Colors.green.shade400, Colors.green.shade600],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: (isMe ? Colors.blue.shade700 : Colors.green.shade600)
//                         .withOpacity(isDark ? 0.5 : 0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (message.senderName != null && !isMe)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       child: Text(
//                         message.senderName!,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                     ),
                  
//                   _messageContent(context),
//                 ],
//               ),
//             ),
//           ),
//         ),
        
//         // ✅ ACTUAL MESSAGE TIMESTAMP from Hive
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: isMe ? 1 : 3),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//             children: [
//               Text(
//                 message.formattedTime,  // ✅ Uses Hive timestamp (HH:mm)
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: isDark 
//                     ? Colors.white.withOpacity(0.8)
//                     : Colors.grey[700]!,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//               if (isMe) ...[
//                 const SizedBox(width: 4),
//                 Icon(
//                   message.isRead ? Icons.done_all : Icons.done,
//                   size: 12,
//                   color: isDark 
//                     ? Colors.white.withOpacity(0.8)
//                     : Colors.grey[700]!,
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }

// Widget _messageContent(BuildContext context) {
//   return switch (message.messageType) {
//     // ✅ TEXT
//     MessageType.text => Text(
//         message.text,
//         style: const TextStyle(
//           fontSize: 16,
//           color: Colors.white,
//           height: 1.4,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
    
//     // ✅ EMOJI
//     MessageType.emoji => Text(
//         message.text,
//         style: const TextStyle(fontSize: 28, height: 1.2),
//         textAlign: TextAlign.center,
//       ),
    
//     // ✅ FIXED: LOCAL IMAGES
//     MessageType.image => ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: _buildImageWidget(message.text),
//       ),
//   };
// }

// Widget _buildImageWidget(String imagePath) {
//   // Check if local file
//   if (imagePath.startsWith('/')) {
//     return Image.file(
//       File(imagePath),
//       width: 180,
//       height: 180,
//       fit: BoxFit.cover,
//       errorBuilder: (context, error, stackTrace) => _imageErrorWidget(),
//     );
//   }
  
//   // Network image fallback
//   return Image.network(
//     imagePath,
//     width: 180,
//     height: 180,
//     fit: BoxFit.cover,
//     errorBuilder: (context, error, stackTrace) => _imageErrorWidget(),
//   );
// }

// Widget _imageErrorWidget() {
//   return Container(
//     height: 180,
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Colors.grey.shade300, Colors.grey.shade400],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child:  Icon(
//       Icons.image_not_supported,
//       color: Colors.grey.shade600,
//       size: 50,
//     ),
//   );
// }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:messaging_app/Model/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMe = message.isMe;
    
    // ✅ DISTINCT COLORS + ICONS
    Color bubbleColor, senderColor;
    IconData? senderIcon;
    
    if (isMe) {
      bubbleColor = Colors.blue.shade500;
      senderColor = Colors.blue.shade200;
    } else if (message.senderName == 'Rachit AI') {
      bubbleColor = Colors.green.shade500;  // 🟢 Rachit AI
      senderColor = Colors.green.shade200;
      senderIcon = Icons.smart_toy;         // 🤖
    } else {
      bubbleColor = Colors.orange.shade500; // 🟠 Fallback Bot
      senderColor = Colors.orange.shade200;
      senderIcon = Icons.chat_bubble_outline; // 💭
    }

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
                gradient: LinearGradient(
                  colors: [bubbleColor.withOpacity(0.9), bubbleColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: bubbleColor.withOpacity(isDark ? 0.4 : 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ SENDER NAME + ICON
                  if (message.senderName != null && !isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (senderIcon != null) ...[
                            Icon(senderIcon, size: 14, color: senderColor),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            message.senderName!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: senderColor,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(color: Colors.black.withOpacity(0.3), offset: Offset(0, 1), blurRadius: 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  _messageContent(context),
                ],
              ),
            ),
          ),
        ),
        
        // Timestamp
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: isMe ? 1 : 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                message.formattedTime,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700]!,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                Icon(
                  message.isRead ? Icons.done_all : Icons.done,
                  size: 12,
                  color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700]!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _messageContent(BuildContext context) {
    return switch (message.messageType) {
      MessageType.text => Text(
          message.text,
          style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.4, fontWeight: FontWeight.w500),
        ),
      MessageType.emoji => Text(
          message.text,
          style: const TextStyle(fontSize: 28, height: 1.2),
          textAlign: TextAlign.center,
        ),
      MessageType.image => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildImageWidget(message.text),
        ),
    };
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.startsWith('/')) {
      return Image.file(File(imagePath), width: 180, height: 180, fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imageErrorWidget());
    }
    return Image.network(imagePath, width: 180, height: 180, fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imageErrorWidget());
  }

  Widget _imageErrorWidget() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade400],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.image_not_supported, color: Colors.grey.shade600, size: 50),
    );
  }
}
