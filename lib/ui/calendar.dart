/*
This is the file for the school calendar.
*/

import 'package:flutter/material.dart';
import 'package:flutter_starter/constants/schools.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    // Get the user's school from the user model.
    String school = Provider.of<UserModel>(context).school;

    // Get the Google Calendar URL based on the school name.
    int index = SchoolData.Calendar.indexWhere((f) => f['name'] == school);

    // If no URL was found for the school then inform the user.
    if (index == -1)
      return Center(child: Text("No calendar found for: $school"));

    // Create a WebView with the inital page set to the URL.
    String url = SchoolData.Calendar[index]['url'];
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: url,
    );
  }
}
