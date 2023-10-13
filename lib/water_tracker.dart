import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:intl/intl.dart';

import 'dashboard_screen.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  bool _isLoading = false;
  int waterIntake = 1;
  String glassesToTake = "";
  String todayIntake = "";

  List<Map<String, dynamic>> _graphData = [
    {
      'id': 'Bar',
      'data': []
      // 'data': [
      //   {'domain': 'Mon', 'measure': 9},
      //   {'domain': 'Tue', 'measure': 1},
      //   {'domain': 'Wed', 'measure': 6}
      // ],
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    _pastSevenDaysGraph();
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }

  _addWaterIntake() async {
    setState(() => _isLoading = true);

    await ApiService().addWaterIntake(waterIntake.toString()).then((value) {
      var res = value["data"];
      if (res["status"] == "success") {
        _pastSevenDaysGraph();
      } else {
        setState(() {
          _isLoading = false;
        });
      }

      // final snackBar = SnackBar(content: Text(res["message"]));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _pastSevenDaysGraph() async {
    setState(() => _isLoading = true);
    var originalGraphData = [];
    await ApiService()
        .getSevenDaysWaterIntake(waterIntake.toString())
        .then((value) {
      var res = value["data"]["data"];
      glassesToTake = res['today']['glass_to_take'].toString();
      todayIntake = res['today']['today_intake'].toString();
      for (var i = 0; i < res['graph_data'].length; i++) {
        originalGraphData.add({
          'domain': res['graph_data'][i]["intake_weekday"],
          'measure': res['graph_data'][i]["total_intake"]
        });
      }
      setState(() {
        _graphData[0]["data"] = originalGraphData.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
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
                    ))),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 10.0, 0.0),
              child: Text(
                "Water Tracker",
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
          SizedBox(height: 45, child: Card(child: Center(child: tabbar()))),
          SizedBox(
            height: 40,
          ),
          Builder(builder: (_) {
            if (tabIndex == 0) {
              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Card(
                        elevation: 2.5,
                        shape: RoundedRectangleBorder(
                            //<-- SEE HERE
                            side: BorderSide(
                              color: Color(blueColor),
                            ),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: 200,
                          height: 180,
                          child: Center(
                            child: Stack(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        visible: ((glassesToTake == "0")||(glassesToTake == "8"))
                                            ? false
                                            : true,
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
                                              size: 30,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0.0, 45.0, 0.0, 45.0),
                                              child: SizedBox(
                                                  width: 80,
                                                  height: 120,
                                                  child: Image(
                                                      image: AssetImage(
                                                          "assets/Images/waterDashboard.png"))),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Visibility(
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        visible:
                                            (todayIntake == "8") ? false : true,
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
                                              size: 30,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: (glassesToTake == "0")
                                                ? false
                                                : true,
                                            child: Text("$glassesToTake ",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(orangeShade))),
                                          ),
                                          Text(
                                              (glassesToTake == "0")
                                                  ? "Done for the day"
                                                  : " more glasses to go",
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500))
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35.0, 20.0, 10.0, 0.0),
                      child: Text(
                        "Past Seven Days",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(blueColor),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 240,
                          child: SizedBox(
                            width: 10,
                            height: 240,
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : DChartBar(
                                    data: _graphData,
                                    domainLabelPaddingToAxisLine: 20,
                                    axisLineTick: 2,
                                    axisLinePointTick: 2,
                                    axisLinePointWidth: 10,
                                    axisLineColor: Color(blueColor),
                                    measureLabelPaddingToAxisLine: 16,
                                    barColor: (barData, index, id) =>
                                        Color(blueColor),
                                    showBarValue: true,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
    // var dateParse = DateTime.parse(date);

    // var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formatter.format(date);
  }
}
