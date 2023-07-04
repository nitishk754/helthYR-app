import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/activity_screen.dart';
import 'package:health_wellness/main.dart';
import 'package:health_wellness/meal_plan.dart';
import 'package:health_wellness/profile_view.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:health_wellness/water_tracker.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'constants/colors.dart';

class DashboardScreen extends StatefulWidget {
  final Map userData;

  const DashboardScreen(this.userData, {super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<String> mealList = ["Breakfast", "Lunch", "Snacks", "Dinner"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    var inputs = userInput.values.toList();
    var token = widget.userData['data']['token'];

    debugPrint('saveQuestions token ==> $token');
    debugPrint('saveQuestions inputs ==> ${{'res': inputs}}');
    ApiService().saveQuestions(token,  {'res': inputs}).then((outputs) {
      debugPrint('saveQuestions outputs ==> $outputs');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_selectedIndex == 0)
          ? AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 135,
              backgroundColor: Colors.white,
              flexibleSpace: customAppBar(context),
            )
          : null,
      body: ListView(
        children: [
          (_selectedIndex == 0)
              ? DashboardScreen(context)
              : (_selectedIndex == 1)
                  ? Text("data")
                  : ProfileView()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(orangeShade),
        onTap: _onItemTapped,
      ),
    );
  }

  ListView DashboardScreen(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Meal Plan For Today",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20, 2.5, 20),
                child: Container(
                  height: 45,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        return mealPlanListView(index);
                      }),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
          thickness: 1,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaterTracker()));
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 200,
                  child: Card(
                    elevation: 2.5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(blueColor),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Water Intake",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 70),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.indeterminate_check_box,
                                    color: Color(lightGreyShadeColor),
                                    size: 30,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: SizedBox(
                                  width: 50,
                                  height: 70,
                                  child: Image(
                                      image: AssetImage(
                                          "assets/Images/waterDashboard.png")),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add_box,
                                    color: Color(blueColor),
                                    size: 30,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityWidget()));
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 200,
                  child:  Card(
                    elevation: 2.5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(blueColor),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Activity",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              child: SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                    customColors: CustomSliderColors(
                                        progressBarColor: Color(blueColor),
                                        trackColor: Colors.grey[200]),
                                    size: 85,
                                    startAngle: 270,
                                    angleRange: 360,
                                    customWidths: CustomSliderWidths(
                                        progressBarWidth: 7)),
                                min: 0,
                                max: 4800,
                                initialValue: 2800,
                                innerWidget: (double value) {
                                  return Center(
                                    child: Text(
                                      "2800",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "2800",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(orangeShade)),
                                  ),
                                  Text(" steps",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[400])),
                                ],
                              ),
                              Text("2 Kilometers",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400])),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  SizedBox mealPlanListView(int index) {
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: () {
          setState(() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MealPlan()));
          });
        },
        child: Card(
          color: Color(orangeShade),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              mealList[index],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SafeArea customAppBar(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 2.5),
      child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 2.5, 5.0, 2.5),
                child: Text(
                  "Welcome, James",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 2.5, 5.0, 0.0),
                child: Text(
                  getCurrentDate(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(lightGreyShadeColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          )),
    ));
  }

  String getCurrentDate() {
    var date = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM dd,yyyy');
    // var dateParse = DateTime.parse(date);

    // var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formatter.format(date);
  }
}
