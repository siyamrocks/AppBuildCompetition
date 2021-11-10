import 'package:flutter_starter/studentvue/src/studentgradedata.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AssignmentPage extends StatefulWidget {
  final List<Assignment> assignments;
  const AssignmentPage({Key key, @required this.assignments}) : super(key: key);

  @override
  _AssignmentState createState() => _AssignmentState(assignments: assignments);
}

class GradeAssignment extends StatelessWidget {
  final String grade;

  const GradeAssignment({Key key, @required this.grade}) : super(key: key);

  Widget build(BuildContext context) {
    double percent = double.parse(grade);
    String points = grade;
    if (double.tryParse(grade) != null) {
      if (percent > 100) percent = 100;
      if (percent < 0) points = "N/A";
      if (percent < 0) percent = 0;

      return CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 5.0,
        percent: percent / 100,
        center: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              points,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            Text("%")
          ],
        ),
        progressColor: Colors.green,
      );
    } else if (grade != "N/A" && grade.length == 1) {
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

class _AssignmentState extends State<AssignmentPage> {
  final List<Assignment> assignments;
  _AssignmentState({@required this.assignments});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (assignments[index].category == "No Category")
            return SizedBox(height: 0);
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
                    Text(assignments[index].assignmentName,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text(assignments[index].category),
                    Text(assignments[index].date),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              //
                            },
                            icon: Icon(Icons.arrow_forward),
                            label: Text('View'),
                          ),
                          GradeAssignment(
                              grade: (assignments[index].earnedPoints * 100)
                                  .toStringAsFixed(0))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: assignments.length,
      ),
    );
  }
}
