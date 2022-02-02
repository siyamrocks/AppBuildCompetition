/*
This is the code for the sign up UI.
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/store/store.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/school_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignUpUI extends StatefulWidget {
  _SignUpUIState createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  // Create text controllers and keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _id = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of schools to retrived using API
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

  // Fetch schools from API
  Future<List<School>> fetchSchool() async {
    var url = "https://gwinnett.nutrislice.com/menu/api/schools/?format=json";
    var result = await http.get(Uri.parse(url));

    // ignore: deprecated_member_use
    var list = List<School>();

    if (result.statusCode == 200) {
      var schools = json.decode(result.body);
      // For each school add it to the list.
      for (var school in schools) list.add(School.fromJson(school));
    }

    return list;
  }

  Widget build(BuildContext context) {
    // Shared preference helper
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
                    // Logo on top center
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Image.asset("assets/SSB_Logo.png"),
                      ),
                      height: 128,
                      width: 128,
                    ),
                    // Text to inform user
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Use your eClass password",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Create a dropdown based on the school list
                    FutureBuilder<List<School>>(
                        future: _schools,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                // If waiting for data then show "loading."
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
                                // For each item in the list return a dropdown item
                                items: snapshot.data
                                    .map((s) => DropdownMenuItem<String>(
                                          child: Text(s.name),
                                          value: s.slug,
                                        ))
                                    .toList());
                          }
                        }),
                    FormVerticalSpace(),
                    // Student ID input
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
                    // Name input
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
                    // Password input
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
                    // Sign up button action
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          // To hide the keyboard - if any.
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          if (selectedSchool != null) {
                            // Cache password for StudentVUE login.
                            _sharedPrefsHelper.setPassword(_password.text);
                            AuthService _auth = AuthService();
                            // Sign up using Firebase
                            bool _isRegisterSucccess =
                                await _auth.registerWithEmailAndPassword(
                                    _name.text,
                                    _id.text,
                                    _password.text,
                                    _id.text,
                                    selectedSchool);

                            // If an error show it to the user using a snackbar.
                            if (_isRegisterSucccess == false) {
                              final snackBar = SnackBar(
                                content: Text(labels.auth.signUpError),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else if (selectedSchool == null) {
                            // If the user did not pick a school then tell them using a snackbar.
                            final snackBar = SnackBar(
                              content: Text("Please select a school."),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      // Sign up button UI
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
                    // Button to go back.
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
