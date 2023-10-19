import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:health_wellness/login.dart';
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
          ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,`
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Image(image: AssetImage('assets/Images/welcome.png'))),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Text(
                  "We're So Happy You're Here!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 5.0, 10.0, 5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            });
                          },
                          child: const Text(
                            'Existing User',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0)),
                              backgroundColor: Color(blueColor)),
                          // onSurface:
                          //     Colors.transparent,
                          // shadowColor: Colors.red.shade300,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuestionSection()));
                          },
                          child: const Text(
                            'New User',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            backgroundColor: Color(orangeShade),
                            // onSurface:
                            //     Colors.transparent,
                            // shadowColor: Colors.red.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => QuestionSection()));
          //       },
          //       icon: Icon(
          //         Icons.arrow_forward_rounded,
          //         size: 30,
          //         color: Color(blueColor),
          //       )),
          // )
        ]),
      ),
    );
  }
}
