import 'package:flutter/material.dart';
import 'package:flutter_starter/constants/schools.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Social extends StatefulWidget {
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  @override
  Widget build(BuildContext context) {
    String url = "https://twitter.com/GwinnettSchools?ref_src=twsrc%5Etfw";
    return WebView(
        javascriptMode: JavascriptMode.unrestricted, initialUrl: url);
  }
}
