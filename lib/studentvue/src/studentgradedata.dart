class StudentGradeData {
  List<ReportPeriod> periods;
  String studentName;

  String error;

  StudentGradeData({this.periods, this.studentName});

  @override
  String toString() {
    return 'StudentGradeData{periods: $periods, studentName: $studentName}';
  }
}

class ReportPeriod {
  String index;
  String name;
  String startDate;
  String endDate;
  List<SchoolClass> classes;
}

class SchoolClass {
  String className,
      classTeacher,
      classTeacherEmail,
      markingPeriod,
      roomNumber,
      pctGrade,
      letterGrade;
  double earnedPoints, possiblePoints;
  int period;
  List<AssignmentCategory> assignmentCategories;
  List<Assignment> assignments;

  SchoolClass(
      {this.className,
      this.classTeacher,
      this.classTeacherEmail,
      this.markingPeriod,
      this.period,
      this.earnedPoints,
      this.possiblePoints,
      this.assignmentCategories,
      this.assignments});

  @override
  String toString() {
    return 'SchoolClass{className: $className, classTeacher: $classTeacher, classTeacherEmail: $classTeacherEmail, markingPeriod: $markingPeriod, roomNumber: $roomNumber, pctGrade: $pctGrade, earnedPoints: $earnedPoints, possiblePoints: $possiblePoints, period: $period, assignmentCategories: $assignmentCategories, assignments: $assignments}';
  }
}

class Assignment {
  String assignmentName, date, category;
  // earn points = -1 means grade not added
  double earnedPoints, possiblePoints;

  Assignment(
      {this.assignmentName, this.date, this.earnedPoints, this.possiblePoints});

  @override
  String toString() {
    return 'Assignment{assignmentName: $assignmentName, date: $date, category: $category, earnedPoints: $earnedPoints, possiblePoints: $possiblePoints}';
  }
}

class AssignmentCategory {
  double earnedPoints;
  double possiblePoints;
  double weight;
  String name;

  AssignmentCategory({this.name, this.weight});

  @override
  String toString() {
    return 'AssignmentCategory{earnedPoints: $earnedPoints, possiblePoints: $possiblePoints, weight: $weight, name: $name}';
  }
}
