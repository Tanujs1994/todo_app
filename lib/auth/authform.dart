// ignore_for_file: unused_field, prefer_const_constructors


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //-------------------------------------
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  //-------------------------------------

  startauthentication() {
    if (_formkey.currentState == null) return;
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState?.save();
      submitform(_email, _password, _username);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('invalid'))
      );
    }

  }

  submitform(String email, String password, String username)async{
    print('line 37');
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try{
        if(isLoginPage){
          print('sign in');
          authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
        }
        else{
          print('create user');
          authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
          String? uid = authResult.user?.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'username':username,
            'email': email
          });
        }
    }
    catch(err) {
      print('got error');
      print(err);
    }

  }
 
 //-----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: Container(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLoginPage)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value == null) return 'Incorret username';
                          if (value.isEmpty) {
                            return 'Incorret username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide()),
                          labelText: 'Enter username',
                          // labelStyle: GoogleFonts.roboto()
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value == null) return 'Incorret Email';
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Incorrect email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide()),
                        labelText: 'Enter Email',
                        // labelStyle: GoogleFonts.roboto()
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value == null) return 'Incorret password';
                        if (value.isEmpty) {
                          return 'Incorret password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide()),
                        labelText: 'Enter password',
                        // labelStyle: GoogleFonts.roboto()
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          startauthentication();
                        },
                        child: isLoginPage
                            ? Text(
                                'Login',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 16),
                              )
                            : Text(
                                'SignUp',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 16),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: isLoginPage
                            ? Text('Not a Member?')
                            : Text('Already a Member?'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
