import 'package:hive_flutter/hive_flutter.dart';
import '../Model/message_model.dart';

class HiveService {
  static Box<MessageModel>? _messagesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MessageModelAdapter());
    Hive.registerAdapter(MessageTypeAdapter());
    _messagesBox = await Hive.openBox<MessageModel>('messages');
  }

  static Box<MessageModel> get messagesBox => _messagesBox!;

  static List<MessageModel> getMessages() {
    return messagesBox.values.toList();
  }

  static Future<void> addMessage(MessageModel message) async {
    await messagesBox.add(message);
  }

  static Future<void> clearMessages() async {
    await messagesBox.clear();
  }
}
