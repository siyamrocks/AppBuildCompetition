/*
This is the file that shows the user's breakfeast/lunch menu for their school.
*/

import 'dart:convert';
import 'package:flutter_starter/constants/schools.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/components/segmented_selector.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/models/food_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

// Widget to show food image.
class FoodImage extends StatelessWidget {
  final String img;

  const FoodImage({Key key, @required this.img}) : super(key: key);

  Widget build(BuildContext context) {
    if (img != "null") {
      return Image.network(img);
    } else {
      return Row(
        children: [
          Icon(Icons.fastfood),
          SizedBox(width: 10),
          Text(
            "No image",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      );
    }
  }
}

class _MenuState extends State<Menu> {
  Future<Food> _menu; // List of food in menu (lunch / breakfast)
  String school; // Variable to hold user's school.
  String currentOption = "Breakfast"; // Current menu option.
  DateTime currentDate = DateTime.now(); // Current date.

  // List of menu options.
  final List<MenuOptionsModel> options = [
    MenuOptionsModel(
        key: "Breakfast", value: "Breakfast", icon: Icons.free_breakfast),
    MenuOptionsModel(key: "Lunch", value: "Lunch", icon: Icons.dining_rounded),
  ];

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch menu based on school, type, and date.
  Future<Food> fetchMenu(String school, String type, String date) async {
    var url =
        "https://gwinnett.nutrislice.com/menu/api/digest/school/$school/menu-type/$type/date/$date";
    var result = await http.get(Uri.parse(url));

    var items = Food();

    if (result.statusCode == 200) {
      var menu = json.decode(result.body);
      items = Food.fromJson(menu);
    }
    return items;
  }

  // Function to allow user to pick any date.
  Future<void> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate; // Set picked date to current date variable.
      });
      // Set menu to result of new date.
      _menu = fetchMenu(
          school, currentOption.toLowerCase(), convertDate(currentDate));
    }
  }

  // Function to convert date for API.
  String convertDate(DateTime date) {
    String year, month, day;
    year = date.year.toString();
    month = date.month.toString();
    day = date.day.toString();
    return "$year/$month/$day";
  }

  @override
  Widget build(BuildContext context) {
    // Get the school from the user data.
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        school = user.school;
      });
      // Set the lunch menu based on the user's school.
      _menu = fetchMenu(
          school, currentOption.toLowerCase(), convertDate(currentDate));
    }
    // If it's a weekend then tell the user there is no school.
    if (currentDate.weekday == DateTime.saturday ||
        currentDate.weekday == DateTime.sunday) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("No school."),
              ElevatedButton(
                onPressed: () => selectDate(context),
                child: Text('Select date'),
              )
            ],
          ),
        ),
      );
    } else {
      // Show list of food from menu variable.
      return FutureBuilder<Food>(
        future: _menu,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            // If waiting for data then show the user.
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 5),
                // Show the user's school and date.
                Text(new DateFormat("E MMM d").format(currentDate) +
                    " at " +
                    SchoolData.convertToTitleCase(school)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SegmentedSelector(
                    selectedOption: currentOption,
                    menuOptions: options,
                    onValueChanged: (value) {
                      setState(() {
                        currentOption = value;
                      });
                    },
                  ),
                  // Button to pick a custom date.
                  IconButton(
                      onPressed: () => selectDate(context),
                      icon: Icon(Icons.date_range))
                ]),
                // List of items.
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data.menuItems[index],
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              FoodImage(
                                  img: snapshot.data.images[index].toString())
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.menuItems.length,
                  ),
                ),
              ],
            );
          }
        },
      );
    }
  }
}
