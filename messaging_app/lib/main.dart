import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/Data/routes.dart';
import 'package:messaging_app/View/internal_tools/webview_page.dart';
import 'package:messaging_app/View/widgets/splash_page_widget.dart';
import 'package:messaging_app/service/hive_service.dart';
import 'cubit/chat_cubit.dart';
import 'view/chat_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
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
          scaffoldBackgroundColor: Colors.transparent, 
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.transparent, 
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: splashRoute,
        routes: {
          splashRoute: (_) => const SplashPage(),
          chatPageRoute : (_) => const ChatPage(),
          toolsRoute: (_) => InternalToolsWebView(),
        },
      ),
    );
  }
}

