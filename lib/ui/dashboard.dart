import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

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
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _id = user.id;
        _name = user.name;
        _school = user.school;
        _email = user.email;
      });
    }

    // Correct school name
    setState(() {
      _school = toBeginningOfSentenceCase(_school.replaceAll("-", " "));
    });

    return Container(
        child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            id(),
            SizedBox(height: 10),
            Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Avatar(user),
                    const SizedBox(height: 12),
                    Icon(Icons.card_giftcard),
                    Text("Student ID" + ': ' + _id,
                        style: TextStyle(fontSize: 16)),
                    FormVerticalSpace(),
                    Icon(Icons.school),
                    Text("School: " + _school, style: TextStyle(fontSize: 16)),
                    FormVerticalSpace(),
                    Icon(Icons.account_balance),
                    Text(labels.home.nameLabel + ': ' + _name,
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
