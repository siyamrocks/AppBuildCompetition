import 'dart:convert';
import 'package:flutter_starter/studentvue/src/studentgradedata.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:http/http.dart' as http;

class Classes extends StatefulWidget {
  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  List<SchoolClass> classes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    classes = Provider.of<StudentVueProvider>(context).classes;
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(classes[index].className,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("Teacher: " + classes[index].classTeacher),
                  Text("Email: " + classes[index].classTeacherEmail),
                  Text("Room: " + classes[index].roomNumber),
                  Text("Period: " + classes[index].period.toString())
                ],
              ),
            ),
          );
        },
        itemCount: classes.length,
      ),
    );
  }
}
