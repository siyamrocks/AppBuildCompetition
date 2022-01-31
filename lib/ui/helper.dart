import 'package:flutter/material.dart';
import 'package:flutter_starter/ui/clubs.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/calendar.dart';
import 'package:flutter_starter/ui/todo.dart';
import 'package:flutter_starter/ui/social.dart';
import 'package:flutter_starter/ui/components/segmented_selector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Helper extends StatefulWidget {
  @override
  _HelperState createState() => _HelperState();
}

class _HelperState extends State<Helper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String currentOption = "0";

  final List<MenuOptionsModel> options = [
    MenuOptionsModel(key: "0", value: "Events", icon: Icons.event),
    MenuOptionsModel(key: "1", value: "Todo", icon: Icons.list_alt_rounded),
    MenuOptionsModel(key: "2", value: "Clubs", icon: Icons.schedule),
    MenuOptionsModel(key: "3", value: "Social", icon: Icons.info),
  ];

  final List<Widget> _screens = [
    Expanded(child: Calendar()),
    Expanded(child: Todo()),
    Expanded(child: Clubs()),
    Expanded(child: Social()),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SegmentedSelector(
              selectedOption: currentOption,
              menuOptions: options,
              onValueChanged: (value) {
                setState(() {
                  currentOption = value;
                });
              },
            ),
          ),
        ),
        _screens[int.parse(currentOption)]
      ],
    );
  }
}
