import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';
import 'chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<ChatCubit>().state;

    // Auto scroll after every build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(title: const Text("Messaging App")),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _scrollCtrl,
                itemCount: messages.length,
                itemBuilder: (_, i) => ChatBubble(message: messages[i]),
              ),
            ),
            _inputBar(context),
          ],
        ),
      ),
    );
  }

  // Widget _inputBar(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(12),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             controller: _controller,
  //             decoration: const InputDecoration(
  //               border: OutlineInputBorder(),
  //               hintText: "Type a message",
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         IconButton(
  //           icon: const Icon(Icons.send),
  //           onPressed: () {
  //             final text = _controller.text.trim();
  //             if (text.isNotEmpty) {
  //               context.read<ChatCubit>().sendMessage(text);
  //               _controller.clear();
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _inputBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Type a message...",
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                context.read<ChatCubit>().sendMessage(text);
                _controller.clear();
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
