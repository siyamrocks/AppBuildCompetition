import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/localizations.dart';
import 'package:flutter_starter/ui/components/components.dart';
import 'package:flutter_starter/helpers/helpers.dart';
import 'package:flutter_starter/services/services.dart';
import 'package:provider/provider.dart';

class SignInUI extends StatefulWidget {
  _SignInUIState createState() => _SignInUIState();
}

class _SignInUIState extends State<SignInUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _id = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Image.asset("assets/SSB_Logo.png"),
                      ),
                      height: 256,
                      width: 256,
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
                controller: _id,
                cursorColor: Colors.orange,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.badge,
                      color: Colors.amberAccent,
                    ),
                    hintText: "Enter Student ID",
                    hintStyle: TextStyle(color: Colors.grey[600]),
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
                controller: _password,
                obscureText: true,
                cursorColor: Colors.orange,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.amberAccent,
                    ),
                    hintText: "Enter Password",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: GestureDetector(
                child: Text("Forgot Password?"),
                onTap: () => {},
              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _loading = true;
                });
                AuthService _auth = AuthService();
                bool status = await _auth
                    .signInWithEmailAndPassword(_id.text, _password.text)
                    .then((status) {
                  Provider.of<StudentVueProvider>(context).resetData();
                  setState(() {
                    _loading = false;
                  });
                  return status;
                });
                if (!status) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Wrong username or password."),
                  ));
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                alignment: Alignment.center,
                height: 54,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 2),
                  gradient: LinearGradient(colors: [
                    (new Color(0xDD000000)),
                    (new Color(0xFF263238))
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
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
                  "Login",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacementNamed(context, '/signup'),
                    },
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
}
