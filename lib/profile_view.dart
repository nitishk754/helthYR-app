import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
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
                    Text("Emily",
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
        )
      ],
    );
  }
}
