/*
This the UI code for Bug reporting.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BugReport extends StatefulWidget {
  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  // Text controller for feedback
  var _feedback = new TextEditingController();

  // User info variables
  String input = "";
  String _id = '';
  String _name = '';
  String _email = '';
  String _school = '';

  @override
  Widget build(BuildContext context) {
    // Get the user data and set the variables.
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _id = user.id;
        _name = user.name;
        _email = user.email;
        _school = user.school;
      });
    }

    // Function to add a bug report the the Firebase DB (feedback table)
    addReport() {
      Map<String, String> data = {
        "feedback": input,
        "name": _name,
        "id": _id,
        "school": _school,
        "email": _email
      };
      FirebaseFirestore.instance.collection("feedback").add(data);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Bug Report"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Send any feedback or a bug report here."),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _feedback,
                  onChanged: (value) {
                    setState(() {
                      input = value; // Set value to input variable
                    });
                  },
                ),
              ),
              // Sumbit feedback button
              ElevatedButton.icon(
                  onPressed: () {
                    if (_feedback.text.isNotEmpty) {
                      // If text input is not empty then add the bug report.
                      addReport();
                      _feedback.clear();
                      // Inform the user that the feedback has been sent.
                      final snackBar = SnackBar(
                        content: const Text('Feedback has been sent!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (_feedback.text.isEmpty) {
                      // If text input is empty the inform the user.
                      final snackBar = SnackBar(
                        content: const Text('Please type something.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  icon: Icon(Icons.bug_report),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber)),
                  label: Text("Report Bug"))
            ],
          ),
        ));
  }
}
