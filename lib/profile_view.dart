import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_services.dart';

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
    await ApiService().postLogout();
     // ignore: use_build_context_synchronously
     Navigator.pushReplacement(
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
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            )),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.00, 0.0, 25.0, 0.0),
          child: Row(
            children: [
              SizedBox(
                width: 85,
                height: 85,
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
                    Text("${user['age']} Years, ${user['hight']}, ${user['weight']}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500))
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
          height: 115,
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('${user["mobile"]}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),)
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("${user["email"]}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
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
                title: Text('Sound',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notification',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Invite Friend',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                 onTap: logout,
              ),
              
            ],
          ),
        ),
      ],
    );
  }

}
