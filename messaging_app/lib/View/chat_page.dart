import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // ✅ For emoji keyboard
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/Model/message_model.dart';
import 'dart:io';
import '../cubit/chat_cubit.dart';
import 'chat_bubble.dart';
import '../View/internal_tools/webview_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ImagePicker _picker = ImagePicker();
  bool _showEmojiKeyboard = false; // ✅ Emoji keyboard state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupScrollListener();
    });
  }

  void _setupScrollListener() {
    context.read<ChatCubit>().stream.listen((messages) {
      if (messages.isNotEmpty && _listKey.currentState != null) {
        _listKey.currentState!.insertItem(messages.length - 1);
        _scrollToBottom();
      }
    });
  }

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

  Future<void> _sendImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        context.read<ChatCubit>().sendImage(image.path);
        _scrollToBottom();
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  // ✅ EMOJI TOGGLE
  void _toggleEmojiKeyboard() {
    setState(() {
      _showEmojiKeyboard = !_showEmojiKeyboard;
    });
    
    // Hide system keyboard when showing emoji
    if (_showEmojiKeyboard) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
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
              // ✅ EMOJI KEYBOARD
              if (_showEmojiKeyboard)
                Container(
                  height: 250,
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _emojis.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          final emoji = _emojis[index];
                          _controller.text += emoji;
                          context.read<ChatCubit>().sendEmoji(emoji); // ✅ Use sendEmoji
                          _controller.clear();
                          _toggleEmojiKeyboard();
                          _scrollToBottom();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text(_emojis[index])),
                        ),
                      );
                    },
                  ),
                ),
              _inputBar(isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ EMOJI LIST
  final List<String> _emojis = [
    '😀', '😂', '🤔', '😍', '🥰', '😢', '😎', '👍',
    '👎', '❤️', '🔥', '⭐', '🚀', '💯', '🎉', '🙌',
    '👋', '✋', '🤝', '💪', '👏', '🙏', '🤗', '😘',
    '😜', '🤓', '😇', '🤠', '🥳', '😡', '🤬', '😱',
  ];

  Widget _buildMessagesList() {
    return BlocBuilder<ChatCubit, List<MessageModel>>(
      builder: (context, messages) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (messages.isNotEmpty) _scrollToBottom();
        });

        if (messages.isEmpty) return _emptyWidget();

        return AnimatedList(
          key: _listKey,
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
          initialItemCount: messages.length,
          itemBuilder: (context, index, animation) {
            if (index >= messages.length) return const SizedBox.shrink();
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

  Widget _emptyWidget() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: isDark ? Colors.grey[600] : Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No messages yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[300] : Colors.grey[600])),
          const SizedBox(height: 8),
          Text('Start a conversation!', style: TextStyle(color: Colors.grey[500])),
        ],
      ),
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
          gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(isDark ? 0.3 : 0.1)]),
        ),
        child: AppBar(
          title: const Text("Chat App"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: Icon(Icons.public, color: isDark ? Colors.white : Colors.black87),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  InternalToolsWebView())),
              ),
            ),
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => context.read<ChatCubit>().clearAllMessages()),
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
        border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!, width: 1.5),
        boxShadow: [BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.image, color: isDark ? Colors.white70 : Colors.grey[600]), onPressed: _sendImage),
          const SizedBox(width: 4),
          
          IconButton(
            icon: Icon(_showEmojiKeyboard ? Icons.keyboard : Icons.emoji_emotions, color: isDark ? Colors.white70 : Colors.grey[600]),
            onPressed: _toggleEmojiKeyboard,
          ),
          const SizedBox(width: 8),
          
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: isDark ? Colors.grey[400]! : Colors.grey[500]!, fontSize: 16),
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
              boxShadow: [BoxShadow(color: (isDark ? Colors.blue.shade400 : Colors.blue.shade500).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
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
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }
}
