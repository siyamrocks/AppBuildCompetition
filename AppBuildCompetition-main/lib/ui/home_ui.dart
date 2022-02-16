/*
This is UI code for the homepage which contains the navbar.
*/

import 'package:flutter/material.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/store/store.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/events.dart';
import 'package:flutter_starter/ui/menu.dart';
import 'package:flutter_starter/ui/dashboard.dart';
import 'package:flutter_starter/ui/classes.dart';
import 'package:flutter_starter/ui/chat.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // Variables to hold user info.
  String _id = '';
  String _pass = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Selected screen (navbar)
  int _selectedIndex = 0;

  Widget build(BuildContext context) {
    // Shared preference helper
    SharedPreferenceHelper _sharedPrefsHelper =
        Provider.of<StudentVueProvider>(context).sharedPrefsHelper;

    // Get user data and set the ID.
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _id = user.id;
      });
    }

    // Get cached password (local)
    _sharedPrefsHelper.getPassword.then((value) {
      _pass = value;
    });

    if (user.id == "20221234") {
      // If the user is the test account then use mock data.
      Provider.of<StudentVueProvider>(context).initData(_id, _pass, true);
    } else {
      // Login and set data using user ID.
      Provider.of<StudentVueProvider>(context).initData(_id, _pass, false);
    }

    final labels = AppLocalizations.of(context);

    // List of screens
    List<Widget> _widgetOptions = <Widget>[
      Dashboard(),
      Helper(),
      Classes(),
      Chat(),
      Menu()
    ];

    // List of respective screen names
    List<String> pages = <String>[
      labels.home.dashboard,
      labels.home.events,
      labels.home.classes,
      labels.home.emailLabel,
      labels.home.menu
    ];

    return Scaffold(
        // App Bar
        appBar: AppBar(
          // Set appbar title based on current screen
          title: Text(pages[_selectedIndex]),
          // Create settings action
          actions: [
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings');
                }),
          ],
        ),
        // Create bottom navigation bar
        bottomNavigationBar: CurvedNavigationBar(
            index: _selectedIndex, // Use variable for index
            onTap: (index) =>
                setState(() => _selectedIndex = index), // Update index variable
            height: 75,
            backgroundColor: Colors.amber,
            buttonBackgroundColor: Colors.grey[900],
            color: Colors.black,
            // Create navbar items with icons
            items: <Widget>[
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
              ),
              Icon(
                Icons.school,
                color: Colors.white,
              ),
              Icon(
                Icons.email,
                color: Colors.white,
              ),
              Icon(
                Icons.fastfood,
                color: Colors.white,
              )
            ],
            animationDuration: Duration(milliseconds: 200),
            animationCurve: Curves.bounceInOut),
        body: _widgetOptions.elementAt(_selectedIndex));
  }
}
