import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'mockresponses.dart';
import 'zip_code_result.dart';
import 'studentdata.dart';
import 'package:xml/xml.dart';
import 'studentgradedata.dart';

// void debugPrint(dynamic d) {
//   print(d);
// }

class StudentVueClient {
  final domain;
  String reqURL;

  final bool mock;
  final String username, password;
  final bool studentAccount;
  StudentVueClient(this.username, this.password, this.domain,
      {this.studentAccount = true, this.mock = false}) {
    reqURL = 'https://' + domain + '/Service/PXPCommunication.asmx?WSDL';
  }

  final Dio _dio = Dio(BaseOptions(validateStatus: (_) => true));

  Future<List<SchoolClass>> addClasses(String index) async {
    String resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
          <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
              <userID>$username</userID>
              <password>$password</password>
              <skipLoginLog>1</skipLoginLog>
              <parent>${studentAccount ? '0' : '1'}</parent>
              <webServiceHandleName>PXPWebServices</webServiceHandleName>
              <methodName>Gradebook</methodName>
              ReportPeriod
              <paramStr>&lt;Parms&gt;&lt;ChildIntID&gt;0&lt;/ChildIntID&gt;&lt;ReportPeriod&gt;$index&lt;/ReportPeriod&gt;&lt;/Parms&gt;</paramStr>
          </ProcessWebServiceRequest>
      </soap:Body>
    </soap:Envelope>''';

      _dio.options.headers['content-Type'] = 'text/xml';

      var res = await _dio.post(
        reqURL,
        data: requestData,
      );

      resData = res.data;
    } else {
      resData = MockResponses.GradebookResponse;
    }

    final document = XmlDocument.parse(HtmlUnescape().convert(resData));

    var courses = document.findAllElements('Courses').first;

    var classes = List<SchoolClass>();
    for (int i = 0; i < courses.children.length; i++) {
      XmlNode current = courses.children[i];
//      debugPrint('adding: $current');
      if (current.getAttribute('Title') == null) continue;
      SchoolClass _class = SchoolClass();
      // when regex in doubt
//      _class.className = current.getAttribute('Title').replaceAll(RegExp('\(([A-Z])\w+\)'), '');
      // take the easy way out
      _class.className = current
          .getAttribute('Title')
          .substring(0, current.getAttribute('Title').indexOf('('));
      _class.period = int.tryParse(current.getAttribute('Period') ?? '0') ?? -1;
      _class.roomNumber = current.getAttribute('Room') ?? 'N/A';
      _class.classTeacher = current.getAttribute('Staff') ?? 'N/A';
      _class.classTeacherEmail = current.getAttribute('StaffEMail') ?? 'N/A';

      var mark = current.findAllElements('Mark')?.first;
      if (mark != null) {
        _class.pctGrade = mark.getAttribute('CalculatedScoreRaw');
        _class.letterGrade = mark.getAttribute('CalculatedScoreString');
      }
      current = current.findAllElements('GradeCalculationSummary').first;
      if (current == null) {
        classes.add(_class);
        continue;
      }

      _class.assignmentCategories = List<AssignmentCategory>();
      for (int i = 0; i < current.children.length; i++) {
        if (current.children[i].getAttribute('Type') == 'TOTAL') {
          _class.earnedPoints =
              double.tryParse(current.children[i].getAttribute('Points') ?? '');
          _class.earnedPoints = double.tryParse(
              current.children[i].getAttribute('PointsPossible') ?? '');
          _class.pctGrade ??= current.children[i]
              .getAttribute('WeightedPct'); // replace only if it's already null
        } // else {
        AssignmentCategory category = AssignmentCategory();
        category.name = current.children[i].getAttribute('Type');
        category.weight = double.tryParse(
                (current.children[i].getAttribute('Weight') ?? '')
                    .replaceAll('%', '')) ??
            0.0;
        category.earnedPoints =
            double.tryParse(current.children[i].getAttribute('Points') ?? '') ??
                0.0;
        category.possiblePoints = double.tryParse(
                current.children[i].getAttribute('PointsPossible') ?? '') ??
            0.0;
        _class.assignmentCategories.add(category);
//          debugPrint('added category for class ${_class.className} : ${category}');
        // }
      }

      current = current.parent.findAllElements('Assignments').first;
      if (current == null) {
        classes.add(_class);
        continue;
      }

      _class.assignments = List<Assignment>();
      for (int i = 0; i < current.children.length; i++) {
        Assignment ass = Assignment();
        ass.assignmentName =
            current.children[i].getAttribute('Measure') ?? 'Assignment';
        ass.category =
            current.children[i].getAttribute('Type') ?? 'No Category';
        ass.date = current.children[i].getAttribute('DueDate') ?? '';
        ass.earnedPoints =
            current.children[i].getAttribute('Score') == 'Not Graded'
                ? -1
                : double.tryParse(
                        (current.children[i].getAttribute('Points') ?? 'N/A')
                            .replaceAll(' ', '')
                            .split('/')[0]) ??
                    -1;
        if (current.children[i].getAttribute('Score') == 'Not Graded') {
          ass.possiblePoints = double.tryParse(
              (current.children[i].getAttribute('Points') ?? '')
                  .replaceAll(' Points Possible', ''));
        } else {
//          ass.possiblePoints = double.tryParse(current.children[i].getAttribute('Score') ?? '') == null ? -1 : double.tryParse((current.children[i].getAttribute('Points') ?? 'N/A').replaceAll(' ', '').split('/').last) ?? -1;
          if (double.tryParse(
                  current.children[i].getAttribute('Score') ?? 'N/A') ==
              null) {
            List<String> pointsStr =
                (current.children[i].getAttribute('Points') ?? 'N/A')
                    .replaceAll(' ', '')
                    .split('/');
            if (pointsStr.length < 2) {
              ass.possiblePoints = -1;
            } else {
              double pp = double.tryParse(pointsStr[1]);
              ass.possiblePoints = pp ?? -1;
            }
          } else {
            ass.possiblePoints = double.tryParse(
                current.children[i].getAttribute('Score') ?? 'N/A');
          }
        }
        _class.assignments.add(ass);
      }

      classes.add(_class);
    }
    return classes;
  }

  Future<List<Messages>> getMessages() async {
    String resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
          <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
              <userID>$username</userID>
              <password>$password</password>
              <skipLoginLog>1</skipLoginLog>
              <parent>${studentAccount ? '0' : '1'}</parent>
              <webServiceHandleName>PXPWebServices</webServiceHandleName>
              <methodName>GetPXPMessages</methodName>
              ReportPeriod
              <paramStr>&lt;Parms&gt;&lt;ChildIntID&gt;0&lt;/ChildIntID&gt;&lt;/Parms&gt;</paramStr>
          </ProcessWebServiceRequest>
      </soap:Body>
    </soap:Envelope>''';

      _dio.options.headers['content-Type'] = 'text/xml';

      var res = await _dio.post(
        reqURL,
        data: requestData,
      );

      resData = res.data;
    } else {
      resData = MockResponses.GradebookResponse;
    }

