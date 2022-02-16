/*
This is the file for the school clubs.
*/

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
    // Get the user's school from the user model.
    String school = Provider.of<UserModel>(context).school;

    // Get the PDF URL based on the school name.
    int index = SchoolData.Clubs.indexWhere((f) => f['name'] == school);

    // If no URL was found for the school then inform the user.
    if (index == -1) return Center(child: Text("No clubs found for: $school"));

    // Create a WebView with the inital page set to the URL.
    String url = SchoolData.Clubs[index]['url'];
    return WebView(
        javascriptMode: JavascriptMode.unrestricted, initialUrl: url);
  }
}
