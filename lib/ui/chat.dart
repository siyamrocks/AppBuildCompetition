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
  List<SchoolClass> classes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    classes = Provider.of<StudentVueProvider>(context).classes;
    return ListView.builder(
      itemBuilder: (context, index) {
        return TeacherCard(
            name: classes[index].classTeacher,
            email: classes[index].classTeacherEmail);
      },
      itemCount: classes.length,
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
