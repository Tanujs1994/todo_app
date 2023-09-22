import 'package:flutter/material.dart';
import 'package:todo_app/auth/authscreen.dart';
import 'package:todo_app/screens/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(brightness: Brightness.light, primaryColor: Colors.purple),
    );
  }
}
