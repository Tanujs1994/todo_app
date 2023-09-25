// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/screens/description.dart';

class TaskModel {
  String id;
  String description;
  String title;
  String time;

  TaskModel(
      {required this.id,
      required this.description,
      required this.title,
      required this.time});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TaskModel> myAllTodos = [];

  bool showProgressBar = true;
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
    getDataFromFirebase();
  }

  getDataFromFirebase() async {
    final db = FirebaseFirestore.instance;
    await Future.delayed(Duration(seconds: 1));
    db.collection("tasks").doc(uid).collection("my tasks").snapshots().listen(
      (querySnapshot) {
        print("Successfully completed");
        List<TaskModel> fromServer = [];
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          String timeIs = docSnapshot.get('time');
          final dateTime = DateTime.parse(timeIs);
          final dateFormat = DateFormat('dd MMMM yyyy HH:mm:ss:a');
          timeIs = dateFormat.format(dateTime);
          fromServer.add(TaskModel(
            id: docSnapshot.id,
            description: docSnapshot.get('description'),
            title: docSnapshot.get('title'),
            time: timeIs,
          ));
        }
        setState(() {
          myAllTodos = fromServer;
          showProgressBar = false;
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  getuid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showProgressBar) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: ListView.builder(
        itemCount: myAllTodos.length,
        itemBuilder: (ctx, indx) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Description(
                          title: myAllTodos[indx].title,
                          description: myAllTodos[indx].description)));
            },
            child: Card(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        myAllTodos[indx].time,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            myAllTodos[indx].title,
                            style: TextStyle(color: Colors.white),
                          ),
                          Container(
                            child: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('my tasks')
                                      .doc(myAllTodos[indx].id)
                                      .delete();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        myAllTodos[indx].description,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTask()));
          }),
    );
  }
}
