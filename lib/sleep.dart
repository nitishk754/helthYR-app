import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'constants/colors.dart';

class SleepData extends StatefulWidget {
  const SleepData({super.key});

  @override
  State<SleepData> createState() => _SleepDataState();
}

class _SleepDataState extends State<SleepData>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  late List<_ChartData> data = [];
  late TooltipBehavior _tooltip;
  bool _spinner = false;
  int todaySleepVal = 0;
  double maxSleep =0.0;

  @override
  void initState() {
    // data = [
    //   _ChartData('MON', 510),
    //   _ChartData('TUE', 570),
    //   _ChartData('WED', 620),
    //   _ChartData('THU', 400),
    //   _ChartData('FRI', 420),
    //   _ChartData('SAT', 560),
    //   _ChartData('SUN', 520)
    // ];
    _tooltip = TooltipBehavior(enable: true);
    tabController = TabController(length: 1, vsync: this);
    super.initState();
    getSleepData();
  }

  Future<void> getSleepData() async {
    setState(() => _spinner = true);
    await ApiService().getSevenSleepData().then((value) {
      var res = value["data"];
      todaySleepVal = int.parse(res['data']['today_sleep'].toString());
      // _spinner = false;
      for (int i = 0; i < res['data']['week_sleep'].length; i++) {
        data.add(_ChartData(res['data']['week_sleep'][i]['activity_day'],
            double.parse((res['data']['week_sleep'][i]['total_sleep']).toString())));
            if(res['data']['week_sleep'].length>1){
               if(i+1<=res['data']['week_sleep'].length-1){
              if(double.parse((res['data']['week_sleep'][i]['total_sleep']).toString())>double.parse((res['data']['week_sleep'][i+1]['total_sleep']).toString())){
                maxSleep=double.parse((res['data']['week_sleep'][i]['total_sleep']).toString());
              }else{
                maxSleep=double.parse((res['data']['week_sleep'][i+1]['total_sleep']).toString());

              }
            }
            }else{
               maxSleep=double.parse((res['data']['week_sleep'][i]['total_sleep']).toString());
            }
      }

      setState(() {
        _spinner = false;
      });

      // final snackBar = SnackBar(content: Text(res["message"]));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: (_spinner)
          ? Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(child: CircularProgressIndicator()),
            )
          : ListView(
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
                      "Sleep",
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
                    height: 45, child: Card(child: Center(child: tabbar()))),
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
                            width: 200,
                            height: 180,
                            child: Card(
                              elevation: 2.5,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(blueColor),
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: Container()),
                                  Expanded(
                                    child: Padding(
                                       padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Center(
                                          child: Image(
                                        height: 75,
                                        width: 75,
                                        image: AssetImage(
                                            "assets/Images/sleep.png"),
                                      )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Text(
                                          "${convertMinutesToHoursMinutes(todaySleepVal)}",
                                          style: TextStyle(
                                              color: Color(orangeShade),
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                35.0, 20.0, 10.0, 0.0),
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
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(blueColor),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top:20.0,right: 20.0),
                              child: Container(
                                height: 240,
                                child: SizedBox(
                                    width: 10,
                                    height: 240,
                                    child: SfCartesianChart(
                                        primaryXAxis: CategoryAxis(
                                          title: AxisTitle(text: "Days")
                                        ),
                                        primaryYAxis: NumericAxis(
                                          title: AxisTitle(text: "Minutes"),
                                            minimum: 0,
                                            maximum: maxSleep,
                                            interval: 50),
                                        tooltipBehavior: _tooltip,
                                        series: <ChartSeries<_ChartData,
                                            String>>[
                                          ColumnSeries<_ChartData, String>(
                                              dataSource: data,
                                              xValueMapper:
                                                  (_ChartData data, _) =>
                                                      data.x,
                                              yValueMapper:
                                                  (_ChartData data, _) =>
                                                      data.y,
                                              name: 'Sleep',
                                              color: Color(blueColor))
                                        ])),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
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

  String convertMinutesToHoursMinutes(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = remainingMinutes.toString().padLeft(2, '0');
    return '${hoursStr}h ${minutesStr}m';
  }

  String getCurrentDate() {
    var date = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM dd,yyyy');
    // var dateParse = DateTime.parse(date);

    // var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    return formatter.format(date);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
