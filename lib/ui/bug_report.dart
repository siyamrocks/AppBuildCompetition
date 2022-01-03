import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BugReport extends StatefulWidget {
  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {
  var _feedback = new TextEditingController();
  String input = "";
  String _id = '';
  String _name = '';
  String _email = '';
  String _school = '';

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _id = user.id;
        _name = user.name;
        _email = user.email;
        _school = user.school;
      });
    }

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
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Send any feedback or a bug report here."),
              TextField(
                controller: _feedback,
                onChanged: (value) {
                  setState(() {
                    input = value;
                  });
                },
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    addReport();
                    _feedback.clear();
                    final snackBar = SnackBar(
                      content: const Text('Feedback has been sent!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: Icon(Icons.bug_report),
                  label: Text("Report Bug"))
            ],
          ),
        ));
  }
}
