import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }
}

Widget initWidget(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("assets/SSB_Logo.png"),
                    height: 336,
                    width: 336,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber, width: 3),
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 70,
                    color: Colors.grey.shade900)
              ],
            ),
            alignment: Alignment.center,
            child: TextField(
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.chrome_reader_mode,
                    color: Colors.amberAccent,
                  ),
                  hintText: "Enter Student ID",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 15),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber, width: 3),
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 70,
                    color: Colors.grey.shade900)
              ],
            ),
            alignment: Alignment.center,
            child: TextField(
              obscureText: true,
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.amberAccent,
                  ),
                  hintText: "Enter Password",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 17),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: Text("Forgot Password?"),
              onTap: () => {},
            ),
          ),
          GestureDetector(
            onTap: () => {},
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 25),
              alignment: Alignment.center,
              height: 54,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 2),
                gradient: LinearGradient(
                    colors: [(new Color(0xDD000000)), (new Color(0xFF263238))],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.grey.shade800,
                  )
                ],
              ),
              child: Text(
                "LOGIN",
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                GestureDetector(
                  onTap: () {},
                  child: Text("Register Now",
                      style: TextStyle(color: Colors.amber)),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
