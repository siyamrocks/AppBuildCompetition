import 'package:flutter_starter/studentvue/src/studentgradedata.dart';
import 'package:flutter_starter/ui/email.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<ReportPeriod> periods;
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    periods = Provider.of<StudentVueProvider>(context).periods;
    List<SchoolClass> classes = periods[_index].classes;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
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