    final document = XmlDocument.parse(HtmlUnescape().convert(resData));

    var messages = List<Messages>();

    var listings = document.findAllElements("MessageListings").first;
    for (int i = 0; i < listings.children.length; i++) {
      XmlNode current = listings.children[i];
      if (current.getAttribute("Subject") == null) continue;
      Messages _m = Messages();
      _m.id = current.getAttribute("ID");
      _m.startDate = current.getAttribute("BeginDate");
      _m.type = current.getAttribute("Type");
      _m.subject = current.getAttribute("Subject");
      _m.content = current.getAttribute("Content");
      messages.add(_m);
    }

    return messages;
  }

  Future<StudentGradeData> loadGradebook({Function(double) callback}) async {
    String resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
          <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
              <userID>$username</userID>
              <password>$password</password>
              <skipLoginLog>1</skipLoginLog>
              <parent>${studentAccount ? '0' : '1'}</parent>
              <webServiceHandleName>PXPWebServices</webServiceHandleName>
              <methodName>Gradebook</methodName>
              ReportPeriod
              <paramStr>&lt;Parms&gt;&lt;ChildIntID&gt;0&lt;/ChildIntID&gt;&lt;/Parms&gt;</paramStr>
          </ProcessWebServiceRequest>
      </soap:Body>
    </soap:Envelope>''';

      _dio.options.headers['content-Type'] = 'text/xml';

      var res = await _dio.post(reqURL, data: requestData,
          onSendProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5);
        }
      }, onReceiveProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5 + 0.5);
        }
      });

      resData = res.data;
    } else {
      resData = MockResponses.GradebookResponse;
    }

    final document = XmlDocument.parse(HtmlUnescape().convert(resData));
    // await Future.delayed(const Duration(milliseconds: 1500));
//    final document = XmlDocument.parse(testData);
    if (resData.contains('Invalid user id or password')) {
      return StudentGradeData()..error = 'Invalid user id or password';
    }
    if (resData.contains('The user name or password is incorrect')) {
      return StudentGradeData()
        ..error = 'The user name or password is incorrect';
    }
    // var currentMP = document.findAllElements('ReportingPeriod').first.getAttribute('GradePeriod');

    var svData = StudentGradeData();
    var periods = List<ReportPeriod>();

    var reportPeriods = document.findAllElements("ReportingPeriods").first;
    for (int i = 0; i < reportPeriods.children.length; i++) {
      XmlNode current = reportPeriods.children[i];
      if (current.getAttribute("GradePeriod") == null) continue;
      ReportPeriod _period = ReportPeriod();
      _period.index = current.getAttribute("Index");
      _period.name = current.getAttribute("GradePeriod");
      _period.startDate = current.getAttribute("StartDate");
      _period.endDate = current.getAttribute("EndDate");
      _period.classes = await addClasses(_period.index);
      periods.add(_period);
    }

    svData.periods = periods;
    svData.messages = await getMessages();

    return svData;
  }

  Future<StudentData> loadStudentData({Function(double) callback}) async {
    String resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
  <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
          <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
              <userID>$username</userID>
              <password>$password</password>
              <skipLoginLog>1</skipLoginLog>
              <parent>${studentAccount ? '0' : '1'}</parent>
              <webServiceHandleName>PXPWebServices</webServiceHandleName>
              <methodName>StudentInfo</methodName>
              <paramStr>&lt;Parms&gt;&lt;ChildIntID&gt;0&lt;/ChildIntID&gt;&lt;/Parms&gt;</paramStr>
          </ProcessWebServiceRequest>
      </soap:Body>
  </soap:Envelope>''';

      var headers = <String, List<String>>{
        'Content-Type': ['text/xml']
      };

      _dio.options.headers['content-Type'] = 'text/xml';

      var res = await _dio.post(reqURL, data: requestData,
          onSendProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5);
        }
      }, onReceiveProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5 + 0.5);
        }
      });
      resData = res.data;
    } else {
      resData = MockResponses.StudentInfoResponse;
    }

    final document = XmlDocument.parse(HtmlUnescape().convert(resData));

    // the StudentInfo element is inside four other dumb elements
    final el = document.root.firstElementChild.firstElementChild
        .firstElementChild.firstElementChild.firstElementChild;

    return StudentData(
      lockerInfo: el.getElement('LockerInfoRecords')?.innerText,
      formattedName: el.getElement('FormattedName')?.innerText,
      permId: el.getElement('PermID')?.innerText,
      gender: el.getElement('Gender')?.innerText,
      grade: el.getElement('Grade')?.innerText,
      address: el.getElement('Address')?.innerText,
      lastNameGoesBy: el.getElement('LastNameGoesBy')?.innerText,
      nickname: el.getElement('NickName')?.innerText,
      birthdate: el.getElement('BirthDate')?.innerText,
      email: el.getElement('EMail')?.innerText,
      phone: el.getElement('Phone')?.innerText,
      homeLanguage: el.getElement('HomeLanguage')?.innerText,
      currentSchool: el.getElement('CurrentSchool')?.innerText,
      homeroomTeacher: el.getElement('HomeRoomTch')?.innerText,
      homeroomTeacherEmail: el.getElement('HomeRoomTchEMail')?.innerText,
      homeroom: el.getElement('HomeRoom')?.innerText,
      counselorName: el.getElement('CounselorName')?.innerText,
      photo: el.getElement('Photo')?.innerText,
      physicianName: el.getElement('Physician')?.getAttribute('Name'),
      physicianPhone: el.getElement('Physician')?.getAttribute('Phone'),
      dentistName: el.getElement('Dentist')?.getAttribute('Name'),
      dentistPhone: el.getElement('Dentist')?.getAttribute('Phone'),
    );
  }

  static Future<List<ZipCodeResult>> loadDistrictsFromZip(String zip,
      {Function(double) callback, bool mock = false}) async {
    String resData;
    if (!mock) {
      var requestData = '''<?xml version="1.0" encoding="utf-8"?>
<v:Envelope xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:d="http://www.w3.org/2001/XMLSchema" xmlns:c="http://schemas.xmlsoap.org/soap/encoding/" xmlns:v="http://schemas.xmlsoap.org/soap/envelope/">
    <v:Header />
    <v:Body>
        <ProcessWebServiceRequestMultiWeb xmlns="http://edupoint.com/webservices/" id="o0" c:root="1">
            <userID i:type="d:string">EdupointDistrictInfo</userID>
            <password i:type="d:string">Edup01nt</password>
            <skipLoginLog i:type="d:string">false</skipLoginLog>
            <parent i:type="d:string">false</parent>
            <webServiceHandleName i:type="d:string">HDInfoServices</webServiceHandleName>
            <methodName i:type="d:string">GetMatchingDistrictList</methodName>
            <paramStr i:type="d:string">&lt;Parms&gt;&lt;Key&gt;5E4B7859-B805-474B-A833-FDB15D205D40&lt;/Key&gt;&lt;MatchToDistrictZipCode&gt;$zip&lt;/MatchToDistrictZipCode&gt;&lt;/Parms&gt;</paramStr>
            <webDBName i:type="d:string"></webDBName>
        </ProcessWebServiceRequestMultiWeb>
    </v:Body>
</v:Envelope>''';

      var headers = <String, List<String>>{
        'Content-Type': ['text/xml']
      };

      final _dio = Dio(BaseOptions(validateStatus: (_) => true));
      _dio.options.headers['content-Type'] = 'text/xml';
      var res = await _dio.post(
          'https://support.edupoint.com/Service/HDInfoCommunication.asmx',
          data: requestData, onSendProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5);
        }
      }, onReceiveProgress: (one, two) {
        if (callback != null) {
          callback((one / two) * 0.5 + 0.5);
        }
      });
      resData = res.data;
    } else {
      resData = MockResponses.ZipCodeResponse;
    }

    final document = XmlDocument.parse(HtmlUnescape().convert(resData));

    // print('${document.firstElementChild.firstElementChild.firstElementChild.firstElementChild.firstElementChild.firstElementChild.children[1].toString()}');

    return document.firstElementChild.firstElementChild.firstElementChild
        .firstElementChild.firstElementChild.firstElementChild.children
        .map((e) => ZipCodeResult(
            districtName: e.getAttribute('Name'),
            districtUrl: e.getAttribute('PvueURL')))
        .where((e) => e.districtUrl != null)
        .toList();
  }
}
