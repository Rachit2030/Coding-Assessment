import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/chat_cubit.dart';
import 'view/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide ChatCubit at the top level
    return BlocProvider(
      create: (_) => ChatCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatPage(),
      ),
    );
  }
}
