import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/Data/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';


class InternalToolsWebView extends StatefulWidget {
  const InternalToolsWebView({super.key});

  @override
  State<InternalToolsWebView> createState() => _InternalToolsWebViewState();
}

class _InternalToolsWebViewState extends State<InternalToolsWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
  defaultTargetPlatform == TargetPlatform.android
    ? androidWebviewURL
    : iosWebviewURL
)
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internal Tools Dashboard")),
      body: WebViewWidget(controller: controller),
    );
  }
}
