import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/calendar.dart';
import 'package:flutter_starter/ui/menu.dart';
import 'package:flutter_starter/ui/dashboard.dart';
import 'package:flutter_starter/ui/classes.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  bool _loading = true;
  String _id = '';
  String _name = '';
  String _email = '';
  String _school = '';
  String _admin = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _loading = false;
        _id = user.id;
        _name = user.name;
        _school = user.school;
        _email = user.email;
      });
    }

    _isUserAdmin();

    Provider.of<StudentVueProvider>(context).initData(user.id, user.studentvue);

    List<Widget> _widgetOptions = <Widget>[
      Dashboard(),
      Calendar(),
      Classes(),
      Text(
        'Index 3: Email',
        style: optionStyle,
      ),
      Menu()
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(labels.home.title),
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
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: 'Home',
        //         backgroundColor: Color(0xFFD4AF37)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.calendar_today_rounded),
        //         label: 'Calendar',
        //         backgroundColor: Color(0xFF0B228C)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.school),
        //         label: 'Schedule',
        //         backgroundColor: Color(0xFF057C05)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.email),
        //         label: 'Email',
        //         backgroundColor: Color(0xFFD4AF37)),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.fastfood),
        //         label: 'Lunch',
        //         backgroundColor: Color(0xFF0B228C))
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.white,
        //   onTap: _onItemTapped,
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          elevation: 0.0,
          items: [
            Icons.home,
            Icons.calendar_today_rounded,
            Icons.school,
            Icons.email,
            Icons.fastfood
          ]
              .asMap()
              .map((key, value) => MapEntry(
                    key,
                    BottomNavigationBarItem(
                      title: Text(""),
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedIndex == key
                              ? Colors.blue[600]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Icon(value),
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
        body: _widgetOptions.elementAt(_selectedIndex));
  }

  _isUserAdmin() async {
    bool _isAdmin = await AuthService().isAdmin();
    //handle setState bug  //https://stackoverflow.com/questions/49340116/setstate-called-after-dispose
    if (mounted) {
      setState(() {
        _admin = _isAdmin.toString();
      });
    }
  }
}
