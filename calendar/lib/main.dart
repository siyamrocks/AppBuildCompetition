import 'package:calendar/calendar.dart';
import 'package:calendar/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
      title: "ESTech Calendar",
    );
  }
}
