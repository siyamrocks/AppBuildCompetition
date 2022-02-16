/*
This is the code for updating a user's profile.
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/models/school_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/helpers/helpers.dart';
import 'package:flutter_starter/services/services.dart';

class UpdateProfileUI extends StatefulWidget {
  _UpdateProfileUIState createState() => _UpdateProfileUIState();
}

class _UpdateProfileUIState extends State<UpdateProfileUI> {
  // Create text controllers and keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _id = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  // List of schools to retrived using API
  Future<List<School>> _schools;
  String selectedSchool;

  // Fetch schools from API
  Future<List<School>> fetchSchool() async {
    var url = "https://gwinnett.nutrislice.com/menu/api/schools/?format=json";
    var result = await http.get(Uri.parse(url));

    // ignore: deprecated_member_use
    var list = List<School>();

    print(result.body);
    if (result.statusCode == 200) {
      var schools = json.decode(result.body);
      for (var school in schools) list.add(School.fromJson(school));
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    _schools = fetchSchool();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text(labels.auth.updateProfileTitle)),
        body: LoadingScreen(
          child: updateProfileForm(context),
          inAsyncCall: _loading,
          color: Theme.of(context).scaffoldBackgroundColor,
        ));
  }

  updateProfileForm(BuildContext context) {
    // Get user data and set variables.
    final UserModel user = Provider.of<UserModel>(context);
    _name.text = user?.name;
    _id.text = user?.id;
    selectedSchool = user?.school;
    final labels = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Avatar(user), // <- User's image
                SizedBox(height: 48.0),
                FutureBuilder<List<School>>(
                    future: _schools,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            // If waiting for data then show "loading."
                            child: Text("Loading schools..."),
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
                // Name input
                FormInputFieldWithIcon(
                  controller: _name,
                  iconPrefix: Icons.person,
                  labelText: labels.auth.nameFormField,
                  validator: Validator(labels).name,
                  onChanged: (value) => null,
                  onSaved: (value) => _name.text = value,
                ),
                FormVerticalSpace(),
                // ID input
                FormInputFieldWithIcon(
                  controller: _id,
                  iconPrefix: Icons.badge,
                  labelText: "ID",
                  onChanged: (value) => null,
                  onSaved: (value) => _id.text = value,
                ),
                FormVerticalSpace(),
                // Button to update profile
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // To hide the keyboard - if any.
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      // Create a new user model based on the new data
                      UserModel _updatedUser = UserModel(
                          uid: user?.uid,
                          id: _id.text,
                          name: _name.text,
                          email: user?.email,
                          school: selectedSchool);
                      // Ask for confirmation via password.
                      _updateUserConfirm(context, _updatedUser, user?.email);
                    }
                  },
                  child: Text(labels.auth.updateUser),
                ),
                FormVerticalSpace(),
                // Button to update password.
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.amber)),
                    child: Text(labels.auth.changePasswordLabelButton),

                    // Go to reset password screen
                    onPressed: () => Navigator.pushNamed(
                        context, '/reset-password',
                        arguments: user.email)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _updateUserConfirm(
      BuildContext context, UserModel updatedUser, String oldEmail) async {
    final labels = AppLocalizations.of(context);
    AuthService _auth = AuthService();
    final TextEditingController _password =
        new TextEditingController(); // Password text controller
    return showDialog(
        context: context,
        builder: (context) {
          // Create a alert dialog.
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Text(
              labels.auth.enterPassword,
            ),
            // Password input
            content: FormInputFieldWithIcon(
              controller: _password,
              iconPrefix: Icons.lock,
              labelText: labels.auth.passwordFormField,
              validator: Validator(labels).password,
              obscureText: true,
              onChanged: (value) => null,
              onSaved: (value) => _password.text = value,
              maxLines: 1,
            ),
            // Create actions
            actions: <Widget>[
              new TextButton(
                child: new Text(labels.auth.cancel.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _loading = false;
                  });
                },
              ),
              // Sumbit button
              new ElevatedButton(
                child: new Text(labels.auth.submit.toUpperCase()),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber)),
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  Navigator.of(context).pop();
                  // Try to update user account.
                  try {
                    await _auth
                        .updateUser(updatedUser, oldEmail, _password.text)
                        .then((result) {
                      setState(() {
                        _loading = false;
                      });

                      // On success, show user via a snackbar.
                      if (result == true) {
                        final snackBar = SnackBar(
                          content: Text(labels.auth.updateUserSuccessNotice),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  } on PlatformException catch (error) {
                    // If error then show the user.
                    print(error.code);
                    String authError;
                    switch (error.code) {
                      case 'ERROR_WRONG_PASSWORD':
                        authError = labels.auth.wrongPasswordNotice;
                        break;
                      default:
                        authError = labels.auth.unknownError;
                        break;
                    }
                    final snackBar = SnackBar(
                      content: Text(authError),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _loading = false;
                    });
                  }
                },
              )
            ],
          );
        });
  }
}
