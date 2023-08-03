import 'dart:async';
import 'dart:convert';

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


var userInput = <String, dynamic>{};

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HELTHYR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
       builder: (context, child) {
            return MediaQuery(
              child: child!,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
            );
       }
      //home: const MealPlan(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //Timer(const Duration(seconds: 3), () => _auth());
    _auth();
    super.initState();
  }
  
  _auth() async {
    
              
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("_token_${prefs.getString("_token")}");
    if(prefs.getString("_token") == null){
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return const WelcomePage();
          }),
        );
    }else{
      var _result = prefs.getString("_result");
      Map result = jsonDecode(_result!);
     // print(result["data"]["user"]["name"]);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            var login_histories = result['data']['user']
                ['login_histories'] as List;
            //var token = result['data']['token'];
            //debugPrint('user token ==> $token');
            //debugPrint('user token ==> $userInput');
            return (login_histories.length==1&&!prefs.getBool("_isLoggedIn")!)
                ? ResetPass(result)
                : DashboardScreen(result);
          }),
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Image.asset(
      //   'assets/splash/splash.png',
      // ),
    );
  }
}