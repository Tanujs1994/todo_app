import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  //-------------------------------------
  final _formkey = GlobalKey<FormState>();
  final _email = '';
  final _password = '';

  //-------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            child: Form(
              key: _formkey,
                child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('email'),
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}
