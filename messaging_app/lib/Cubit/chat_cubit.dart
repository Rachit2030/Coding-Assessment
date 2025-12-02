import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/Model/message_model.dart';
import 'package:uuid/uuid.dart';

class ChatCubit extends Cubit<List<MessageModel>> {
  ChatCubit() : super([]);

  final _uuid = const Uuid();
  final _random = Random();

  // Predefined auto-replies
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

  // Optional keyword-based replies
  final Map<String, String> _keywordReplies = {
    "hello": "Hi there! How can I help?",
    "help": "Sure! What do you need assistance with?",
    "issue": "I'm sorry to hear that. Can you describe the issue?",
    "thanks": "You're welcome!",
    "bye": "Goodbye! Have a nice day.",
  };

  // Send a text message
  void sendMessage(String text) {
    final message = MessageModel(
      id: _uuid.v4(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
    );

    emit([...state, message]);

    // Simulate auto-reply
    Future.delayed(const Duration(seconds: 1), () {
      String replyText = _getAutoReply(text);

      final reply = MessageModel(
        id: _uuid.v4(),
        text: replyText,
        isMe: false,
        timestamp: DateTime.now(),
      );

      emit([...state, reply]);
    });
  }

  // Generate auto-reply based on user input
  String _getAutoReply(String userInput) {
    final inputLower = userInput.toLowerCase();

    // Check for keyword matches
    for (var keyword in _keywordReplies.keys) {
      if (inputLower.contains(keyword)) {
        return _keywordReplies[keyword]!;
      }
    }

    // Fallback to random general reply
    return _generalReplies[_random.nextInt(_generalReplies.length)];
  }

  // Mark message as read
  void markAsRead(String id) {
    final updated = state.map((msg) {
      if (msg.id == id) {
        return MessageModel(
          id: msg.id,
          text: msg.text,
          isMe: msg.isMe,
          timestamp: msg.timestamp,
          messageType: msg.messageType,
          senderName: msg.senderName,
          isRead: true,
        );
      }
      return msg;
    }).toList();
    emit(updated);
  }
}
