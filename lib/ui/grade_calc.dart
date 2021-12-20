import 'package:flutter_starter/studentvue/src/studentgradedata.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GradeCalc extends StatefulWidget {
  final String name;
  final String category;
  final String date;
  final double weight;
  final double grade;
  final String classGrade;

  GradeCalc(
      {@required this.name,
      @required this.category,
      @required this.date,
      @required this.weight,
      @required this.grade,
      @required this.classGrade});

  double newGrade = 0;
  GradeCalcState createState() => GradeCalcState(
      name: name,
      category: category,
      date: date,
      weight: weight,
      grade: grade,
      classGrade: classGrade);
}

class GradeCalcState extends State<GradeCalc> {
  final String name;
  final String category;
  final String date;
  final double weight;
  final double grade;
  final String classGrade;

  GradeCalcState(
      {@required this.name,
      @required this.category,
      @required this.date,
      @required this.weight,
      @required this.grade,
      @required this.classGrade});

  double newGrade = 0;

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
                    }),
                Text(newGrade.toString()),
              ]),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    // TextButton.icon(
                    //   onPressed: () {
                    //     // Grade calc
                    //   },
                    //   icon: Icon(Icons.calculate),
                    //   label: Text('Calc'),
                    // ),
                    GradeAssignment(
                      grade: (grade * 100).toStringAsFixed(0),
                      text: "Current grade",
                    ),
                    GradeAssignment(
                      grade: (classGrade),
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
