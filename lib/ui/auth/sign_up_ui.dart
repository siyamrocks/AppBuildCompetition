import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/store/store.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/helpers/helpers.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/school_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignUpUI extends StatefulWidget {
  _SignUpUIState createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _id = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<School>> _schools;
  String selectedSchool;

  @override
  void initState() {
    super.initState();
    _schools = fetchSchool();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<List<School>> fetchSchool() async {
    var url = "https://gwinnett.nutrislice.com/menu/api/schools/?format=json";
    var result = await http.get(Uri.parse(url));

    var list = List<School>();

    print(result.body);
    if (result.statusCode == 200) {
      var schools = json.decode(result.body);
      for (var school in schools) list.add(School.fromJson(school));
    }

    return list;
  }

  Widget build(BuildContext context) {
    // shared pref object
    SharedPreferenceHelper _sharedPrefsHelper =
        Provider.of<StudentVueProvider>(context).sharedPrefsHelper;

    final labels = AppLocalizations.of(context);
    bool _loading = false;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: LoadingScreen(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LogoGraphicHeader(),
                    Text(
                      "Use your eClass password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 48.0),
                    FutureBuilder<List<School>>(
                        future: _schools,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                child: Text("Loading Schools..."),
                              ),
                            );
                          } else {
                            return DropdownButton<String>(
                                hint: Text("Select your school"),
                                value: selectedSchool,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedSchool = newValue;
                                  });
                                },
                                items: snapshot.data
                                    .map((s) => DropdownMenuItem<String>(
                                          child: Text(s.name),
                                          value: s.slug,
                                        ))
                                    .toList());
                          }
                        }),
                    FormVerticalSpace(),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 3),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 70,
                              color: Colors.grey.shade900)
                        ],
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _id,
                        onChanged: (value) => null,
                        onSaved: (value) => _id.text = value,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        cursorColor: Colors.orange,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.credit_card,
                              color: Colors.amberAccent,
                            ),
                            hintText: "Student ID",
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 3),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 70,
                              color: Colors.grey.shade900)
                        ],
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _name,
                        validator: Validator(labels).name,
                        onChanged: (value) => null,
                        onSaved: (value) => _name.text = value,
                        cursorColor: Colors.orange,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: Colors.amberAccent,
                            ),
                            hintText: labels.auth.nameFormField,
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 3),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 70,
                              color: Colors.grey.shade900)
                        ],
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _password,
                        cursorColor: Colors.orange,
                        validator: Validator(labels).password,
                        obscureText: true,
                        maxLines: 1,
                        onChanged: (value) => null,
                        onSaved: (value) => _password.text = value,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.amberAccent,
                            ),
                            hintText: labels.auth.passwordFormField,
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    FormVerticalSpace(),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          SystemChannels.textInput.invokeMethod(
                              'TextInput.hide'); //to hide the keyboard - if any
                          // Save password for StudentVUE login.
                          _sharedPrefsHelper.setPassword(_password.text);
                          AuthService _auth = AuthService();
                          bool _isRegisterSucccess =
                              await _auth.registerWithEmailAndPassword(
                                  _name.text,
                                  _id.text,
                                  _password.text,
                                  _id.text,
                                  selectedSchool);

                          if (_isRegisterSucccess == false) {
                            final snackBar = SnackBar(
                              content: Text(labels.auth.signUpError),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                        alignment: Alignment.center,
                        height: 54,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber, width: 2),
                          gradient: LinearGradient(
                              colors: [
                                (new Color(0xDD000000)),
                                (new Color(0xFF263238))
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 50,
                              color: Colors.grey.shade800,
                            )
                          ],
                        ),
                        child: Text(
                          labels.auth.signUpButton,
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ),
                    FormVerticalSpace(),
                    LabelButton(
                      labelText: labels.auth.signInLabelButton,
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        inAsyncCall: _loading,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
