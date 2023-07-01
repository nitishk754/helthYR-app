import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/dashboard_screen.dart';
import 'package:health_wellness/reset_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'services/api_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var isChecked = false;
  var isLoading = false;

  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8F7),
      appBar: null,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 30.0),
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
                  controller: controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
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
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return 'Enter a valid password!';
                    }
                    return null;
                  },
                  controller: controllerPassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
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
                child: isLoading
                    ? CupertinoActivityIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          final isValid = _formKey.currentState!.validate();
                          if (isValid && isChecked) {
                            setState(() => isLoading = true);
                            var email = controllerEmail.text;
                            var password = controllerPassword.text;
                            var result =
                                await ApiService().getUser(email, password);
                                print("resultresult_${result}");
                            if (result.containsKey('errors')) {
                              setState(() => isLoading = false);
                              return;
                            }

                            prefs.setString("_token", result['data']['token']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                var login_histories = result['data']['user']
                                    ['login_histories'] as List;
                                var token = result['data']['token'];
                                debugPrint('user token ==> $token');
                                debugPrint('user token ==> $userInput');
                                return login_histories.isEmpty
                                    ? ResetPass(result)
                                    : DashboardScreen(result);
                              }),
                            );
                          }
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
                child: Text("Forget Password?", style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
