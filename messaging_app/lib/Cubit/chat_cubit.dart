// import 'dart:math';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:messaging_app/Model/message_model.dart';
// import 'package:messaging_app/service/hive_service.dart';
// import 'package:uuid/uuid.dart';

// class ChatCubit extends Cubit<List<MessageModel>> {
//   ChatCubit() : super(HiveService.getMessages());

//   final _uuid = const Uuid();
//   final _random = Random();

//   // Text replies
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

//   final Map<String, String> _keywordReplies = {
//     "hello": "Hi there! How can I help?",
//     "help": "Sure! What do you need assistance with?",
//     "issue": "I'm sorry to hear that. Can you describe the issue?",
//     "thanks": "You're welcome!",
//     "bye": "Goodbye! Have a nice day.",
//   };

//   // ✅ NEW: Image replies
//   final List<String> _imageReplies = [
//     "Nice photo! 📸",
//     "Cool picture! 😍",
//     "Great shot! 👏",
//     "Beautiful! ✨",
//     "Love this! ❤️",
//   ];

//   // ✅ NEW: Emoji replies
//   final List<String> _emojiReplies = [
//     "😊 That's awesome!",
//     "😂 Haha nice one!",
//     "🤔 Interesting choice!",
//     "🥰 Love this emoji!",
//     "👍 Perfect!",
//     "🔥 Fire emoji!",
//     "⭐ Great pick!",
//   ];

//   // ✅ TEXT MESSAGE - Existing logic
//   void sendMessage(String text) {
//     final message = MessageModel(
//       id: _uuid.v4(),
//       text: text,
//       isMe: true,
//       timestamp: DateTime.now(),
//       messageType: MessageType.text,
//     );

//     HiveService.addMessage(message);
//     emit(List.from(HiveService.getMessages()));

//     // Auto-reply after 1s
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!isClosed) {
//         final replyText = _getTextReply(text);
//         _sendReply(replyText, MessageType.text);
//       }
//     });
//   }

//   // ✅ NEW: IMAGE MESSAGE
//   void sendImage(String imagePath) {
//     final message = MessageModel(
//       id: _uuid.v4(),
//       text: imagePath,
//       isMe: true,
//       timestamp: DateTime.now(),
//       messageType: MessageType.image,
//     );

//     HiveService.addMessage(message);
//     emit(List.from(HiveService.getMessages()));

//     // Image auto-reply
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!isClosed) {
//         final replyText = _imageReplies[_random.nextInt(_imageReplies.length)];
//         _sendReply(replyText, MessageType.text);
//       }
//     });
//   }

//   // ✅ NEW: EMOJI MESSAGE DETECTION
//   void sendEmoji(String emoji) {
//     final message = MessageModel(
//       id: _uuid.v4(),
//       text: emoji,
//       isMe: true,
//       timestamp: DateTime.now(),
//       messageType: MessageType.emoji,
//     );

//     HiveService.addMessage(message);
//     emit(List.from(HiveService.getMessages()));

//     // Emoji auto-reply
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!isClosed) {
//         final replyText = _emojiReplies[_random.nextInt(_emojiReplies.length)];
//         _sendReply(replyText, MessageType.text);
//       }
//     });
//   }

//   // ✅ HELPER: Send reply message
//   void _sendReply(String text, MessageType type) {
//     final reply = MessageModel(
//       id: _uuid.v4(),
//       text: text,
//       isMe: false,
//       timestamp: DateTime.now(),
//       messageType: type,
//     );

//     HiveService.addMessage(reply);
//     emit(List.from(HiveService.getMessages()));
//   }

//   // ✅ TEXT REPLY LOGIC
//   String _getTextReply(String userInput) {
//     final inputLower = userInput.toLowerCase();

//     // Keyword matches
//     for (var keyword in _keywordReplies.keys) {
//       if (inputLower.contains(keyword)) {
//         return _keywordReplies[keyword]!;
//       }
//     }

//     // Random general reply
//     return _generalReplies[_random.nextInt(_generalReplies.length)];
//   }

//   void clearAllMessages() {
//     HiveService.clearMessages();
//     emit([]); // ✅ Forces UI update
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

  // ✅ FIXED: UNIFIED sendMessage - Detects emoji automatically!
  void sendMessage(String text) {
    // 🔥 AUTO-DETECT emoji vs text
    final messageType = _detectMessageType(text);
    
    final message = MessageModel(
      id: _uuid.v4(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      messageType: messageType,
    );

    HiveService.addMessage(message);
    emit(List.from(HiveService.getMessages()));

    // Auto-reply after 1s
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        final replyText = _getReplyForType(messageType, text);
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

  // ✅ DEPRECATED: No longer needed - use sendMessage()
  @deprecated 
  void sendEmoji(String emoji) {
    sendMessage(emoji); // Redirects to unified method
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

  // ✅ NEW: SMART REPLY SELECTION
  String _getReplyForType(MessageType type, String input) {
    switch (type) {
      case MessageType.image:
        return _imageReplies[_random.nextInt(_imageReplies.length)];
      case MessageType.emoji:
        return _emojiReplies[_random.nextInt(_emojiReplies.length)];
      case MessageType.text:
        return _getTextReply(input);
    }
  }

  // ✅ FIXED: TEXT REPLY LOGIC
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

  // 🔥 NEW: NATIVE EMOJI DETECTION
  MessageType _detectMessageType(String text) {
    if (text.trim().isEmpty) return MessageType.text;
    
    // Comprehensive emoji regex covering ALL Unicode emoji ranges
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}'   // Emoticons
      r'|\u{1F300}-\u{1F5FF}'   // Symbols & Pictographs
      r'|\u{1F680}-\u{1F6FF}'   // Transport & Map Symbols
      r'|\u{1F1E0}-\u{1F1FF}'   // Flags
      r'|\u{2600}-\u{26FF}'     // Miscellaneous Symbols
      r'|\u{2700}-\u{27BF}]',    // Dingbats
      unicode: true,
    );
    
    // ✅ If mostly emoji (short text + emoji chars)
    final emojiCount = emojiRegex.allMatches(text).length;
    final totalLength = text.length;
    
    if (emojiCount > 0 && totalLength <= 10) {
      return MessageType.emoji;
    }
    
    return MessageType.text;
  }

  void clearAllMessages() {
    HiveService.clearMessages();
    emit([]);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
