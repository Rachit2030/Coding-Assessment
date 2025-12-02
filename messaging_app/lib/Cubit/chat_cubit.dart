import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/Model/message_model.dart';
import 'package:uuid/uuid.dart';


class ChatCubit extends Cubit<List<MessageModel>> {
  ChatCubit() : super([]);

  final _uuid = const Uuid();

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
      final reply = MessageModel(
        id: _uuid.v4(),
        text: "Auto-reply to '$text'",
        isMe: false,
        timestamp: DateTime.now(),
      );
      emit([...state, reply]);
    });
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
