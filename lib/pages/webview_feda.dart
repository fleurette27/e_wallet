import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewFeda extends StatefulWidget {
  const WebviewFeda({super.key, required this.url});

  final String url;
  @override
  State<WebviewFeda> createState() => _WebviewFedaState();
}

class _WebviewFedaState extends State<WebviewFeda> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
      //     onProgress: (int progress) {
      //       // Update loading bar.
      //     },
      //     onPageStarted: (String url) {},
      //     onPageFinished: (String url) {},
      //     onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
      //       if (request.url.startsWith('https://www.youtube.com/')) {
      //         return NavigationDecision.prevent;
      //       }
            return NavigationDecision.navigate;
        },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: WebViewWidget(controller: controller),
    );
  }
}
