import 'package:flutter/material.dart';
import 'webview_page.dart';

class ToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internal Tools")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Open Dashboard"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => InternalToolsWebView()),
            );
          },
        ),
      ),
    );
  }
}
