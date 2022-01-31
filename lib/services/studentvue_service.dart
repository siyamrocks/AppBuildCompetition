import 'package:flutter/material.dart';
import 'package:flutter_starter/store/store.dart';
import 'package:flutter_starter/studentvue/studentvueclient.dart';

class StudentVueProvider extends ChangeNotifier {
  // shared pref object
  SharedPreferenceHelper sharedPrefsHelper;

  StudentVueProvider() {
    sharedPrefsHelper = SharedPreferenceHelper();
  }

  StudentGradeData _grades;
  StudentData _student;
  bool _isInit = false;

  StudentGradeData get grades {
    return _grades;
  }

  StudentData get student {
    return _student;
  }

  void initData(String id, String pass, bool isTestUser) async {
    if (!_isInit) {
      if (id == null || pass == null) {
        return;
      }

      print("Hello from StudentVUE");

      _isInit = true;

      var client = StudentVueClient(id, pass, 'apps.gwinnett.k12.ga.us/spvue',
          mock: isTestUser);

      var gradebook = await client.loadGradebook();
      _grades = gradebook;

      var info = await client.loadStudentData();
      _student = info;
    }
  }

  void resetData() {
    if (_grades != null) _grades = StudentGradeData();
    if (_student != null) _student = StudentData();
    _isInit = false;
  }
}
