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
      body: Container(
        // width: double.infinity,
        color: Colors.blueAccent,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(title,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),), 
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(description,style: TextStyle(fontSize: 18,color: Colors.white),), 
              ),
            )
          ],
        ),
      ),
    );
  }
}
