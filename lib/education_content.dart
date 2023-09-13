import 'package:flutter/material.dart';
import 'package:health_wellness/audio_content.dart';
import 'package:health_wellness/reading_content.dart';
import 'package:health_wellness/video_content.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'constants/colors.dart';

class EducationContent extends StatefulWidget {
  const EducationContent({super.key});

  @override
  State<EducationContent> createState() => _EducationContentState();
}

class _EducationContentState extends State<EducationContent> {
  bool checkboxValue = false;
  
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en');
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Color(blueColor),
                  ),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 10.0, 0.0),
              child: Text(
                "Learning Module",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            child: Card(
              child: HorizontalCalendar(
                date: DateTime.now(),
                textColor: Colors.black45,
                backgroundColor: Colors.white,
                selectedColor: Colors.blue,
                showMonth: false,
                lastDate: DateTime.now(),
                initialDate: DateTime(2023),
                onDateSelected: (date) {},

                // lastDate: DateTime.now() ,
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: Card(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Checkbox(
                          value: checkboxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxValue = value!;
                            });
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                child: Text(
                  "Videos",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
              ),
              InkWell(
                onTap: () {
                   Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoContent()));
                },
                child: Stack(
                  children: [
                    Image(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      image: AssetImage("assets/Images/videos.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Center(
                        child: Center(
                            child: Icon(
                          Icons.play_circle_outline,
                          size: 60,
                          color: Colors.red,
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                child: Text( 
                  "Audio",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
              ),
              InkWell(
                onTap: () {
                   Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AudioContent()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 2.5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(blueColor),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Image(
                          height: 10,
                          width: 10,
                          image: AssetImage("assets/Images/listen.png"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                child: Text(
                  "Reading Content",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
              ),
              InkWell(
                onTap: () {
                   Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReadingContent()));
                },
                child: Image(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  image: AssetImage("assets/Images/written_content.png"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
