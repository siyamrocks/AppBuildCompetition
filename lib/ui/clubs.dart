import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Clubs extends StatefulWidget {
  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl:
          'https://docs.google.com/viewer?url=https%3A%2F%2Fwww.gcpsk12.org%2F%2Fcms%2Flib%2FGA02204486%2FCentricity%2FDomain%2F8265%2FDocuments%2F21-22%20Clubs.xlsx&embedded=true',
    );
  }
}
