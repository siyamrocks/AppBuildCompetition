import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Social extends StatefulWidget {
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: "about:blank",
      onWebViewCreated: (controller) {
        controller.loadUrl(Uri.dataFromString(
                '<a class="twitter-timeline" href="https://twitter.com/GwinnettSchools?ref_src=twsrc%5Etfw">Tweets by GwinnettSchools</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>',
                mimeType: 'text/html',
                encoding: utf8)
            .toString());
      },
    );
  }
}
