import 'package:flutter/material.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/services/services.dart';
import 'dart:convert';
import 'dart:typed_data';

class Avatar extends StatelessWidget {
  Avatar(
    this.user,
  );
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    String img = Provider.of<StudentVueProvider>(context).student.photo;
    if ((img == '') || (img == null)) {
      return LogoGraphicHeader();
    }
    return Hero(
      tag: 'User Avatar Image',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          radius: 70.0,
          child: ClipOval(
            child: Image.memory(
              base64Decode(img),
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
              gaplessPlayback: true,
            ),
          )),
    );
  }
}
