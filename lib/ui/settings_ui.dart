import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(
        title: Text(labels.settings.title),
      ),
      body: _buildLayoutSection(context),
    );
  }

  Widget _buildLayoutSection(BuildContext context) {
    final labels = AppLocalizations.of(context);
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
      children: <Widget>[
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
        ListTile(
          title: Text(labels.settings.language),
          //trailing: _languageDropdown(context),
          trailing: Container(
            width: 100,
            height: 50.0,
            child: DropdownPicker(
              menuOptions: Globals.languageOptions,
              selectedOption:
                  Provider.of<LanguageProvider>(context).currentLanguage,
              onChanged: (value) {
                Provider.of<LanguageProvider>(context, listen: false)
                    .updateLanguage(value);
              },
            ),
          ),
        ),
        ListTile(
            title: Text(labels.settings.updateProfile),
            trailing: Container(
              width: 150,
              height: 50.0,
              child: RaisedButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed('/update-profile');
                },
                child: Text(
                  labels.settings.updateProfile,
                ),
              ),
            )),
        ListTile(
            title: Text(labels.settings.signOut),
            trailing: Container(
              width: 150,
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  AuthService _auth = AuthService();
                  _auth.signOut();
                  //Navigator.pushReplacementNamed(context, '/signin');
                },
                child: Text(
                  labels.settings.signOut,
                ),
              ),
            ))
      ],
    );
  }
}
