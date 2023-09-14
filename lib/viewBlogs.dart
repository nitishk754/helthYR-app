import 'package:flutter/material.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewBlog extends StatefulWidget {
  final String blogUrl;
  final String blogTitle;
  ViewBlog(this.blogUrl, this.blogTitle);

  @override
  State<ViewBlog> createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('${widget.blogUrl}')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          ) ..loadRequest(Uri.parse('${widget.blogUrl}')),
      ),
    );
  }
}
