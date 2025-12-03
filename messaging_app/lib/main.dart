// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:messaging_app/View/internal_tools/tools_page.dart';
// import 'package:messaging_app/View/widgets/splash_page_widget.dart';
// import 'cubit/chat_cubit.dart';
// import 'view/chat_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Provide ChatCubit at the top level
//     return BlocProvider(
//       create: (_) => ChatCubit(),
//       child: MaterialApp(
//         theme: ThemeData.light(useMaterial3: true).copyWith(
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: Colors.blue,
//             brightness: Brightness.light,
//           ),
//           scaffoldBackgroundColor: Colors.grey[100], 
//         ),
//         darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: Colors.blue,
//             brightness: Brightness.dark,
//           ),
//           scaffoldBackgroundColor: Colors.grey[900], 
//         ),
//         themeMode: ThemeMode.system,
//         debugShowCheckedModeBanner: false,
//         routes: {
//         '/': (_) => const ChatPage(),
//         '/tools': (_) => ToolsPage(),
//         '/splash': (_) => const SplashPage(),
//       },
//       initialRoute: '/splash',
//       ),
      
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/View/internal_tools/tools_page.dart';
import 'package:messaging_app/View/widgets/splash_page_widget.dart';
import 'cubit/chat_cubit.dart';
import 'view/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(),
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.transparent, // Transparent for gradients
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.transparent, // Transparent for gradients
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashPage(),
          '/': (_) => const ChatPage(),
          '/tools': (_) => ToolsPage(),
        },
      ),
    );
  }
}

