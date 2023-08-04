import 'dart:async';
import 'dart:io';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_wellness/activity_screen.dart';
import 'package:health_wellness/login.dart';
import 'package:health_wellness/main.dart';
import 'package:health_wellness/meal_plan.dart';
import 'package:health_wellness/nutrient_tracker.dart';
import 'package:health_wellness/profile_view.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:health_wellness/water_tracker.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int waterIntake = 1;

  List<String> mealList = ["Breakfast", "Lunch", "Snacks", "Dinner"];
  Map dashboardData = {};
  bool _spinner = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    saveQues();

    _dashboard();
  }

  Future<void> saveQues() async {
    var inputs = userInput.values.toList();
    var token = widget.userData['data']['token'];

    debugPrint('saveQuestions token ==> $token');
    debugPrint('saveQuestions inputs ==> ${{'res': inputs}}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.getBool("_isLoggedIn")!) {
      ApiService().saveQuestions(token, {'res': inputs}).then((outputs) {
        debugPrint('saveQuestions outputs ==> $outputs');
        prefs.setBool("_isLoggedIn", true);
      });
    }
  }

  void refreshData() {
    _dashboard();
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  _dashboard() async {
    setState(() => _spinner = true);
    await ApiService().getDashboard().then((value) {
      var resource = value["data"];
      debugPrint("dashboard data ${dashboardData}");
      setState(() {
        if (!resource.containsKey('errors')) {
          if (resource.containsKey("status")) {
            if (resource["status"] == "success") {
              setState(() {
                print("ifCond");
                dashboardData = resource["data"];
                debugPrint("dashboard data ${dashboardData}");
                setState(() => _spinner = false);
              });
            } else {
              Fluttertoast.showToast(msg: 'Something Went Wrong!');
            }
          } else {
            if (resource["message"] == "Unauthenticated.") {
              print("elseCond");
              setState(() {
                logout();
              });
              return;
            }
          }
        }
      });
    });
  }

  _addWaterIntake() async {
    setState(() => _spinner = true);

    await ApiService().addWaterIntake(waterIntake.toString()).then((value) {
      var res = value["data"];
      if (res["status"] == "success") {
        _dashboard();
      } else {
        setState(() {
          _spinner = false;
        });
      }

      final snackBar = SnackBar(content: Text(res["message"]));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    await ApiService().postLogout().then((value) {
      var res = value["data"];

      setState(() {
        if (res.containsKey("status")) {
          prefs.clear();
          prefs.setBool("_isLoggedIn", false);
        }
      });
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
    //  Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return Login();
    //   }),
    // );
    await Future.delayed(const Duration(seconds: 10));
    setState(() => _spinner = false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => exit(0),
      child: Scaffold(
        appBar: (_selectedIndex == 0)
            ? AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 130,
                backgroundColor: Colors.white,
                flexibleSpace: customAppBar(context),
              )
            : null,
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            (_selectedIndex == 0)
                ? (_spinner)
                    ? Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : LiquidPullToRefresh(
                        onRefresh: () async {
                          _dashboard();
                        },
                        child: DashboardScreen(context))
                : (_selectedIndex == 1)
                    ? Text("")
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
      ),
    );
  }

  ListView DashboardScreen(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
              child: Text(
                "Your Meal Plan For Today",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 20, 2.0, 20),
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
        Divider(
          height: 2,
          thickness: 1,
          color: Colors.grey,
        ),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              physics:
                  NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              primary: false,
              // padding: const EdgeInsets.all(20),
              crossAxisSpacing: 15,
              mainAxisSpacing: 7,
              crossAxisCount: 2,
              children: [
                // nutrientTracker(context),
                waterTracker(context),
                activityTracker(context)
              ],
            ))
      ],
    );
  }

  InkWell nutrientTracker(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NutrientTracker()))
              .then(onGoBack);
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: 170,
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
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Nutrient Tracker",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Center(
                child: AspectRatio(
                  aspectRatio: 15 / 10,
                  child: DChartPie(
                    donutWidth: 10,
                    data: [
                      {'domain': 'Flutter', 'measure': 28},
                      {'domain': 'React Native', 'measure': 27},
                      {'domain': 'Ionic', 'measure': 20},
                      {'domain': 'Cordova', 'measure': 15},
                    ],
                    fillColor: (pieData, index) {
                      switch (pieData['domain']) {
                        case 'Flutter':
                          return Colors.blue;
                        case 'React Native':
                          return Colors.blueAccent;
                        case 'Ionic':
                          return Colors.lightBlue;
                        default:
                          return Colors.orange;
                      }
                    },
                    pieLabel: (pieData, index) {
                      return "${pieData['domain']}:\n${pieData['measure']}%";
                    },
                    labelPosition: PieLabelPosition.outside,
                    labelLinelength: 3.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell activityTracker(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityWidget()))
              .then(onGoBack);
        });
      },
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            ),
        width: MediaQuery.of(context).size.width * 0.45,
        height: 170,
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
                      "Activity",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Image(
                          height: 30,
                          width: 30,
                          image: AssetImage("assets/Images/calories.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text("${dashboardData["calories_burned"]}",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  // child: Container(
                  //   child: SleekCircularSlider(
                  //     appearance: CircularSliderAppearance(
                  //         customColors: CustomSliderColors(
                  //             progressBarColor: Color(blueColor),
                  //             trackColor: Colors.grey[200]),
                  //         size: 85,
                  //         startAngle: 270,
                  //         angleRange: 360,
                  //         customWidths: CustomSliderWidths(
                  //             progressBarWidth: 7)),
                  //     min: 0,
                  //     max: 4800,
                  //     initialValue: 2800,
                  //     innerWidget: (double value) {
                  //       return Center(
                  //         child: Text(
                  //           "2800",
                  //           style: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
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
                          "Calories",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(orangeShade)),
                        ),
                        // Text(" steps",
                        //     style: TextStyle(
                        //         fontSize: 13,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.grey[400])),
                      ],
                    ),
                    Text("Burned Today",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400])),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell waterTracker(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WaterTracker()))
              .then(onGoBack);
        });
      },
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            ),
        
        width: MediaQuery.of(context).size.width * 0.45,
        height: 170,
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Center(
                child: Container(
                  // margin: EdgeInsets.only(top: 70),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                waterIntake = -1;
                                _addWaterIntake();
                              });
                            },
                            icon: Icon(
                              Icons.indeterminate_check_box,
                              color: Color(lightGreyShadeColor),
                              size: 25,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Flexible(
                          child: SizedBox(
                            width: 45,
                            height: 65,
                            child: Image(
                                image: AssetImage(
                                    "assets/Images/waterDashboard.png")),
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                waterIntake = 1;
                                _addWaterIntake();
                              });
                            },
                            icon: Icon(
                              Icons.add_box,
                              color: Color(blueColor),
                              size: 25,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dashboardData["water_intake"]["today_intake"] > 8
                              ? ""
                              : "${dashboardData["water_intake"]["ideal_water_intake_a_day"] - dashboardData["water_intake"]["today_intake"]} ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(orangeShade)),
                        ),
                        Text(
                          dashboardData["water_intake"]["today_intake"] > 8
                              ? "Done for the day"
                              : "more glasses to go",
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox mealPlanListView(int index) {
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: () {
          setState(() {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MealPlan()))
                .then(onGoBack);
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
                  fontWeight: FontWeight.w500),
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
                padding: const EdgeInsets.fromLTRB(5.0, 1, 5.0, 1),
                child: Text(
                  "Welcome, ${widget.userData['data']['user']['name']}",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 1, 5.0, 0.0),
                child: Text(
                  getCurrentDate(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(lightGreyShadeColor),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
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
