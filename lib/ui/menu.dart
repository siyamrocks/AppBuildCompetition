import 'dart:convert';
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
  Future<Food> _menu;
  String school;
  String currentOption = "Breakfast";
  DateTime currentDate = DateTime.now();

  final List<MenuOptionsModel> options = [
    MenuOptionsModel(
        key: "Breakfast", value: "Breakfast", icon: Icons.free_breakfast),
    MenuOptionsModel(key: "Lunch", value: "Lunch", icon: Icons.dining_rounded),
  ];

  @override
  void initState() {
    super.initState();
  }

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

  Future<void> selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
      _menu = fetchMenu(
          school, currentOption.toLowerCase(), convertDate(currentDate));
    }
  }

  String convertDate(DateTime date) {
    String year, month, day;
    year = date.year.toString();
    month = date.month.toString();
    day = date.day.toString();
    return "$year/$month/$day";
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        school = user.school;
      });
      _menu = fetchMenu(
          school, currentOption.toLowerCase(), convertDate(currentDate));
    }
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
      return FutureBuilder<Food>(
        future: _menu,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 5),
                Text(new DateFormat("E MMM d, y").format(currentDate)),
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
                  IconButton(
                      onPressed: () => selectDate(context),
                      icon: Icon(Icons.date_range))
                ]),
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
