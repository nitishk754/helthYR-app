import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_wellness/activity_screen.dart';
import 'package:health_wellness/animatedPos.dart';
import 'package:health_wellness/custom_radio_button_2.dart';
import 'package:health_wellness/health_controller.dart';
import 'package:health_wellness/health_data.dart';
import 'package:health_wellness/login.dart';
import 'package:health_wellness/main.dart';
import 'package:health_wellness/meal_plan.dart';
import 'package:health_wellness/nutrient_tracker.dart';
import 'package:health_wellness/profile_view.dart';
import 'package:health_wellness/recipes.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:health_wellness/water_tracker.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/colors.dart';
import 'education_content.dart';

class DashboardScreen extends StatefulWidget {
  final Map userData;

  const DashboardScreen(this.userData, {super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int waterIntake = 1;
  // use in statefull widget or in stateless widget in stateless widget you need
// a statemanagement service or you are unable to change value in setState
  final double min = 0;
  final double max = 10;
  String selectedValue = '';
  // int _currentIntValue = 65;
  double _currentHorizontalIntValue = 65;
  final weightController = TextEditingController();

  List<String> mealList = ["Breakfast", "Lunch", "Snacks", "Dinner"];
  Map dashboardData = {};
  bool _spinner = false;
  late List<NutrientData> _nutData;
  String _weight = 'lbs';
  bool isDialogVisible = false;
  // late TooltipBehavior _tooltip;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // _nutData = getNutrientData();
    // _tooltip = TooltipBehavior(enable: true);
    super.initState();
    selectedValue = min.toString();

    saveQues();

    _dashboard();

    // getUserProfile();
  }

  Future<void> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await ApiService().userProfile();

    prefs.setString("userResult", jsonEncode(result));
  }

