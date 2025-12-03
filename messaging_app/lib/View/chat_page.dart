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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupScrollListener();
    });
  }

  void _setupScrollListener() {
    // Listen to cubit stream for new messages
    context.read<ChatCubit>().stream.listen((messages) {
      if (messages.isNotEmpty) {
        // Insert new message with animation
        if (_listKey.currentState != null) {
          _listKey.currentState!.insertItem(messages.length - 1);
        }
        // Scroll to bottom
        _scrollToBottom();
      }
    });
  }

  /// FIXED: Reliable scroll to bottom - ALWAYS shows latest message
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(isDark),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF2D2D2D), const Color(0xFF1E1E1E)]
                : [const Color(0xFFF9FEFF), const Color(0xFFF5F8FA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildMessagesList()),
              _inputBar(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return BlocBuilder<ChatCubit, List>(
      builder: (context, messages) {
        // Auto-scroll on every rebuild
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (messages.isNotEmpty) {
            _scrollToBottom();
          }
        });

        return AnimatedList(
          key: _listKey,
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 120), // Extra space
          initialItemCount: messages.length,
          itemBuilder: (context, index, animation) {
            final message = messages[index];
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: 0.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ChatBubble(message: message),
              ),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(isDark ? 0.3 : 0.1)],
          ),
        ),
        child: AppBar(
          title: Text(
            "ChatApp",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: 1.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(Icons.dashboard, color: isDark ? Colors.white : Colors.black87),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  ToolsPage()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputBar(bool isDark) {
    final cubit = context.read<ChatCubit>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850]!.withOpacity(0.9) : Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[400]! : Colors.grey[500]!,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (text) => _sendMessage(cubit, text.trim()),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.shade400 : Colors.blue.shade500,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.blue.shade400 : Colors.blue.shade500).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => _sendMessage(cubit, _controller.text.trim()),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatCubit cubit, String text) {
    if (text.isNotEmpty) {
      cubit.sendMessage(text);
      _controller.clear();
      _scrollToBottom(); // Scroll after sending
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }
}
