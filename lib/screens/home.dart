import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task.dart';

class TaskModel{
  String id;
  String description;
  String title;

  TaskModel({required this.id, required this.description, required this.title});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<TaskModel> myAllTodos = [];

  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
    getDataFromFirebase();
  }

  getDataFromFirebase(){
    final db = FirebaseFirestore.instance;
    db.collection("tasks").doc(uid).collection("my tasks").get().then(
  (querySnapshot) {
    print("Successfully completed");
    List<TaskModel> fromServer = [];
    for (var docSnapshot in querySnapshot.docs) {
      print('${docSnapshot.id} => ${docSnapshot.data()}');
      fromServer.add(TaskModel(id: docSnapshot.id, description: docSnapshot.get('description'), title: docSnapshot.get('title')));
    }
    setState(() {
      myAllTodos = fromServer;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: ListView.builder(
        itemCount: myAllTodos.length,
        itemBuilder: (ctx, indx){
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Text(myAllTodos[indx].id),
                Text(myAllTodos[indx].title),
                Text(myAllTodos[indx].description),
              ],
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
