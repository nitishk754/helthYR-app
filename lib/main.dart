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

var userInput = <String, dynamic>{};

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
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(),
    );
  }
}
