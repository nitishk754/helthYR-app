import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health/health.dart';
import 'package:health_wellness/fit_health_app.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants/colors.dart';

class HealthData extends StatefulWidget {
  const HealthData({super.key});

  @override
  State<HealthData> createState() => _HealthDataState();
}

class _HealthDataState extends State<HealthData> {
  // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
  // late Map userWatchdata;
  List dataList = [];
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  List<HealthDataPoint> _healthDataList = [];
  List<HealthWorkoutActivityType> _activityList = [];
  bool _spinner = false;
  String platformName = "";

  // define the types to get
  static var types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  var HEART_RATE = "0";
  var SLEEP_ASLEEP = "0";
  var BLOOD_OXYGEN = "0";
  var ACTIVE_ENERGY_BURNED = "0";
  var STEPS = "0";

  // var actTyp = [
  //   HealthWorkoutActivityType.WALKING,
  //   HealthWorkoutActivityType.BIKING
  // ];

  @override
  void initState() {
    super.initState();
    getHealthData();
  }

  Future<void> addWatchData() async {
    await ApiService().addHealthAppData(platformName, dataList).then((value) {
      var resource = value["data"];
      if (resource['status'] == "success") {
        Fluttertoast.showToast(msg: '${resource['message']}');
      }
    });
  }

  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  Future<void> getHealthData() async {
    await Permission.activityRecognition.request();

    // bool? hasPermissions =
    //     await health.hasPermissions(types, permissions: permissions);

    // // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // // Hence, we have to request with WRITE as well.
    // hasPermissions = false;

    // bool authorized = false;
    // if (!hasPermissions) {
    //   // requesting access to the data types before reading them
    //   try {
    //     authorized =
    //         await health.requestAuthorization(types, permissions: permissions);
    //   } catch (error) {
    //     print("Exception in authorize: $error");
    //   }
    // }

    setState(() {
      _spinner = true;
    });
    // health.requestAuthorization(types).catchError((error, stackTrace) => print(error));
// requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);
    health.hasPermissions(types);

    var now = DateTime.now();

    try {
      await health.getHealthDataFromTypes(
          now.subtract(Duration(days: 1)), now, types);
    } catch (error) {
      print(error);
    }

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(Duration(days: 1)), now, types);
    _healthDataList.addAll(
        (healthData.length < 100) ? healthData : healthData.sublist(0, 100));

    bool isAvail = health.isDataTypeAvailable(HealthDataType.STEPS);

    // _activityList.addAll()

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(
        now.subtract(Duration(days: 1)), now);
    STEPS = steps.toString();
    Map map = {"key": "Steps", "value": STEPS, "unit": "Steps"};
    dataList.add(map);

    print("Steps ${steps.toString()}  ${isAvail}");
    // _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

