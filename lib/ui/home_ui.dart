import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/ui/calendar.dart';
import 'package:flutter_starter/ui/menu.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  bool _loading = true;
  String _uid = '';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _loading = false;
        _uid = user.uid;
        _id = user.id;
        _name = user.name;
        _school = user.school;
        _email = user.email;
      });
    }

    _isUserAdmin();

    List<Widget> _widgetOptions = <Widget>[
      LoadingScreen(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Avatar(user),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FormVerticalSpace(),
                    Text(labels.home.uidLabel + ': ' + _id,
                        style: TextStyle(fontSize: 16)),
                    FormVerticalSpace(),
                    Text("School: " + _school, style: TextStyle(fontSize: 16)),
                    FormVerticalSpace(),
                    Text(labels.home.nameLabel + ': ' + _name,
                        style: TextStyle(fontSize: 16)),
                    FormVerticalSpace(),
                    Text(labels.home.emailLabel + ': ' + _email,
                        style: TextStyle(fontSize: 16)),
                    FormVerticalSpace(),
                    Text(labels.home.adminUserLabel + ': ' + _admin,
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
        inAsyncCall: _loading,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      Calendar(),
      Text(
        'Index 2: Schedule',
        style: optionStyle,
      ),
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
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings');
                }),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color(0xFFD4AF37)),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_rounded),
                label: 'Calendar',
                backgroundColor: Color(0xFF0B228C)),
            BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Schedule',
                backgroundColor: Color(0xFF057C05)),
            BottomNavigationBarItem(
                icon: Icon(Icons.email),
                label: 'Email',
                backgroundColor: Color(0xFFD4AF37)),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood),
                label: 'Lunch',
                backgroundColor: Color(0xFF0B228C))
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
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
