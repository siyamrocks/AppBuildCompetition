import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_starter/models/food_model.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<Food> _menu;

  @override
  void initState() {
    super.initState();
    _menu = fetchMenu("grayson-high", "breakfast", "2021/10/15");
  }

  Future<Food> fetchMenu(String school, String type, String date) async {
    var url =
        "https://gwinnett.nutrislice.com/menu/api/digest/school/$school/menu-type/$type/date/$date";
    var result = await http.get(url);

    var items = Food();

    if (result.statusCode == 200) {
      var menu = json.decode(result.body);
      items = Food.fromJson(menu);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
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
          return ListView.builder(
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
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Image.network(snapshot.data.images[index].toString())
                    ],
                  ),
                ),
              );
            },
            itemCount: snapshot.data.menuItems.length,
          );
        }
      },
    );
  }
}
