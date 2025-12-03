// import 'dart:math';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:messaging_app/Model/message_model.dart';
// import 'package:uuid/uuid.dart';

// class ChatCubit extends Cubit<List<MessageModel>> {
//   ChatCubit() : super([]);

//   final _uuid = const Uuid();
//   final _random = Random();

//   // Predefined auto-replies
//   final List<String> _generalReplies = [
//     "Hello! How can I assist you today?",
//     "I see, please tell me more.",
//     "Thanks for reaching out!",
//     "I'm here to help you.",
//     "Could you clarify that?",
//     "Interesting, go on...",
//     "Let me think about that...",
//     "That's a good question!",
//     "I understand, please continue.",
//   ];

//   // Optional keyword-based replies
//   final Map<String, String> _keywordReplies = {
//     "hello": "Hi there! How can I help?",
//     "help": "Sure! What do you need assistance with?",
//     "issue": "I'm sorry to hear that. Can you describe the issue?",
//     "thanks": "You're welcome!",
//     "bye": "Goodbye! Have a nice day.",
//   };

//   // Send a text message
//   void sendMessage(String text) {
//     final message = MessageModel(
//       id: _uuid.v4(),
//       text: text,
//       isMe: true,
//       timestamp: DateTime.now(),
//     );

//     emit([...state, message]);

//     // Simulate auto-reply
//     Future.delayed(const Duration(seconds: 1), () {
//       String replyText = _getAutoReply(text);

//       final reply = MessageModel(
//         id: _uuid.v4(),
//         text: replyText,
//         isMe: false,
//         timestamp: DateTime.now(),
//       );

//       emit([...state, reply]);
//     });
//   }

//   // Generate auto-reply based on user input
//   String _getAutoReply(String userInput) {
//     final inputLower = userInput.toLowerCase();

//     // Check for keyword matches
//     for (var keyword in _keywordReplies.keys) {
//       if (inputLower.contains(keyword)) {
//         return _keywordReplies[keyword]!;
//       }
//     }

//     // Fallback to random general reply
//     return _generalReplies[_random.nextInt(_generalReplies.length)];
//   }

//   // Mark message as read
//   void markAsRead(String id) {
//     final updated = state.map((msg) {
//       if (msg.id == id) {
//         return MessageModel(
//           id: msg.id,
//           text: msg.text,
//           isMe: msg.isMe,
//           timestamp: msg.timestamp,
//           messageType: msg.messageType,
//           senderName: msg.senderName,
//           isRead: true,
//         );
//       }
//       return msg;
//     }).toList();
//     emit(updated);
//   }
// }


// import 'dart:math';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:messaging_app/Model/message_model.dart';
// import 'package:messaging_app/service/hive_service.dart';
// import 'package:uuid/uuid.dart';

// class ChatCubit extends Cubit<List<MessageModel>> {
//   ChatCubit() : super(HiveService.getMessages()); // Load from Hive on init

//   final _uuid = const Uuid();
//   final _random = Random();

//   // Predefined auto-replies
//   final List<String> _generalReplies = [
//     "Hello! How can I assist you today?",
//     "I see, please tell me more.",
//     "Thanks for reaching out!",
//     "I'm here to help you.",
//     "Could you clarify that?",
//     "Interesting, go on...",
//     "Let me think about that...",
//     "That's a good question!",
//     "I understand, please continue.",
//   ];

//   // Optional keyword-based replies
//   final Map<String, String> _keywordReplies = {
//     "hello": "Hi there! How can I help?",
//     "help": "Sure! What do you need assistance with?",
//     "issue": "I'm sorry to hear that. Can you describe the issue?",
//     "thanks": "You're welcome!",
//     "bye": "Goodbye! Have a nice day.",
//   };

//   // Send a text message - SAVES TO HIVE
//   void sendMessage(String text) {
//     final message = MessageModel(
//       id: _uuid.v4(),
//       text: text,
//       isMe: true,
//       timestamp: DateTime.now(),
//       messageType: MessageType.text,
//       isRead: false,
//     );

//     // Save to Hive & emit updated list
//     HiveService.addMessage(message);
//     emit(HiveService.getMessages());

