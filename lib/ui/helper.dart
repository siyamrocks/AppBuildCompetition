import 'package:flutter_starter/helpers/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/calendar.dart';
import 'package:flutter_starter/ui/todo.dart';
import 'package:flutter_starter/ui/components/segmented_selector.dart';

class Helper extends StatefulWidget {
  @override
  _HelperState createState() => _HelperState();
}

class _HelperState extends State<Helper> {
  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    selectedEvents = {};
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
  ];

  final List<Widget> _screens = [
    Expanded(child: Calendar()),
    Expanded(child: Todo())
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