    // print the results
    _healthDataList.forEach((x) {
      if (x.platform.toString().contains("ANDROID")) {
        platformName = "android";
      } else {
        platformName = "ios";
      }
      print("Steps: ${x.platform}");
    });
    _healthDataList.forEach((x) {
      print("Steps: ${x.value} ${x.type.name} ${x.unitString} ${x.platform}");
    });
    for (int i = 0; i < _healthDataList.length; i++) {
      if (_healthDataList[i].typeString == "HEART_RATE") {
        HEART_RATE = _healthDataList[i].value.toString();
        Map map = {
          "key": "Heart Rate",
          "value": HEART_RATE,
          "unit": _healthDataList[i].unitString.toString()
        };
        dataList.add(map);
      }
      if (_healthDataList[i].typeString == "SLEEP_ASLEEP") {
        SLEEP_ASLEEP = _healthDataList[i].value.toString();
        final startIndex = SLEEP_ASLEEP.indexOf(".");
        SLEEP_ASLEEP = SLEEP_ASLEEP.substring(0, startIndex);
        Map map = {
          "key": "Sleep Time",
          "value": SLEEP_ASLEEP,
          "unit": _healthDataList[i].unitString.toString()
        };
        dataList.add(map);
      }
      if (_healthDataList[i].typeString == "BLOOD_OXYGEN") {
        if (_healthDataList[i].platform.toString().contains("IOS")) {
          BLOOD_OXYGEN = _healthDataList[i].value.toString();
          final startIndex = BLOOD_OXYGEN.indexOf(".");
          BLOOD_OXYGEN = SLEEP_ASLEEP.substring(startIndex);
        } else {
          BLOOD_OXYGEN = _healthDataList[i].value.toString();
        }
        Map map = {
          "key": "Blood Oxygen",
          "value": BLOOD_OXYGEN,
          "unit": _healthDataList[i].unitString.toString()
        };
        dataList.add(map);
      }
      if (_healthDataList[i].typeString == "ACTIVE_ENERGY_BURNED") {
        ACTIVE_ENERGY_BURNED = _healthDataList[i].value.toString();
        final startIndex = ACTIVE_ENERGY_BURNED.indexOf(".");
        ACTIVE_ENERGY_BURNED = ACTIVE_ENERGY_BURNED.substring(0, startIndex);
        Map map = {
          "key": "Calories Burned",
          "value": ACTIVE_ENERGY_BURNED,
          "unit": _healthDataList[i].unitString.toString()
        };
        dataList.add(map);

        break;
      }
      setState(() => _spinner = false);
    }
    addWatchData();
  }

  String convertMinutesToHoursMinutes(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = remainingMinutes.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _spinner
          ? Center(
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(child: CircularProgressIndicator())),
            )
          : ListView(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(blueColor),
                        ))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(35.0, 5.0, 10.0, 5.0),
                    child: Text(
                      "Watch",
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
                    padding: const EdgeInsets.fromLTRB(35.0, 2.5, 10.0, 2.5),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: stepsData(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: heartRate(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: oxyLevel(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: caloriesBurned(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: sleepLevel(context),
                ),
              ],

              // Text("${convertMinutesToHoursMinutes(150)}"),
              // Center(
              //   child: Text("HEART_RATE:  ${HEART_RATE} bpm",
              //       style: TextStyle(fontSize: 18)),
              // ),
              // Center(
              //   child: Text("SLEEP_ASLEEP:  ${SLEEP_ASLEEP} min",
              //       style: TextStyle(fontSize: 18)),
              // ),
              // Center(
              //   child: Text("BLOOD_OXYGEN:  ${BLOOD_OXYGEN} Spo2%",
              //       style: TextStyle(fontSize: 18)),
              // ),
              // Center(
              //   child: Text("ACTIVE_ENERGY_BURNED:  ${ACTIVE_ENERGY_BURNED} kcal",
              //       style: TextStyle(fontSize: 18)),
              // ),
              // Center(child: Text("STEPS:  ${STEPS}", style: TextStyle(fontSize: 18)))
            ),
    );
  }

  SizedBox sleepLevel(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
            //<-- SEE HERE
            side: BorderSide(
              color: Color(blueColor),
            ),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/Images/sleep.png")),
                  ),
                  Text("Sleep",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${(SLEEP_ASLEEP)} min",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    ),
                    // Text("${convertMinutesToHoursMinutes(int.parse(SLEEP_ASLEEP))}"),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  SizedBox oxyLevel(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
            //<-- SEE HERE
            side: BorderSide(
              color: Color(blueColor),
            ),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/Images/o_level.png")),
                  ),
                  Text("Blood Oxygen",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${BLOOD_OXYGEN} Spo2%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  SizedBox heartRate(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
            //<-- SEE HERE
            side: BorderSide(
              color: Color(blueColor),
            ),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/Images/heart_rate.png")),
                  ),
                  Text("Heart Rate",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${HEART_RATE} bpm",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  SizedBox caloriesBurned(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
            //<-- SEE HERE
            side: BorderSide(
              color: Color(blueColor),
            ),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/Images/calories_burned.png")),
                  ),
                  Text("Calories Burned",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${ACTIVE_ENERGY_BURNED} kcal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  SizedBox stepsData(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
            //<-- SEE HERE
            side: BorderSide(
              color: Color(blueColor),
            ),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/Images/steps.png")),
                  ),
                  Text("Steps",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("${STEPS}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  String getCurrentDate() {
    var date = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM dd,yyyy');
    // var dateParse = DateTime.parse(date);

    // var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formatter.format(date);
  }
}
