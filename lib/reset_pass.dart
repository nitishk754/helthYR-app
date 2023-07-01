import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/dashboard_screen.dart';

import 'services/api_services.dart';

class ResetPass extends StatefulWidget {
  final Map userData;

  const ResetPass(this.userData, {super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  bool passenable = true;
  bool passenableCnfrm = true;

  var isLoading = false;

  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xFFF6F8F7),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30.0, 150.0, 30.0, 30.0),
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
                  controller: controllerEmail,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Enter a valid password!';
                    }
                    return null;
                  },
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
                  controller: controllerPassword,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Enter a valid password!';
                    }
                    if (controllerEmail.text != value) {
                      return 'Password not matched!';
                    }
                    return null;
                  },
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
                child: isLoading
                    ? CupertinoActivityIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            setState(() => isLoading = true);
                            var token = widget.userData['data']['token'];
                            debugPrint('user token ==> $token');
                            var result = await ApiService()
                                .resetPassword(token, {
                              "password": controllerEmail.text,
                              "password_confirmation": controllerPassword.text,
                            });
                            if (result.containsKey('errors')) {
                              setState(() => isLoading = false);
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return DashboardScreen(widget.userData);
                              }),
                            );
                          }
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
