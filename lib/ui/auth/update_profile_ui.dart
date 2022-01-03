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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _id = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  Future<List<School>> _schools;
  String selectedSchool;

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

  @override
  void initState() {
    super.initState();
    _schools = fetchSchool();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
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
    final UserModel user = Provider.of<UserModel>(context);
    _name.text = user?.name;
    _email.text = user?.email;
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
                LogoGraphicHeader(),
                SizedBox(height: 48.0),
                FutureBuilder<List<School>>(
                    future: _schools,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
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
                  controller: _name,
                  iconPrefix: Icons.person,
                  labelText: labels.auth.nameFormField,
                  validator: Validator(labels).name,
                  onChanged: (value) => null,
                  onSaved: (value) => _name.text = value,
                ),
                FormVerticalSpace(),
                FormInputFieldWithIcon(
                  controller: _id,
                  iconPrefix: Icons.badge,
                  labelText: "ID",
                  onChanged: (value) => null,
                  onSaved: (value) => _id.text = value,
                ),
                FormVerticalSpace(),
                FormInputFieldWithIcon(
                  controller: _email,
                  iconPrefix: Icons.email,
                  labelText: labels.auth.emailFormField,
                  validator: Validator(labels).email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => null,
                  onSaved: (value) => _email.text = value,
                ),
                FormVerticalSpace(),
                PrimaryButton(
                    labelText: labels.auth.updateUser,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        UserModel _updatedUser = UserModel(
                            uid: user?.uid,
                            id: _id.text,
                            name: _name.text,
                            email: _email.text,
                            school: selectedSchool,
                            studentvue: user?.studentvue);
                        _updateUserConfirm(context, _updatedUser, user?.email);
                      }
                    }),
                FormVerticalSpace(),
                LabelButton(
                    labelText: labels.auth.changePasswordLabelButton,
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
    final TextEditingController _password = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Text(
              labels.auth.enterPassword,
            ),
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
              new TextButton(
                child: new Text(labels.auth.submit.toUpperCase()),
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  Navigator.of(context).pop();
                  try {
                    await _auth
                        .updateUser(updatedUser, oldEmail, _password.text)
                        .then((result) {
                      setState(() {
                        _loading = false;
                      });

                      if (result == true) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(labels.auth.updateUserSuccessNotice),
                          ),
                        );
                      }
                    });
                  } on PlatformException catch (error) {
                    //List<String> errors = error.toString().split(',');
                    // print("Error: " + errors[1]);
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
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(authError),
                    ));
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
