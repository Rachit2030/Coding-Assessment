// import 'dart:math';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:messaging_app/Model/message_model.dart';
// import 'package:messaging_app/service/hive_service.dart';
// import 'package:uuid/uuid.dart';

// part 'chat_state.dart';

// class ChatCubit extends Cubit<List<MessageModel>> {
//   ChatCubit() : super(HiveService.getMessages());

//   final _uuid = const Uuid();
//   final _random = Random();
  
//   // ✅ FREE Gemini API (15 RPM, 1M tokens/day)
//   static const String _geminiApiKey = 'AIzaSyA3l5TQddngeOxDCg-rtFDubj1MNokJg1A'; // Replace with your key
//   final _model = GenerativeModel(
//     model: 'gemini-2.5-flash',
//     apiKey: _geminiApiKey,
//   );

//   // ✅ EXISTING HARDCODED REPLIES (FALLBACK)
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

//   final List<String> _imageReplies = [
//     "Nice photo! 📸",
//     "Cool picture! 😍",
//     "Great shot! 👏",
//     "Beautiful! ✨",
//     "Love this! ❤️",
//   ];

//   final List<String> _emojiReplies = [
//     "😊 That's awesome!",
//     "😂 Haha nice one!",
//     "🤔 Interesting choice!",
//     "🥰 Love this emoji!",
//     "👍 Perfect!",
//     "🔥 Fire emoji!",
//     "⭐ Great pick!",
//   ];

//   /// ✅ MAIN METHOD: Try Gemini AI → Fallback to hardcoded
//   Future<void> sendMessage(String text) async {
//     final messageType = _detectMessageType(text);
    
//     final userMessage = MessageModel(
//       id: _uuid.v4(),
//       text: text,
//       isMe: true,
//       timestamp: DateTime.now(),
//       messageType: messageType,
//     );

//     HiveService.addMessage(userMessage);
//     emit(List.from(HiveService.getMessages()));

//     // ✅ TRY GEMINI AI FIRST (with timeout & fallback)
//     final aiReply = await _getAIResponse(text, messageType);
//     _sendReply(aiReply, MessageType.text);
//   }

//   /// ✅ GEMINI AI CALL + FALLBACK
//   Future<String> _getAIResponse(String userInput, MessageType type) async {
//     try {
//       // Show "AI typing..." temporarily
//       _sendReply('🤖 AI is typing...', MessageType.text);
      
//       final content = [Content.text(_buildPrompt(userInput, type))];
//       final response = await _model.generateContent(content);
//       final aiText = response.text ?? '';
      
//       // Remove temporary message
//       final messages = List<MessageModel>.from(state);
//       messages.removeWhere((m) => m.text == '🤖 AI is typing...');
//       emit(messages);
      
//       return aiText.isNotEmpty ? aiText : _getFallbackReply(type, userInput);
      
//     } catch (e) {
//       print('❌ Gemini API Error: $e');
//       // Remove typing indicator on error
//       final messages = List<MessageModel>.from(state);
//       messages.removeWhere((m) => m.text == '🤖 AI is typing...');
//       emit(messages);
//       return _getFallbackReply(type, userInput); // ✅ FALLBACK
//     }
//   }

//   /// ✅ SMART FALLBACK (your existing logic)
//   String _getFallbackReply(MessageType type, String input) {
//     switch (type) {
//       case MessageType.image:
//         return _imageReplies[_random.nextInt(_imageReplies.length)];
//       case MessageType.emoji:
//         return _emojiReplies[_random.nextInt(_emojiReplies.length)];
//       case MessageType.text:
//         return _getTextReply(input);
//     }
//   }

//   String _getTextReply(String userInput) {
//     final inputLower = userInput.toLowerCase();
//     for (var keyword in _keywordReplies.keys) {
//       if (inputLower.contains(keyword)) {
//         return _keywordReplies[keyword]!;
//       }
//     }
//     return _generalReplies[_random.nextInt(_generalReplies.length)];
//   }

