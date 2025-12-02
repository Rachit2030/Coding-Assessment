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
        Uri.parse("http://localhost:4200"), // Angular local dev server
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
