import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_wellness/constants/urls.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'constants/colors.dart';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({super.key});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;

  final walkingMintueController = TextEditingController();
  final runningMintueController = TextEditingController();
  late String _walkingIntensity = "";
  late String _runningIntensity = "";
  bool _spinner = false;
  String caloriesBurned = "0";
  String dateVal = "";
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 1, vsync: this);
    getCurrentDate();
    _loadActivity();
  }

  _updateActivity(
      String activityType, String duration, String intensity) async {
    setState(() {
      _spinner = true;
    });
    await ApiService()
        .saveActivity(activityType, duration, intensity)
        .then((value) {
      var res = value["data"];
      setState(() => _spinner = false);
      if (!res.containsKey('errors')) {
        _loadActivity();
      }
      final snackBar = SnackBar(content: Text(res["message"]));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _loadActivity() async {
    setState(() => _spinner = true);
    await ApiService().loadActivity(dateVal).then((value) {
      var res = value["data"];
      setState(() => _spinner = false);

      if (!res.containsKey('errors')) {
        if (res["data"].length > 0) {
          setState(() {
            caloriesBurned = res["data"][0]["calories_burned"].toString();
            walkingMintueController.text = "";
            runningMintueController.text = "";
          });
        } else {
          caloriesBurned = "0";
        }
      }

      final snackBar = SnackBar(content: Text(res["message"]));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

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
                "Activities",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 1.5, 10.0, 2.5),
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
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            child: Card(
              child: HorizontalCalendar(
                date: dateTime,
                textColor: Colors.black45,
                backgroundColor: Colors.white,
                selectedColor: Colors.blue,
                showMonth: false,
                lastDate: DateTime.now(),
                initialDate: DateTime(2023),

                // lastDate: DateTime.now() ,
                onDateSelected: (date) {
                  // print("Date S   setState(() {
                  if (date.isAfter(DateTime.now())) {
                    Fluttertoast.showToast(
                        msg: 'You have selected a future date');

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // title: Text("My title"),
                          content: Text("You have selected a future date"),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              super.widget));
                                });
                              },
                            )
                          ],
                        );
                      },
                    );

                    return;
                  } else {
                    final dateSelect = date.toString();
                    final endIndex = dateSelect.indexOf(" ", 0);
                    print(
                        "date selected: ${dateSelect.substring(0, endIndex)}");
                    setState(() {
                      dateVal = dateSelect.substring(0, endIndex);
                      _loadActivity();
                    });
                  }

                  // final startIndex =  dateSelect.substring(0);
                  // final endIndex = dateSelect.indexOf(" ");
                },
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          SizedBox(height: 45, child: Card(child: Center(child: tabbar()))),
          SizedBox(
            height: 25,
          ),
          Builder(builder: (_) {
            if (tabIndex == 0) {
              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Center(
                      child: Text(
                    "Calories Burn",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 17,
                  ),
                  Center(
                    child: SizedBox(
                      height: 125,
                      width: 135,
                      child: Card(
                          elevation: 2.5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(blueColor),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          color: Colors.white,
                          child: Center(
                            child: _spinner
                                ? CircularProgressIndicator()
                                : Text(
                                    "${caloriesBurned}",
                                    style: TextStyle(
                                        fontSize: 38,
                                        color: Color(orangeShade),
                                        fontWeight: FontWeight.bold),
                                  ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Today's Activity",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 0.0),
                    child: SizedBox(
                      height: 70,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.nordic_walking_outlined,
                                    size: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Walking",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "min",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Color(orangeShade)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 60,
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: TextFormField(
                                            controller: walkingMintueController,
                                            maxLength: 4,
                                            textAlign: TextAlign.center,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                filled: true, //<-- SEE HERE
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide:
                                                        BorderSide(width: 0.1)),
                                                hintText: '',
                                                labelText: "",
                                                counterText: ""),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 35.0, // Set the desired height
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: DropdownButton(
                                            value: _walkingIntensity,
                                            // padding: EdgeInsets.only(left: 5),
                                            // DropdownButton properties...
                                            underline:
                                                Container(), // Hide the underline
                                            items: [
                                              DropdownMenuItem(
                                                value: "",
                                                child: Text(
                                                  'Intensity',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ), // Displayed when selectedValue is null
                                              ),
                                              DropdownMenuItem(
                                                value: 'high',
                                                child: Text('High',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              DropdownMenuItem(
                                                value: 'medium',
                                                child: Text('Medium',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              DropdownMenuItem(
                                                value: 'low',
                                                child: Text('Low',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _walkingIntensity =
                                                    value.toString();
                                              });
                                              _updateActivity(
                                                  "walking",
                                                  walkingMintueController.text,
                                                  _walkingIntensity);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 0.0),
                    child: SizedBox(
                      height: 70,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.run_circle_outlined,
                                    size: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Running",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "min",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Color(orangeShade)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 60,
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: TextFormField(
                                            controller: runningMintueController,
                                            maxLength: 4,
                                            textAlign: TextAlign.center,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                filled: true, //<-- SEE HERE
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide:
                                                        BorderSide(width: 0.1)),
                                                hintText: '',
                                                labelText: "",
                                                counterText: ""),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 35.0, // Set the desired height
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: DropdownButton(
                                            // padding: EdgeInsets.only(left: 5),
                                            value: _runningIntensity,
                                            // DropdownButton properties...
                                            underline:
                                                Container(), // Hide the underline
                                            items: [
                                              DropdownMenuItem(
                                                value: "",
                                                child: Text('Intensity',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .w500)), // Displayed when selectedValue is null
                                              ),
                                              DropdownMenuItem(
                                                value: 'high',
                                                child: Text('High',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              DropdownMenuItem(
                                                value: 'medium',
                                                child: Text('Medium',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              DropdownMenuItem(
                                                value: 'low',
                                                child: Text('Low',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _runningIntensity =
                                                    value.toString();
                                              });
                                              _updateActivity(
                                                  "running",
                                                  runningMintueController.text,
                                                  _runningIntensity);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          })
        ],
      ),
    );
  }

  TabBar tabbar() {
    return TabBar(
      onTap: (value) {
        // index = value
        // print(value.toString());
        setState(() {
          tabIndex = value;
          print(tabIndex);
        });
      },
      labelColor: Color(orangeShade),
      // unselectedLabelColor: Colors.yellow,
      indicatorSize: TabBarIndicatorSize.label,
      controller: tabController,
      indicatorColor: Color(blueColor),
      isScrollable: true,
      tabs: [
        Container(
          child: Tab(
            child: Text(
              "Today",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  String getCurrentDate() {
    var date = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM dd,yyyy');
    final DateFormat formatter2 = DateFormat('yyyy-MM-dd');
    // var dateParse = DateTime.parse(date);
    dateVal = formatter2.format(date);

    // var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    print("date value: ${formatter2.format(date)}");
    return formatter.format(date);
  }
}
