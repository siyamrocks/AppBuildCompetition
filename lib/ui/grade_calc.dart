import 'package:flutter_starter/studentvue/src/studentgradedata.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GradeCalc extends StatefulWidget {
  final List<Assignment> assignments;
  final String name;
  final String category;
  final String date;
  final List<AssignmentCategory> weight;
  final double grade;
  final String classGrade;

  GradeCalc(
      {@required this.assignments,
      @required this.name,
      @required this.category,
      @required this.date,
      @required this.weight,
      @required this.grade,
      @required this.classGrade});

  double newGrade = 0;
  GradeCalcState createState() => GradeCalcState(
      assignments: assignments,
      name: name,
      category: category,
      date: date,
      weight: weight,
      grade: grade,
      classGrade: classGrade);
}

class GradeCalcState extends State<GradeCalc> {
  final List<Assignment> assignments;
  final String name;
  final String category;
  final String date;
  final List<AssignmentCategory> weight;
  final double grade;
  final String classGrade;

  GradeCalcState(
      {@required this.assignments,
      @required this.name,
      @required this.category,
      @required this.date,
      @required this.weight,
      @required this.grade,
      @required this.classGrade});

  double newGrade = 0;
  double newClassGrade = 0;

  void calcGrade() {
    List<double> weighedGrades = [];
    for (int i = 0; i < assignments.length; i++) {
      double correctWeight = 0;
      for (int j = 0; j < weight.length; j++) {
        if (weight[j].name == assignments[i].category)
          correctWeight = weight[j].weight / 100;
      }

      if (assignments[i].earnedPoints != -1.0) {
        weighedGrades.add((assignments[i].earnedPoints * 100) * correctWeight);
      }
    }
    // Get each item in list and add it
    double gradeSum = 0;

    weighedGrades.forEach((num e) {
      gradeSum += e;
    });

    newClassGrade = gradeSum / 1;
  }

  Widget build(BuildContext context) {
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
              Text("Grade calc"),
              Text(name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text(category),
              Text(date),
              Column(children: [
                Slider(
                    value: newGrade,
                    onChanged: (value) {
                      setState(() {
                        newGrade = value;
                      });
                      calcGrade();
                    }),
                Text((newGrade * 100).toStringAsFixed(0) + "%"),
              ]),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TextButton.icon(
                    //   onPressed: () {
                    //     // Grade calc
                    //   },
                    //   icon: Icon(Icons.calculate),
                    //   label: Text('Calc'),
                    // ),
                    GradeAssignment(
                      grade: (classGrade),
                      text: "Old grade",
                    ),
                    GradeAssignment(
                      grade: ((newClassGrade).toStringAsFixed(0)),
                      text: "New grade",
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradeAssignment extends StatelessWidget {
  final String grade;
  final String text;

  const GradeAssignment({Key key, @required this.grade, this.text})
      : super(key: key);

  Widget build(BuildContext context) {
    double percent = double.parse(grade);
    String points = grade;
    if (double.tryParse(grade) != null) {
      if (percent > 100) percent = 100;
      if (percent < 0) points = "N/A";
      if (percent < 0) percent = 0;

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(text),
            Text(""),
            CircularPercentIndicator(
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
            ),
          ],
        ),
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
