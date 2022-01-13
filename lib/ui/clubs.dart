import 'package:flutter/material.dart';
import 'package:flutter_starter/constants/schools.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Clubs extends StatefulWidget {
  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  @override
  Widget build(BuildContext context) {
    String school = Provider.of<UserModel>(context).school;

    int index = SchoolData.Clubs.indexWhere((f) => f['name'] == school);

    if (index == -1) return Center(child: Text("No clubs found for: $school"));

    String url = SchoolData.Clubs[index]['url'];
    return WebView(
        javascriptMode: JavascriptMode.unrestricted, initialUrl: url);
  }
}
