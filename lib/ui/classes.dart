import 'package:flutter_starter/studentvue/src/studentgradedata.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/ui/grades.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Classes extends StatefulWidget {
  @override
  _ClassesState createState() => _ClassesState();
}

class Grade extends StatelessWidget {
  final String grade;

  const Grade({Key key, @required this.grade}) : super(key: key);

  Widget build(BuildContext context) {
    if (double.tryParse(grade) != null) {
      return CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 5.0,
        percent: (double.parse(grade) / 100).clamp(0, 1.0),
        center: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              grade,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("%")
          ],
        ),
        progressColor: Colors.green,
      );
    } else if (grade != "N/A") {
      return Text(
        grade,
        style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black54),
      );
    } else {
      return Text(
        "No grade",
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
      );
    }
  }
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
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32.0, bottom: 0.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classes[index].className,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text("Teacher: " + classes[index].classTeacher),
                    Text("Email: " + classes[index].classTeacherEmail),
                    Text("Room: " + classes[index].roomNumber),
                    Text("Period: " + classes[index].period.toString()),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AssignmentPage(
                                          assignments:
                                              classes[index].assignments,
                                          category: classes[index]
                                              .assignmentCategories,
                                          classGrade:
                                              classes[index].letterGrade,
                                        )),
                              );
                            },
                            icon: Icon(Icons.arrow_forward),
                            label: Text('View'),
                          ),
                          Grade(grade: classes[index].letterGrade)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: classes.length,
      ),
    );
  }
}
