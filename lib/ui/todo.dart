/*
This is the file to show the user's todo. 
This data is stored in Firebase.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List todos = []; // List of todos
  String input = ""; // User input (for new todos)
  String _uid = ""; // Variable to hold user ID

  @override
  Widget build(BuildContext context) {
    // Get user data and set the ID.
    final UserModel user = Provider.of<UserModel>(context);
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });
    }

    // Function to create a new todo item.
    createTodos() {
      // Get reference to database table.
      DocumentReference documentReference = FirebaseFirestore.instance
          .doc('/users/$_uid')
          .collection("todos")
          .doc(input);

      // New object for todo item.
      Map<String, String> todo = {"todoTitle": input};

      // Add todo item to table and print when complete.
      documentReference.set(todo).whenComplete(() {
        print("New todo: $input created");
      });
    }

    // Delete todo based on ID.
    deleteTodos(id) {
      final collection =
          FirebaseFirestore.instance.doc('/users/$_uid').collection("todos");
      collection
          .doc(id.toString()) // <- Doc ID to be deleted.
          .delete() // <- Delete
          .then((_) => print('Deleted todo!'))
          .catchError((error) => print('Delete failed: $error'));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          // Floating button to add new todo item.
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add item"),
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
      // Create todo list from stream connection to database table. (Realtime connection)
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .doc('/users/$_uid')
              .collection("todos")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            todos = []; // Set the todo list empty.
            // Show user status.
            if (snapshots.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading"));
            }
            // When data arrives add each item to the todo list.
            snapshots.data.docs.forEach((DocumentSnapshot e) {
              Map<String, dynamic> data = e.data() as Map<String, dynamic>;
              todos.add(data["todoTitle"]);
            });
            // Show all the todo items.
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
                          title: Row(
                            children: [
                              // Button to delete todo.
                              IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    setState(() {
                                      deleteTodos(todos[index]);
                                    });
                                  }),
                              Text(todos[index]),
                            ],
                          ),
                        ),
                      ));
                });
          }),
    );
  }
}
