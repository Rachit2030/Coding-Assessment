import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/View/internal_tools/tools_page.dart';
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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    // Listen to cubit updates
    context.read<ChatCubit>().stream.listen((messages) {
      if (_listKey.currentState != null && messages.isNotEmpty) {
        _listKey.currentState!.insertItem(messages.length - 1);
        _scrollToBottom();
      }
    });
  }

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

    return Scaffold(
      appBar: AppBar(title: const Text("Messaging App"),actions: [
  IconButton(
    icon: const Icon(Icons.dashboard),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ToolsPage(),
        ),
      );
    },
  )
],),
      
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: AnimatedList(
                key: _listKey,
                controller: _scrollCtrl,
                initialItemCount: messages.length,
                itemBuilder: (context, index, animation) {
                  final message = messages[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: 0.0,
                    child: ChatBubble(message: message),
                  );
                },
              ),
            ),
            _inputBar(),
          ],
        ),
      ),
    );
  }

  Widget _inputBar() {
    final cubit = context.read<ChatCubit>();

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
                  cubit.sendMessage(text);
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
