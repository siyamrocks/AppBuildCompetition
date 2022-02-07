/*
This is the file for the Settings UI.
*/

import 'package:flutter/material.dart';
import 'package:flutter_starter/store/store.dart';
import 'package:flutter_starter/ui/components/segmented_selector.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/constants/constants.dart';

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(labels.settings.title)),
      body: _buildLayoutSection(context),
    );
  }

  // Build settings screen.
  Widget _buildLayoutSection(BuildContext context) {
    // Shared preference helper
    SharedPreferenceHelper _sharedPrefsHelper =
        Provider.of<StudentVueProvider>(context).sharedPrefsHelper;

    final labels = AppLocalizations.of(context);

    // Theme options
    final List<MenuOptionsModel> themeOptions = [
      MenuOptionsModel(
          key: "system",
          value: labels.settings.system,
          icon: Icons.brightness_4),
      MenuOptionsModel(
          key: "light",
          value: labels.settings.light,
          icon: Icons.brightness_low),
      MenuOptionsModel(
          key: "dark", value: labels.settings.dark, icon: Icons.brightness_3)
    ];

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        // Theme options
        Text(
          "Theme",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.amber,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SegmentedSelector(
            selectedOption: Provider.of<ThemeProvider>(context).getTheme,
            menuOptions: themeOptions,
            onValueChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .updateTheme(value);
            },
          ),
        ),
        Text(
          "System",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.amber,
          ),
        ),
        Card(
          elevation: 4.0,
          child: Column(
            children: <Widget>[
              // Language picker
              ListTile(
                leading: Icon(Icons.translate),
                title: Text(
                  labels.settings.language,
                  style: TextStyle(fontSize: 15),
                ),
                trailing: Container(
                  child: DropdownPicker(
                    menuOptions: Globals.languageOptions,
                    onChanged: (value) {
                      Provider.of<LanguageProvider>(context, listen: false)
                          .updateLanguage(value);
                    },
                  ),
                ),
              ),
              // Update profile button
              // ListTile(
              //   leading: Icon(Icons.person),
              //   title: Text(labels.settings.updateProfile),
              //   trailing: Container(
              //     width: 100,
              //     child: ElevatedButton(
              //       onPressed: () async {
              //         Navigator.of(context).pushNamed('/update-profile');
              //       },
              //       style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all<Color>(Colors.amber)),
              //       child: Text(
              //         labels.settings.updateProfile,
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ),
              // ),
              // Report bug button
              ListTile(
                leading: Icon(Icons.bug_report),
                title: Text("Report Bug"),
                trailing: Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamed('/bug-report');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.amber)),
                    child: Text(
                      "Report Bug",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // View license info
              ListTile(
                leading: Icon(Icons.settings_applications),
                title: Text("License"),
                trailing: Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      showLicensePage(context: context);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.amber)),
                    child: Text(
                      "License",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Sign out
              ListTile(
                leading: Icon(Icons.switch_account),
                title: Text(labels.settings.signOut),
                trailing: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<StudentVueProvider>(context, listen: false)
                          .resetData();
                      _sharedPrefsHelper.setPassword("");
                      AuthService _auth = AuthService();
                      _auth.signOut();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.amber)),
                    child: Text(
                      labels.settings.signOut,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
        ),
      ],
    );
  }
}
