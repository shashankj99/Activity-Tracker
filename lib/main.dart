import 'package:flutter/material.dart';
import 'package:time_tracker/app/landing_page.dart';
import 'package:time_tracker/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Activity Tracker",
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: LandingPage(
        auth: Auth(),
      )
    );
  }
}
