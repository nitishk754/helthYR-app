import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map user = {};

  @override
  void initState() {
    _auth();
    super.initState();
  }
  _auth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var _result = prefs.getString("_result");
    Map result = jsonDecode(_result!);
    setState(() {
      user = result["data"]["user"];
    });
  }
  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
     // ignore: use_build_context_synchronously
     Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return  Login();
          }),
        );

        return true;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      //shrinkWrap: true,
      //physics: ClampingScrollPhysics(),
      children: [
        SizedBox(
          height: 35,
        ),
        Align(
            alignment: Alignment.center,
            child: Text(
              "Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.00, 0.0, 25.0, 0.0),
          child: Row(
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/Images/avatar.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${user['name']}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10,),
                    Text("27 years, 6ft, 55kg",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 25,
        ),
        
        Divider(
          height: 2,
          thickness: 2,
        ),
        SizedBox(
          height: 130,
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('+45-243-3234')
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("${user["email"]}")
              ),
              
            ],
          ),
        ),
         Divider(
          height: 2,
          thickness: 2,
        ),
        SizedBox(
          height: 250,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Sound')
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notification')
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Invite Friend')
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                 onTap: logout,
              ),
              
            ],
          ),
        ),
      ],
    );
  }

}