  Future<void> saveQues() async {
    var inputs = userInput.values.toList();
    var token = widget.userData['data']['token'];

    debugPrint('saveQuestions token ==> $token');
    debugPrint('saveQuestions inputs ==> ${{'res': inputs}}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    ApiService().saveQuestions(token, {'res': inputs}).then((outputs) {
      debugPrint('saveQuestions outputs ==> $outputs');
      setState(() {
        prefs.setBool("_isLoggedIn", true);
        getUserProfile();
      });
    });
  }

  void refreshData() {
    _dashboard();
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

//   _launchURL() async {
//    final Uri url = Uri.parse('https://flutter.dev');
//    if (!await launchUrl(url)) {
//         throw Exception('Could not launch $_url');
//     }
// }

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
                _weight =
                    "${dashboardData["current_weight"]["weight_measurement"]}";
                _currentHorizontalIntValue = double.parse(
                    (dashboardData["current_weight"]["user_weight"]));
                weightController.text = _currentHorizontalIntValue.toString();

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
        } else {
          if (resource["message"] == "Unauthenticated.") {
            print("elseCond");
            setState(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false);
            });
            return;
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

  _adduserWeight(String userWeight, String weightUnit) async {
    setState(() => _spinner = true);

    await ApiService().addWeightDash(userWeight, weightUnit).then((value) {
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
      onWillPop: () async {
        _dashboard();
        exit(0);
      },
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
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            (_selectedIndex == 0)
                ? (_spinner)
                    ? Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    :
                    // LiquidPullToRefresh(
                    //     onRefresh: () async {
                    //       _dashboard();
                    //     },
                    // child:
                    DashboardScreen(context)
                //  )
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
      physics: NeverScrollableScrollPhysics(),
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
              // primary: false,
              // padding: const EdgeInsets.all(20),
              crossAxisSpacing: 15,
              mainAxisSpacing: 7,
              crossAxisCount: 2,
              children: [
                nutrientTracker(context),
                activityTracker(context),
                educationContent(context),
                waterTracker(context),
                recipeWidget(context),
                weightTracker(context),
                discountSupplements(context)
                // recipeWidget(context),
                // recipeWidget(context)
              ],
            )),
      ],
    );
  }

  Container weightTracker(BuildContext context) {
    return Container(
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Weight Tracker",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                    child: Image(
                  height: 55,
                  width: 55,
                  image: AssetImage("assets/Images/scale.png"),
                )),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.indeterminate_check_box_sharp,
                      color: Color(blueColor),
                    ),
                    onPressed: () => setState(() {
                      final newValue = _currentHorizontalIntValue - 0.5;
                      _currentHorizontalIntValue = newValue;
                      _adduserWeight(
                          _currentHorizontalIntValue.toString(), _weight);
                    }),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            // <-- SEE HERE
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0),
                            ),
                          ),
                          // isDismissible: false,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter mystate) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                    height: 210,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Enter Your Weight",
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 90,
                                            height: 40,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: TextFormField(
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                controller: weightController,
                                                maxLength: 4,
                                                onChanged: (value) {
                                                  if (value.length > 1) {
                                                    mystate(() {
                                                      _currentHorizontalIntValue =
                                                          double.parse(
                                                              weightController
                                                                  .text);
                                                    });
                                                  }
                                                },
                                                textAlign: TextAlign.center,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    filled: true,
                                                    //<-- SEE HERE
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide: BorderSide(
                                                            width: 1)),
                                                    hintText: '',
                                                    labelText: "",
                                                    counterText: ""),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                MyRadioListTile2<String>(
                                                    value: 'kg',
                                                    leading: 'kg',
                                                    groupValue: _weight,
                                                    fontSize: 10,
                                                    customHeight: 22,
                                                    customWidth: 35,
                                                    weight: FontWeight.w500,
                                                    onChanged: (value) {
                                                      mystate(() {
                                                        _weight = value!;

                                                        _currentHorizontalIntValue =
                                                            double.parse(
                                                                (_currentHorizontalIntValue *
                                                                        0.453)
                                                                    .toStringAsFixed(
                                                                        1));
                                                        weightController.text =
                                                            _currentHorizontalIntValue
                                                                .toString();

                                                        // _adduserWeight(
                                                        //     _currentHorizontalIntValue
                                                        //         .toString(),
                                                        //     _weight);
                                                      });
                                                      // setState(() {
                                                      //   _weight = value!;

                                                      //   // _currentHorizontalIntValue =
                                                      //   //     double.parse(
                                                      //   //         (_currentHorizontalIntValue *
                                                      //   //                 0.453)
                                                      //   //             .toStringAsFixed(
                                                      //   //                 1));
                                                      //   // weightController.text =
                                                      //   //     _currentHorizontalIntValue
                                                      //   //         .toString();
                                                      // });
                                                    }),
                                                MyRadioListTile2<String>(
                                                    value: 'lbs',
                                                    leading: 'lbs',
                                                    groupValue: _weight,
                                                    fontSize: 10,
                                                    customHeight: 22,
                                                    customWidth: 35,
                                                    weight: FontWeight.w400,
                                                    onChanged: (value) {
                                                      mystate(() {
                                                        _weight = value!;
                                                        _currentHorizontalIntValue =
                                                            double.parse(
                                                                (_currentHorizontalIntValue /
                                                                        0.453)
                                                                    .toStringAsFixed(
                                                                        1));
                                                        weightController.text =
                                                            _currentHorizontalIntValue
                                                                .toString();
                                                        // _adduserWeight(
                                                        //     _currentHorizontalIntValue
                                                        //         .toString(),
                                                        //     _weight);
                                                      });

                                                      // setState(() {
                                                      //   _weight = value!;

                                                      //   // _currentHorizontalIntValue =
                                                      //   //     double.parse(
                                                      //   //         (_currentHorizontalIntValue /
                                                      //   //                 0.453)
                                                      //   //             .toStringAsFixed(
                                                      //   //                 1));
                                                      //   // weightController.text =
                                                      //   //     _currentHorizontalIntValue
                                                      //   //         .toString();
                                                      // });
                                                    }),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                child: const Text('Submit'),
                                                onPressed: () {
                                                  _adduserWeight(
                                                      weightController.text,
                                                      _weight);
                                                  Navigator.pop(context);
                                                }),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            });
                          }).then((value) => _dashboard());
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(1)),
                          border:
                              Border.all(width: 0.5, color: Color(blueColor)),
                        ),
                        child: Text(
                          '$_currentHorizontalIntValue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.add_box, color: Color(blueColor)),
                    onPressed: () => setState(() {
                      final newValue = _currentHorizontalIntValue + 0.5;
                      _currentHorizontalIntValue = newValue;
                      _adduserWeight(
                          _currentHorizontalIntValue.toString(), _weight);
                    }),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyRadioListTile2<String>(
                      value: 'kg',
                      leading: 'kg',
                      groupValue: _weight,
                      fontSize: 10,
                      customHeight: 22,
                      customWidth: 35,
                      weight: FontWeight.w500,
                      onChanged: (value) {
                        setState(() {
                          _weight = value!;

                          _currentHorizontalIntValue = double.parse(
                              (_currentHorizontalIntValue * 0.453)
                                  .toStringAsFixed(1));

                          _adduserWeight(
                              _currentHorizontalIntValue.toString(), _weight);
                        });
                      }),
                  MyRadioListTile2<String>(
                      value: 'lbs',
                      leading: 'lbs',
                      groupValue: _weight,
                      fontSize: 10,
                      customHeight: 22,
                      customWidth: 35,
                      weight: FontWeight.w400,
                      onChanged: (value) {
                        setState(() {
                          _weight = value!;
                          _currentHorizontalIntValue = double.parse(
                              (_currentHorizontalIntValue / 0.453)
                                  .toStringAsFixed(1));
                          _adduserWeight(
                              _currentHorizontalIntValue.toString(), _weight);
                        });
                      }),
                ],
              ),
            )
            // Expanded(
            //   child: Align(
            //     alignment: AlignmentDirectional.bottomCenter,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         Text(
            //           "2kgs to loose!",
            //           style: TextStyle(
            //               color: Color(orangeShade),
            //               fontSize: 20,
            //               fontWeight: FontWeight.w600),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  InkWell discountSupplements(BuildContext context) {
    return InkWell(
      onTap: () async {
        String url = "https://secure.cobionic.com/collections/all-supplements";
        var urllaunchable =
            await canLaunch(url); //canLaunch is from url_launcher package
        if (urllaunchable) {
          await launch(url); //launch is from url_launcher package to launch URL
        } else {
          print("URL can't be launched.");
        }
        //check it

        //        const url = 'https://flutter.dev';
        // if (await canLaunchUrl(Uri.parse(url))) {
        //   await launchUrl(Uri.parse(url));
        // } else {
        //   throw 'Could not launch $url';
        // }
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
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Supplements",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image(
                      height: 65,
                      width: 65,
                      image: AssetImage("assets/Images/vitamin.png"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "50%",
                        style: TextStyle(
                            color: Color(orangeShade),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Discount",
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell recipeWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipesWidget()))
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
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Recipes",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image(
                      height: 65,
                      width: 65,
                      image: AssetImage("assets/Images/recipeBook.png"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${dashboardData["total_recipes"]}",
                        style: TextStyle(
                            color: Color(orangeShade),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "recipes",
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell educationContent(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EducationContent()))
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
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Educational Content",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image(
                      height: 65,
                      width: 65,
                      image: AssetImage("assets/Images/eduWidget.png"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "80%",
                        style: TextStyle(
                            color: Color(orangeShade),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "completed",
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
                  child: InkWell(
                onTap: () {
                  setState(() {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthData()))
                        .then(onGoBack);
                  });
                },
                child: (dashboardData['nutrient_data']["total_calories"] == 0)
                    ? Center(
                        child: Text(
                          "No Meal Added To The Nutritient Tracker",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : donutData(context),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Container donutData(BuildContext context) {
    return Container(
      width: 170,
      height: 120,
      child: SfCircularChart(
        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
          setState(() {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HealthData()))
                .then(onGoBack);
          });
        },
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
              height: '50%',
              width: '50%',
              widget: PhysicalModel(
                shape: BoxShape.circle,
                elevation: 0,
                color: Colors.white,
                child: Container(),
              )),
          CircularChartAnnotation(
              widget: Text(
                  "${(dashboardData['nutrient_data']["total_calories"]).roundToDouble().round()}",
                  style: TextStyle(
                    color: Color(orangeShade),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )))
        ],
        series: <CircularSeries>[
          DoughnutSeries<NutrientData, String>(
              animationDuration: 1000.0,
              dataSource: [
                NutrientData(
                    dashboardData['nutrient_data']['inner_data'][0]["key"],
                    (dashboardData['nutrient_data']['inner_data'][0]["value"])
                        .toDouble(),
                    Color(donutBlueShadeDark)),
                NutrientData(
                    dashboardData['nutrient_data']['inner_data'][1]["key"],
                    (dashboardData['nutrient_data']['inner_data'][1]["value"])
                        .toDouble(),
                    Color(donutBlueShadeMed)),
                NutrientData(
                    dashboardData['nutrient_data']['inner_data'][2]["key"],
                    (dashboardData['nutrient_data']['inner_data'][2]["value"])
                        .toDouble(),
                    Color(donutBlueShadeLite)),
              ],
              // pointColorMapper: (NutrientData data) => data.color,
              pointColorMapper: (NutrientData data, _) => data.color,
              xValueMapper: (NutrientData data, _) => data.nutrient,
              yValueMapper: (NutrientData data, _) => data.value,
              dataLabelMapper: (NutrientData data, _) => data.nutrient,
              radius: "40",
              dataLabelSettings: DataLabelSettings(
                  alignment: ChartAlignment.near,
                  angle: 0,
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  connectorLineSettings:
                      ConnectorLineSettings(width: 1.0, length: "5"),
                  textStyle:
                      TextStyle(fontSize: 9, fontWeight: FontWeight.w600)))
        ],
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
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

class NutrientData {
  NutrientData(this.nutrient, this.value, this.color);

  final String nutrient;
  final double value;
  final Color color;
}
