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
    String school = Provider.of<UserModel>(context).school;

    int index = SchoolData.Calendar.indexWhere((f) => f['name'] == school);

    if (index == -1)
      return Center(child: Text("No calendar found for: $school"));

    String url = SchoolData.Calendar[index]['url'];
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: url,
    );
  }
}