//     // Simulate auto-reply
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!isClosed) { // Check if cubit still active
//         String replyText = _getAutoReply(text);

//         final reply = MessageModel(
//           id: _uuid.v4(),
//           text: replyText,
//           isMe: false,
//           timestamp: DateTime.now(),
//           messageType: MessageType.text,
//         );

//         // Save to Hive & emit updated list
//         HiveService.addMessage(reply);
//         emit(HiveService.getMessages());
//       }
//     });
//   }

//   // Generate auto-reply based on user input
//   String _getAutoReply(String userInput) {
//     final inputLower = userInput.toLowerCase();

//     // Check for keyword matches
//     for (var keyword in _keywordReplies.keys) {
//       if (inputLower.contains(keyword)) {
//         return _keywordReplies[keyword]!;
//       }
//     }

//     // Fallback to random general reply
//     return _generalReplies[_random.nextInt(_generalReplies.length)];
//   }

//   // Mark message as read - UPDATES HIVE
//   void markAsRead(String id) {
//     final messagesBox = HiveService.messagesBox;
//     final updatedMessages = <MessageModel>[];

//     for (int i = 0; i < messagesBox.length; i++) {
//       final msg = messagesBox.getAt(i)!;
//       if (msg.id == id) {
//         // Update in Hive directly
//         messagesBox.putAt(i, MessageModel(
//           id: msg.id,
//           text: msg.text,
//           isMe: msg.isMe,
//           timestamp: msg.timestamp,
//           messageType: msg.messageType,
//           senderName: msg.senderName,
//           isRead: true,
//         ));
//       }
//       updatedMessages.add(messagesBox.getAt(i)!);
//     }

//     emit(updatedMessages);
//   }

//   // Clear all messages
//   void clearMessages() {
//     HiveService.clearMessages();
//     emit([]);
//   }

//   void clearAllMessages() {
//     HiveService.clearMessages();  // ✅
//     emit([]);

//   }

//   void sendImage(String imagePath) {
//   final message = MessageModel(
//     id: _uuid.v4(),
//     text: imagePath,  // Store local file path
//     isMe: true,
//     timestamp: DateTime.now(),
//     messageType: MessageType.image,
//   );
  
//   HiveService.addMessage(message);
//   emit(List.from(HiveService.getMessages())); // Force UI update
// }

//   void deleteMessage(String messageId) {
//     final box = HiveService.messagesBox;
//     final index = box.values.toList().indexWhere((msg) => msg.id == messageId);
//     if (index != -1) {  // ✅ Check exists first
//       box.deleteAt(index);
//     emit(HiveService.getMessages());
//     }
//   }
//   @override
//   Future<void> close() {
//     return super.close();
//   }
// }


import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/Model/message_model.dart';
import 'package:messaging_app/service/hive_service.dart';
import 'package:uuid/uuid.dart';

class ChatCubit extends Cubit<List<MessageModel>> {
  ChatCubit() : super(HiveService.getMessages());

  final _uuid = const Uuid();
  final _random = Random();

  // Text replies
  final List<String> _generalReplies = [
    "Hello! How can I assist you today?",
    "I see, please tell me more.",
    "Thanks for reaching out!",
    "I'm here to help you.",
    "Could you clarify that?",
    "Interesting, go on...",
    "Let me think about that...",
    "That's a good question!",
    "I understand, please continue.",
  ];

  final Map<String, String> _keywordReplies = {
    "hello": "Hi there! How can I help?",
    "help": "Sure! What do you need assistance with?",
    "issue": "I'm sorry to hear that. Can you describe the issue?",
    "thanks": "You're welcome!",
    "bye": "Goodbye! Have a nice day.",
  };

  // ✅ NEW: Image replies
  final List<String> _imageReplies = [
    "Nice photo! 📸",
    "Cool picture! 😍",
    "Great shot! 👏",
    "Beautiful! ✨",
    "Love this! ❤️",
  ];

  // ✅ NEW: Emoji replies
  final List<String> _emojiReplies = [
    "😊 That's awesome!",
    "😂 Haha nice one!",
    "🤔 Interesting choice!",
    "🥰 Love this emoji!",
    "👍 Perfect!",
    "🔥 Fire emoji!",
    "⭐ Great pick!",
  ];

  // ✅ TEXT MESSAGE - Existing logic
  void sendMessage(String text) {
    final message = MessageModel(
      id: _uuid.v4(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      messageType: MessageType.text,
    );

    HiveService.addMessage(message);
    emit(List.from(HiveService.getMessages()));

    // Auto-reply after 1s
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        final replyText = _getTextReply(text);
        _sendReply(replyText, MessageType.text);
      }
    });
  }

  // ✅ NEW: IMAGE MESSAGE
  void sendImage(String imagePath) {
    final message = MessageModel(
      id: _uuid.v4(),
      text: imagePath,
      isMe: true,
      timestamp: DateTime.now(),
      messageType: MessageType.image,
    );

    HiveService.addMessage(message);
    emit(List.from(HiveService.getMessages()));

    // Image auto-reply
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        final replyText = _imageReplies[_random.nextInt(_imageReplies.length)];
        _sendReply(replyText, MessageType.text);
      }
    });
  }

  // ✅ NEW: EMOJI MESSAGE DETECTION
  void sendEmoji(String emoji) {
    final message = MessageModel(
      id: _uuid.v4(),
      text: emoji,
      isMe: true,
      timestamp: DateTime.now(),
      messageType: MessageType.emoji,
    );

    HiveService.addMessage(message);
    emit(List.from(HiveService.getMessages()));

    // Emoji auto-reply
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        final replyText = _emojiReplies[_random.nextInt(_emojiReplies.length)];
        _sendReply(replyText, MessageType.text);
      }
    });
  }

  // ✅ HELPER: Send reply message
  void _sendReply(String text, MessageType type) {
    final reply = MessageModel(
      id: _uuid.v4(),
      text: text,
      isMe: false,
      timestamp: DateTime.now(),
      messageType: type,
    );

    HiveService.addMessage(reply);
    emit(List.from(HiveService.getMessages()));
  }

  // ✅ TEXT REPLY LOGIC
  String _getTextReply(String userInput) {
    final inputLower = userInput.toLowerCase();

    // Keyword matches
    for (var keyword in _keywordReplies.keys) {
      if (inputLower.contains(keyword)) {
        return _keywordReplies[keyword]!;
      }
    }

    // Random general reply
    return _generalReplies[_random.nextInt(_generalReplies.length)];
  }

  void clearAllMessages() {
    HiveService.clearMessages();
    emit([]); // ✅ Forces UI update
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
