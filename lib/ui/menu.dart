import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/models/food_model.dart';
import 'package:flutter_starter/models/user_model.dart';
import 'package:flutter_starter/services/services.dart';
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
      return Text(
        "No image",
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }
  }
}

class _MenuState extends State<Menu> {
  Future<Food> _menu;
  String school;
  String dropdownValue = "Breakfast";
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _menu = fetchMenu(
        "grayson-high", dropdownValue.toLowerCase(), convertDate(currentDate));
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
          school, dropdownValue.toLowerCase(), convertDate(currentDate));
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
              RaisedButton(
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
                Text(convertDate(currentDate)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          _menu = fetchMenu(school, dropdownValue.toLowerCase(),
                              convertDate(currentDate));
                        });
                      },
                      items: <String>['Breakfast', 'Lunch']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => selectDate(context),
                    child: Text('Select date'),
                  )
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
