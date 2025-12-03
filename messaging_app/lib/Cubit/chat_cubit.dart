import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:messaging_app/Data/constants.dart';
import 'package:messaging_app/Model/message_model.dart';
import 'package:messaging_app/service/hive_service.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<List<MessageModel>> {
  ChatCubit() : super(HiveService.getMessages());

  final _uuid = const Uuid();
  final _random = Random();
  final _model = GenerativeModel(
    model: modelname,
    apiKey: geminiApiKey,
  );

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

  // AI CALL → Returns response + fallback detection
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

  // PERFECT FALLBACK DETECTION
  Future<bool> _isFallbackResponse(String response) async {
    final fallbackPatterns = [
      ...generalReplies, ...imageReplies, ...emojiReplies, ...keywordReplies.values,
    ];
    return fallbackPatterns.any((pattern) => response.contains(pattern));
  }

  // SENDER NAMES: "Rachit AI" 🟢 vs "Fallback Bot" 🟠
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
      case MessageType.image: return imageReplies[_random.nextInt(imageReplies.length)];
      case MessageType.emoji: return emojiReplies[_random.nextInt(emojiReplies.length)];
      case MessageType.text: return _getTextReply(input);
    }
  }

  String _getTextReply(String userInput) {
    final inputLower = userInput.toLowerCase();
    for (var keyword in keywordReplies.keys) {
      if (inputLower.contains(keyword)) return keywordReplies[keyword]!;
    }
    return generalReplies[_random.nextInt(generalReplies.length)];
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
          imageReplies[_random.nextInt(imageReplies.length)], 
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
