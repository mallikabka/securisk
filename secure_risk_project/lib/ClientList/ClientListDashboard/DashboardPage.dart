import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Blank Page'),
      ),
      body: Container(
        color: Colors.white, // You can set the background color as desired
        child: Center(
          // child: Text(
          //   //'This is a blank page.',
          //   style: TextStyle(fontSize: 20.0),
          // ),
        ),
      ),
    );
  }
}
