import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class InternalToolsWebView extends StatefulWidget {
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
    ? "http://10.0.2.2:4200"
    : "http://localhost:4200"
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
