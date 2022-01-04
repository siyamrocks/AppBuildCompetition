import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/helpers/helpers.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/school_model.dart';
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
    final labels = AppLocalizations.of(context);
    bool _loading = false;

    return Scaffold(
      key: _scaffoldKey,
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
                    Text("USE YOUR ECLASS PASSWORD"),
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
                                hint: Text("Select"),
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
                    FormInputFieldWithIcon(
                      controller: _id,
                      iconPrefix: Icons.credit_card,
                      labelText: "Student ID",
                      // validator: Validator(labels).name,
                      onChanged: (value) => null,
                      onSaved: (value) => _id.text = value,
                    ),
                    FormVerticalSpace(),
                    FormInputFieldWithIcon(
                      controller: _name,
                      iconPrefix: Icons.person,
                      labelText: labels.auth.nameFormField,
                      validator: Validator(labels).name,
                      onChanged: (value) => null,
                      onSaved: (value) => _name.text = value,
                    ),
                    FormVerticalSpace(),
                    FormInputFieldWithIcon(
                      controller: _password,
                      iconPrefix: Icons.lock,
                      labelText: labels.auth.passwordFormField,
                      validator: Validator(labels).password,
                      obscureText: true,
                      maxLines: 1,
                      onChanged: (value) => null,
                      onSaved: (value) => _password.text = value,
                    ),
                    FormVerticalSpace(),
                    PrimaryButton(
                        labelText: labels.auth.signUpButton,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            SystemChannels.textInput.invokeMethod(
                                'TextInput.hide'); //to hide the keyboard - if any
                            AuthService _auth = AuthService();
                            bool _isRegisterSucccess =
                                await _auth.registerWithEmailAndPassword(
                                    _name.text,
                                    _id.text,
                                    _password.text,
                                    _id.text,
                                    selectedSchool,
                                    _password.text);

                            if (_isRegisterSucccess == false) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(labels.auth.signUpError),
                              ));
                            }
                          }
                        }),
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
