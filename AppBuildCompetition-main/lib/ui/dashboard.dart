/*
This file is the home screen pages such shows the user's ID and basic details.
*/

import 'package:flutter/material.dart';
import 'package:flutter_starter/constants/schools.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:barcode_widget/barcode_widget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // User's data variables
  String _id = '';
  String _name = '';
  String _school = '';
  bool _admin = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);
    // Get the user data and set the variables.
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _id = user.id;
        _name = user.name;
        _school = user.school;
      });
    }

    // Convert school name into title case (grayson-high -> Grayson High)
    setState(() {
      if (_school != null) _school = SchoolData.convertToTitleCase(_school);
    });

    // Check if the user is an admin (not used)
    _isUserAdmin();
    if (_admin) print("User is admin.");

    return Container(
        child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            id(), // <- Show ID Card
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Avatar(user), // <- User's image
                  const SizedBox(height: 12),
                  Icon(Icons.badge),
                  Text("Student ID" + ': ' + _id,
                      style: TextStyle(fontSize: 16, color: Colors.amber)),
                  FormVerticalSpace(),
                  Icon(Icons.school),
                  Text("School: " + _school,
                      style: TextStyle(fontSize: 16, color: Colors.amber)),
                  FormVerticalSpace(),
                  Icon(Icons.account_balance),
                  Text(labels.home.nameLabel + ': ' + _name,
                      style: TextStyle(fontSize: 16, color: Colors.amber)),
                  // Container(child: _admin ? Text("You are an admin!") : Container()),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Widget for ID Card
  Container id() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 150,
            width: 300,
            child: Card(
              color: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BarcodeWidget(
                  data: _id,
                  barcode: Barcode.code128(),
                  backgroundColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Check if the user is an admin.
  _isUserAdmin() async {
    bool _isAdmin = await AuthService().isAdmin();
    if (mounted) {
      setState(() {
        _admin = _isAdmin;
      });
    }
  }
}
