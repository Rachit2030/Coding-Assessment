import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/Cubit/chat_cubit.dart';

import 'package:messaging_app/View/chat_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Messaging App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ChatPage(),
      ),
    );
  }
}