//   /// ✅ ENHANCED PROMPT for better AI responses
//   String _buildPrompt(String userInput, MessageType type) {
//     String context;
//     switch (type) {
//       case MessageType.image:
//         context = "User sent an image. ";
//       case MessageType.emoji:
//         context = "User sent an emoji: $userInput ";
//       case MessageType.text:
//         context = "";
//     }
    
//     return '''
// You are a helpful AI assistant in a messaging app. Keep responses:
// - Short (1-2 sentences max)
// - Friendly & conversational  
// - Natural (like human chat)
// - Use emojis sparingly 😊

// User: $userInput
// AI:''';
//   }

//   /// ✅ EXISTING METHODS (unchanged)
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
    
//     // Image fallback (no AI for images yet)
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!isClosed) {
//         _sendReply(_imageReplies[_random.nextInt(_imageReplies.length)], MessageType.text);
//       }
//     });
//   }

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

//   MessageType _detectMessageType(String text) {
//     if (text.trim().isEmpty) return MessageType.text;
    
//     final emojiRegex = RegExp(
//       r'[\u{1F600}-\u{1F64F}|\u{1F300}-\u{1F5FF}|\u{1F680}-\u{1F6FF}|\u{1F1E0}-\u{1F1FF}|\u{2600}-\u{26FF}|\u{2700}-\u{27BF}]',
//       unicode: true,
//     );
    
//     final emojiCount = emojiRegex.allMatches(text).length;
//     final totalLength = text.length;
    
//     if (emojiCount > 0 && totalLength <= 10) return MessageType.emoji;
//     return MessageType.text;
//   }

//   void clearAllMessages() {
//     HiveService.clearMessages();
//     emit([]);
//   }

//   @override
//   Future<void> close() => super.close();
// }


// import 'dart:math';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:messaging_app/Model/message_model.dart';
// import 'package:messaging_app/service/hive_service.dart';
// import 'package:uuid/uuid.dart';

// part 'chat_state.dart';

// class ChatCubit extends Cubit<List<MessageModel>> {
//   ChatCubit() : super(HiveService.getMessages());

//   final _uuid = const Uuid();
//   final _random = Random();
  
//   // ✅ FIXED MODEL NAME
//   static const String _geminiApiKey = 'AIzaSyA3l5TQddngeOxDCg-rtFDubj1MNokJg1A';
//   final _model = GenerativeModel(
//     model: 'gemini-2.5-flash', // ✅ CORRECTED MODEL
//     apiKey: _geminiApiKey,
//   );

//   // Your existing hardcoded replies (unchanged)
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

//   final List<String> _imageReplies = [
//     "Nice photo! 📸", "Cool picture! 😍", "Great shot! 👏",
//     "Beautiful! ✨", "Love this! ❤️",
//   ];

//   final List<String> _emojiReplies = [
//     "😊 That's awesome!", "😂 Haha nice one!", "🤔 Interesting choice!",
//     "🥰 Love this emoji!", "👍 Perfect!", "🔥 Fire emoji!", "⭐ Great pick!",
//   ];

//   /// ✅ MAIN: Try Gemini → Instant Fallback (NO typing message)
//   Future<void> sendMessage(String text) async {
//     final messageType = _detectMessageType(text);
    
//     // Add user message
//     final userMessage = MessageModel(
//       id: _uuid.v4(),
//       text: text,
//       isMe: true,
//       timestamp: DateTime.now(),
//       messageType: messageType,
//     );
//     HiveService.addMessage(userMessage);
//     emit(List.from(HiveService.getMessages()));

//     // Visual delay (UI feels natural)
//     await Future.delayed(const Duration(milliseconds: 800));
    
//     // Get AI response (single call → single reply)
//     final aiReply = await _getAIResponse(text, messageType);
//     _sendReply(aiReply, MessageType.text);
//   }

//   /// ✅ CLEAN AI CALL - NO TEMPORARY MESSAGES
//   Future<String> _getAIResponse(String userInput, MessageType type) async {
//     try {
//       final content = [Content.text(_buildPrompt(userInput, type))];
//       final response = await _model.generateContent(content);
//       final aiText = response.text ?? '';
//       return aiText.isNotEmpty ? aiText.trim() : _getFallbackReply(type, userInput);
//     } catch (e) {
//       print('❌ Gemini Error: $e → Using fallback');
//       return _getFallbackReply(type, userInput);
//     }
//   }

//   String _getFallbackReply(MessageType type, String input) {
//     switch (type) {
//       case MessageType.image: return _imageReplies[_random.nextInt(_imageReplies.length)];
//       case MessageType.emoji: return _emojiReplies[_random.nextInt(_emojiReplies.length)];
//       case MessageType.text: return _getTextReply(input);
//     }
//   }

//   String _getTextReply(String userInput) {
//     final inputLower = userInput.toLowerCase();
//     for (var keyword in _keywordReplies.keys) {
//       if (inputLower.contains(keyword)) return _keywordReplies[keyword]!;
//     }
//     return _generalReplies[_random.nextInt(_generalReplies.length)];
//   }

//   String _buildPrompt(String userInput, MessageType type) {
//     return '''
// You are a friendly chat assistant. Respond in 1-2 sentences max, conversational style 😊

// User: $userInput
// AI:''';
//   }

//   // Existing methods unchanged
//   void sendImage(String imagePath) {
//     final message = MessageModel(id: _uuid.v4(), text: imagePath, isMe: true, 
//       timestamp: DateTime.now(), messageType: MessageType.image);
//     HiveService.addMessage(message);
//     emit(List.from(HiveService.getMessages()));
    
//     Future.delayed(Duration(seconds: 1), () {
//       if (!isClosed) _sendReply(_imageReplies[_random.nextInt(_imageReplies.length)], MessageType.text);
//     });
//   }

//   void _sendReply(String text, MessageType type) {
//     final reply = MessageModel(id: _uuid.v4(), text: text, isMe: false, 
//       timestamp: DateTime.now(), messageType: type);
//     HiveService.addMessage(reply);
//     emit(List.from(HiveService.getMessages()));
//   }

//   MessageType _detectMessageType(String text) {
//     if (text.trim().isEmpty) return MessageType.text;
//     final emojiRegex = RegExp(r'[\u{1F600}-\u{1F64F}|\u{1F300}-\u{1F5FF}|\u{1F680}-\u{1F6FF}|\u{1F1E0}-\u{1F1FF}|\u{2600}-\u{26FF}|\u{2700}-\u{27BF}]', unicode: true);
//     final emojiCount = emojiRegex.allMatches(text).length;
//     return (emojiCount > 0 && text.length <= 10) ? MessageType.emoji : MessageType.text;
//   }

//   void clearAllMessages() {
//     HiveService.clearMessages();
//     emit([]);
//   }

//   @override Future<void> close() => super.close();
// }



import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:messaging_app/Model/message_model.dart';
import 'package:messaging_app/service/hive_service.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<List<MessageModel>> {
  ChatCubit() : super(HiveService.getMessages());

  final _uuid = const Uuid();
  final _random = Random();
  
  static const String _geminiApiKey = 'AIzaSyA3l5TQddngeOxDCg-rtFDj1MNokJg1A';
  final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: _geminiApiKey,
  );

  // Hardcoded replies (fallback)
  final List<String> _generalReplies = [
    "Hello! How can I assist you today?", "I see, please tell me more.",
    "Thanks for reaching out!", "I'm here to help you.", "Could you clarify that?",
    "Interesting, go on...", "Let me think about that...", "That's a good question!",
    "I understand, please continue.",
  ];

  final Map<String, String> _keywordReplies = {
    "hello": "Hi there! How can I help?", "help": "Sure! What do you need assistance with?",
    "issue": "I'm sorry to hear that. Can you describe the issue?", 
    "thanks": "You're welcome!", "bye": "Goodbye! Have a nice day.",
  };

  final List<String> _imageReplies = [
    "Nice photo! 📸", "Cool picture! 😍", "Great shot! 👏", 
    "Beautiful! ✨", "Love this! ❤️",
  ];

  final List<String> _emojiReplies = [
    "😊 That's awesome!", "😂 Haha nice one!", "🤔 Interesting choice!",
    "🥰 Love this emoji!", "👍 Perfect!", "🔥 Fire emoji!", "⭐ Great pick!",
  ];

  /// ✅ MAIN: Rachit AI 🟢 vs Fallback Bot 🟠
  Future<void> sendMessage(String text) async {
    final messageType = _detectMessageType(text);
    
    final userMessage = MessageModel(
      id: _uuid.v4(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      messageType: messageType,
      senderName: 'You',
    );

    HiveService.addMessage(userMessage);
    emit(List.from(HiveService.getMessages()));

    await Future.delayed(const Duration(milliseconds: 800));
    
    final aiReply = await _getAIResponse(text, messageType);
    final isFallback = await _isFallbackResponse(aiReply);
    _sendReply(aiReply, MessageType.text, isFallback: isFallback);
  }

  /// ✅ AI CALL → Returns response + fallback detection
  Future<String> _getAIResponse(String userInput, MessageType type) async {
    try {
      final content = [Content.text(_buildPrompt(userInput, type))];
      final response = await _model.generateContent(content);
      final aiText = response.text ?? '';
      return aiText.isNotEmpty ? aiText.trim() : _getFallbackReply(type, userInput);
    } catch (e) {
      print('❌ Gemini Error → Fallback Bot');
      return _getFallbackReply(type, userInput);
    }
  }

  /// ✅ PERFECT FALLBACK DETECTION
  Future<bool> _isFallbackResponse(String response) async {
    final fallbackPatterns = [
      ..._generalReplies, ..._imageReplies, ..._emojiReplies, ..._keywordReplies.values,
    ];
    return fallbackPatterns.any((pattern) => response.contains(pattern));
  }

  /// ✅ SENDER NAMES: "Rachit AI" 🟢 vs "Fallback Bot" 🟠
  void _sendReply(String text, MessageType type, {required bool isFallback}) {
    final reply = MessageModel(
      id: _uuid.v4(),
      text: text.trim(),
      isMe: false,
      timestamp: DateTime.now(),
      messageType: type,
      senderName: isFallback ? 'Fallback Bot' : 'Rachit AI', // ✅ DISTINCT!
    );

    HiveService.addMessage(reply);
    emit(List.from(HiveService.getMessages()));
  }

  String _getFallbackReply(MessageType type, String input) {
    switch (type) {
      case MessageType.image: return _imageReplies[_random.nextInt(_imageReplies.length)];
      case MessageType.emoji: return _emojiReplies[_random.nextInt(_emojiReplies.length)];
      case MessageType.text: return _getTextReply(input);
    }
  }

  String _getTextReply(String userInput) {
    final inputLower = userInput.toLowerCase();
    for (var keyword in _keywordReplies.keys) {
      if (inputLower.contains(keyword)) return _keywordReplies[keyword]!;
    }
    return _generalReplies[_random.nextInt(_generalReplies.length)];
  }

  String _buildPrompt(String userInput, MessageType type) {
    return '''
You are Rachit AI 🤖 - friendly chat assistant. Respond in 1-2 sentences, conversational:

User: $userInput
Rachit AI:''';
  }

  void sendImage(String imagePath) {
    final message = MessageModel(
      id: _uuid.v4(), text: imagePath, isMe: true, timestamp: DateTime.now(),
      messageType: MessageType.image, senderName: 'You',
    );
    HiveService.addMessage(message);
    emit(List.from(HiveService.getMessages()));
    
    Future.delayed(const Duration(seconds: 1), () {
      if (!isClosed) {
        _sendReply(
          _imageReplies[_random.nextInt(_imageReplies.length)], 
          MessageType.text, 
          isFallback: true
        );
      }
    });
  }

  MessageType _detectMessageType(String text) {
    if (text.trim().isEmpty) return MessageType.text;
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}|\u{1F300}-\u{1F5FF}|\u{1F680}-\u{1F6FF}|\u{1F1E0}-\u{1F1FF}|\u{2600}-\u{26FF}|\u{2700}-\u{27BF}]', 
      unicode: true
    );
    final emojiCount = emojiRegex.allMatches(text).length;
    return (emojiCount > 0 && text.length <= 10) ? MessageType.emoji : MessageType.text;
  }

  void clearAllMessages() {
    HiveService.clearMessages();
    emit([]);
  }

  @override Future<void> close() => super.close();
}
