import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/dashboard_screen.dart';

class ResetPass extends StatefulWidget {
  final Map userData;

  const ResetPass(this.userData, {super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  bool passenable = true;
  bool passenableCnfrm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xFFF6F8F7),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 150.0, 30.0, 30.0),
        child: ListView(
          children: [
            Center(
                child: Text(
              "Reset Password",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                  child: Text(
                "Enter your new password below, confirm it,",
                style: TextStyle(fontSize: 15, color: Color(0xFF959595)),
              )),
            ),
            Center(
                child: Text(
              "then click the Reset Password button",
              style: TextStyle(fontSize: 15, color: Color(0xFF959595)),
            )),
            Container(
              margin: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: passenable,
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'Password',
                    labelText: "Password",
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: passenableCnfrm,
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'Confirm Password',
                    labelText: "Confirm Password",
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DashboardScreen(widget.userData)),
                      );
                    });
                  },
                  child: const Text(
                    '  Reset Password  ',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    backgroundColor: Color(0xFFF6A03D),
                    // onSurface:
                    //     Colors.transparent,
                    shadowColor: Colors.red.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
