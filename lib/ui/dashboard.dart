import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/ui/calendar.dart';
import 'package:flutter_starter/ui/menu.dart';
import 'package:flutter_starter/ui/classes.dart';
import 'package:barcode_widget/barcode_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

/*
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
*/

class _DashboardState extends State<Dashboard> {
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

  static const buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _id = user.id;
        _name = user.name;
        _school = user.school;
        _email = user.email;
      });
    }
    return Container(
        child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            id(),
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
    ));
  }

  Container id() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BarcodeWidget(data: _id, barcode: Barcode.code128()),
            ),
          ),
        ],
      ),
    );
  }
}
