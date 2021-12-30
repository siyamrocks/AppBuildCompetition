import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/helper.dart';
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
      Helper(),
      Classes(),
      Chat(),
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
        bottomNavigationBar: CurvedNavigationBar(
            index: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            color: Colors.brown,
            buttonBackgroundColor: Colors.black,
            height: 50,
            items: <Widget>[
              Icon(Icons.home),
              Icon(Icons.calendar_today_rounded),
              Icon(Icons.school),
              Icon(Icons.email),
              Icon(Icons.fastfood)
            ],
            animationDuration: Duration(milliseconds: 200),
            animationCurve: Curves.bounceInOut),
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
