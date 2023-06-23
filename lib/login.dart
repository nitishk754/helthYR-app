import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/dashboard_screen.dart';
import 'package:health_wellness/reset_pass.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8F7),
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 30.0),
        child: ListView(
          children: [
            SizedBox(
                height: 250,
                width: 250,
                child: Image(image: AssetImage('assets/Images/login.png'))),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Welcome To Fettl365",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              child: TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),

                    hintText: 'Enter your Email',
                    labelText: "Email",
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 18),
              child: TextFormField(
                obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'Enter your Password',
                    labelText: "Password",
                  )),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("I agree with term & condition and privacy policy"),
              checkColor: Colors.white,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                       Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPass()));
                    });
                  },
                  child: const Text(
                    '  Login  ',
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Forget Password?",style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
