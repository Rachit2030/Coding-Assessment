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
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.grey[100], 
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.grey[900], 
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: ChatPage(),
      ),
    );
  }
}
