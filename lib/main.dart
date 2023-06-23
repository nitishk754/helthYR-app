import 'package:flutter/material.dart';
import 'package:health_wellness/activity_screen.dart';
import 'package:health_wellness/dashboard_screen.dart';
import 'package:health_wellness/login.dart';
import 'package:health_wellness/meal_plan.dart';
import 'package:health_wellness/question_section.dart';
import 'package:health_wellness/reset_pass.dart';
import 'package:health_wellness/splash_screen.dart';
import 'package:health_wellness/water_tracker.dart';
import 'package:health_wellness/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}


