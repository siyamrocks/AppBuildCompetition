import 'package:flutter/material.dart';
import 'package:flutter_starter/studentvue/studentvueclient.dart';

class StudentVueProvider extends ChangeNotifier {
  List<SchoolClass> _classes;
  StudentData _student;
  bool _isInit = false;

  List<SchoolClass> get classes {
    return _classes;
  }

  StudentData get student {
    return _student;
  }

  void initData(String id, String pass) async {
    if (!_isInit) {
      if (id == null || pass == null) {
        return;
      }

      print("Hello from StudentVUE");

      _isInit = true;

      var client = StudentVueClient(id, pass, 'apps.gwinnett.k12.ga.us/spvue',
          mock: false);

      var grades = await client.loadGradebook();
      _classes = grades.classes;

      var info = await client.loadStudentData();
      _student = info;
    }
  }

  void resetData() {
    _classes.clear();
    _isInit = false;
  }
}
