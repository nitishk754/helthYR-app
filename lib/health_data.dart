import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthData extends StatefulWidget {
  const HealthData({super.key});

  @override
  State<HealthData> createState() => _HealthDataState();
}

class _HealthDataState extends State<HealthData> {
  // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  List<HealthDataPoint> _healthDataList = [];
  List<HealthWorkoutActivityType> _activityList = [];
  bool _spinner = false;

  // define the types to get
  static var types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  var HEART_RATE = "0 bpm";
  var SLEEP_ASLEEP = "0 min";
  var BLOOD_OXYGEN = "0 Spo2%";
  var ACTIVE_ENERGY_BURNED ="0 kcal";
  var STEPS ="0";

  // var actTyp = [
  //   HealthWorkoutActivityType.WALKING,
  //   HealthWorkoutActivityType.BIKING
  // ];

  @override
  void initState() {
    super.initState();
    getHealthData();
  }

  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  Future<void> getHealthData() async {
    await Permission.activityRecognition.request();

    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }

    setState(() {
      _spinner = true;
    });
// requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);
    health.hasPermissions(types);

    var now = DateTime.now();

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
        now.subtract(const Duration(days: 7)), now);
    STEPS = steps.toString();
    print("Steps ${steps.toString()}  ${isAvail}");
    // _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

    // print the results
    _healthDataList.forEach((x) {
      print("Steps: ${x.platform}");
    });
    _healthDataList.forEach((x) {
      print("Steps: ${x.value} ${x.type.name}");
    });
    for (int i = 0; i < _healthDataList.length; i++) {
      
      if (_healthDataList[i].typeString == "HEART_RATE") {
        HEART_RATE = _healthDataList[i].value.toString();
      }
      if (_healthDataList[i].typeString == "SLEEP_ASLEEP") {
        SLEEP_ASLEEP = _healthDataList[i].value.toString();
      }
      if (_healthDataList[i].typeString == "BLOOD_OXYGEN") {
        BLOOD_OXYGEN = _healthDataList[i].value.toString();
      }
      if (_healthDataList[i].typeString == "ACTIVE_ENERGY_BURNED") {
        ACTIVE_ENERGY_BURNED = _healthDataList[i].value.toString();
        setState(() => _spinner = false);

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _spinner
          ? SizedBox(
              width: 30,
              height: 40,
              child: Center(child: CircularProgressIndicator()))
          : Center(
              child: ListView(
                children: [
                  // Text("BLOOD_PRESSURE_SYSTOLIC:  ${BLOOD_PRESSURE_SYSTOLIC} mm hg",style: TextStyle(fontSize: 18)),
                  // Text("BLOOD_PRESSURE_DIASTOLIC:  ${BLOOD_PRESSURE_DIASTOLIC} mm hg" ,style: TextStyle(fontSize: 18)),
                  Text("HEART_RATE:  ${HEART_RATE} bpm",
                      style: TextStyle(fontSize: 18)),
                  Text("SLEEP_ASLEEP:  ${SLEEP_ASLEEP} min",
                      style: TextStyle(fontSize: 18)),
                  Text("BLOOD_OXYGEN:  ${BLOOD_OXYGEN} Spo2%",
                      style: TextStyle(fontSize: 18)),
                  Text("ACTIVE_ENERGY_BURNED:  ${ACTIVE_ENERGY_BURNED} kcal",
                      style: TextStyle(fontSize: 18)),
                  Text("STEPS:  ${STEPS}", style: TextStyle(fontSize: 18))
                ],
              ),
            ),
    );
  }
}
