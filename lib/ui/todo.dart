import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List todos = [];
  String input = "";
  String _uid = "";

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });
    }

    createTodos() {
      DocumentReference documentReference = FirebaseFirestore.instance
          .doc('/users/$_uid')
          .collection("todos")
          .doc(input);

      Map<String, String> todo = {"todoTitle": input};

      documentReference.set(todo).whenComplete(() {
        print("$input created");
      });
    }

    deleteTodos(id) {
      final collection =
          FirebaseFirestore.instance.doc('/users/$_uid').collection("todos");
      collection
          .doc(id.toString()) // <-- Doc ID to be deleted.
          .delete() // <-- Delete
          .then((_) => print('Deleted'))
          .catchError((error) => print('Delete failed: $error'));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add TodoList"),
                    content: TextField(
                      onChanged: (String value) {
                        input = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            createTodos();
                            Navigator.of(context).pop();
                          },
                          child: Text("Add"))
                    ],
                  );
                });
          },
          child: const Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .doc('/users/$_uid')
              .collection("todos")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            todos = [];
            if (snapshots.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading"));
            }
            snapshots.data.docs.forEach((DocumentSnapshot e) {
              Map<String, dynamic> data = e.data() as Map<String, dynamic>;
              todos.add(data["todoTitle"]);
            });
            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: Key(todos[index]),
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          title: Text(todos[index]),
                          trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  deleteTodos(todos[index]);
                                });
                              }),
                        ),
                      ));
                });
          }),
    );
  }
}
