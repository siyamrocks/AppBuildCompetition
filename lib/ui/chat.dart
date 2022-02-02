/*
This is the file to view all the teachers and view messages.
*/

import 'package:flutter_starter/models/menu_option_model.dart';
import 'package:flutter_starter/studentvue/src/studentgradedata.dart';
import 'package:flutter_starter/ui/components/segmented_selector.dart';
import 'package:flutter_starter/ui/email.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_html/flutter_html.dart';

// Main widget (holds Teachers and Message)
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

// Teacher screen widget
class Teachers extends StatefulWidget {
  @override
  _TeacherState createState() => _TeacherState();
}

// Messages screen widget
class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _ChatState extends State<Chat> {
  String currentOption = "0";

  // Create menu with option to view Teachers or Messages
  final List<MenuOptionsModel> options = [
    MenuOptionsModel(
        key: "0", value: "Teachers", icon: Icons.person_pin_rounded),
    MenuOptionsModel(key: "1", value: "Messages", icon: Icons.message),
  ];

  // List of screens
  final List<Widget> _screens = [
    Teachers(),
    Message(),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              // Show the segmented selector for the user to choose an option
              padding: const EdgeInsets.all(10.0),
              child: SegmentedSelector(
                selectedOption: currentOption,
                menuOptions: options,
                onValueChanged: (value) {
                  setState(() {
                    currentOption = value;
                  });
                },
              ),
            ),
          ),
          // Show the screen based on the current option.
          _screens[int.parse(currentOption)]
        ],
      ),
    );
  }
}

class _TeacherState extends State<Teachers> {
  List<ReportPeriod> periods;
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get all the reporting periods.
    periods = Provider.of<StudentVueProvider>(context).grades.periods;
    // Get all of the user's classes.
    List<SchoolClass> classes = periods[_index].classes;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          // Allow the user to pick a reporting period.
          DropdownButton<int>(
              value: _index,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (int newValue) {
                setState(() {
                  _index = newValue;
                });
              },
              items: periods.map((ReportPeriod value) {
                return DropdownMenuItem<int>(
                  value: int.parse(value.index),
                  child: Text(value.name),
                );
              }).toList()),
          Text(
            "${periods[_index].startDate} - ${periods[_index].endDate}",
            style: TextStyle(fontSize: 10),
          ),
          // Create a list showing all the teachers with option to email them.
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TeacherCard(
                  name: classes[index].classTeacher,
                  email: classes[index].classTeacherEmail);
            },
            itemCount: classes.length,
          ),
        ],
      ),
    );
  }
}

class _MessageState extends State<Message> {
  List<Messages> messages;

  Widget build(BuildContext context) {
    // Get all the messages.
    messages = Provider.of<StudentVueProvider>(context).grades.messages;
    // Show each message by creating a massage card.
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return MessageCard(
          subject: messages[index].subject,
          content: messages[index].content,
          date: messages[index].startDate,
        );
      },
      itemCount: messages.length,
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String email;

  const TeacherCard({Key key, @required this.name, @required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 20,
        child: Column(
          children: [
            ListTile(
              // Show initals image (ex: SA)
              leading: ClipOval(
                child: Image.network("https://ui-avatars.com/api/?name=$name"),
              ),
              title: Text(name),
              subtitle: Text(
                email,
                style: TextStyle(fontSize: 10),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Button to email teacher
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmailSender(email: email)));
                  },
                  icon: Icon(Icons.email),
                  label: Text('Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String subject;
  final String content;
  final String date;

  const MessageCard(
      {Key key, @required this.subject, @required this.content, this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 20,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                title: Text(subject),
                subtitle: Text(
                  date,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewMessage(
                                  subject: subject,
                                  content: content,
                                  date: date,
                                )));
                  },
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Read'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// View message in full screen
class ViewMessage extends StatelessWidget {
  final String subject;
  final String content;
  final String date;

  const ViewMessage(
      {Key key, @required this.subject, @required this.content, this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subject)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(date, style: TextStyle(fontSize: 10)),
                  SizedBox(height: 20),
                  Html(data: content),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
