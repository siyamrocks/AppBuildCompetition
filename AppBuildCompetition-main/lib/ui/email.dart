/*
This file is the code for emailing an teacher.
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailSender extends StatefulWidget {
  final String email;
  EmailSender({
    Key key,
    @required this.email,
  }) : super(key: key);

  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<EmailSender> {
  // List of attachments
  List<String> attachments = [];

  // Text controller for recipient and subject.
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController(text: 'The subject');

  // Text controller for body.
  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  // Function to send the email.
  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: false,
    );

    String platformResponse;

    // Try to send the email, if error then inform the user using a snackbar.
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _recipientController.text = widget.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Teacher'),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Recipient input
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _recipientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recipient',
                ),
              ),
            ),
            // Subject input
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Subject',
                ),
              ),
            ),
            // Body input
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      labelText: 'Body', border: OutlineInputBorder()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
