import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:health_wellness/question_section.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 350,
                  height: 350,
                  child: Image(image: AssetImage('assets/Images/welcome.png'))),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Text(
                  "We're So Happy You're Here!",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                  width: 150,
                  height: 10,
                  child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Image(
                          image: AssetImage('assets/Images/underline.png')))),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    "Join us on a journey to improved health and well being created by healthcare professionals.",
                    style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionSection()));
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 30,
                  color: Color(blueColor),
                )),
          )
        ]),
      ),
    );
  }
}
