import 'package:flutter/material.dart';
import 'package:flutter_starter/store/store.dart';
import 'package:flutter_starter/studentvue/studentvueclient.dart';

class StudentVueProvider extends ChangeNotifier {
  // shared pref object
  SharedPreferenceHelper sharedPrefsHelper;

  StudentVueProvider() {
    sharedPrefsHelper = SharedPreferenceHelper();
  }

  List<ReportPeriod> _periods;
  StudentData _student;
  bool _isInit = false;

  List<ReportPeriod> get periods {
    return _periods;
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

      var gradebook = await client.loadGradebook();
      _periods = gradebook.periods;

      var info = await client.loadStudentData();
      _student = info;
    }
  }

  void resetData() {
    if (_periods != null) _periods.clear();
    if (_student != null) _student = StudentData();
    _isInit = false;
  }
}
