import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String title, description;
  const Description(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
    );
  }
}
