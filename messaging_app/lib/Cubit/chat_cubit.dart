import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/Model/message_model.dart';


class ChatCubit extends Cubit<List<MessageModel>> {
  ChatCubit() : super([]);

  // V1 implementation of Auto - reply
  void sendMessage(String text) {
    emit([...state, MessageModel(text: text, isMe: true)]);

    Future.delayed(const Duration(seconds: 1), () {
      emit([...state, MessageModel(text: "Auto-reply to '$text'", isMe: false)]);
    });
  }
}
