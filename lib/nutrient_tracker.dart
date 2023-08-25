import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'constants/colors.dart';

class NutrientTracker extends StatefulWidget {
  const NutrientTracker({super.key});

  @override
  State<NutrientTracker> createState() => _NutrientTrackerState();
}

class _NutrientTrackerState extends State<NutrientTracker>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  String dateVal = "";
  DateTime dateTime = DateTime.now();
  bool isCardSelected = false;
  late List<NutrientData> _nutData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nutData = getNutrientData();

    tabController = TabController(length: 2, vsync: this);
    getCurrentDate();
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
                "Nutrient Tracker",
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
              return caloriesCount();
            } else if (tabIndex == 1) {
              return caloriesCount();
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  ListView caloriesCount() {
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
                width: 310,
                height: 250,
                child: Stack(
                  children: [
                    Center(
                        child: SfCircularChart(
                      series: <CircularSeries>[
                        DoughnutSeries<NutrientData, String>(
                          dataSource: _nutData,
                          xValueMapper: (NutrientData data, _) => data.nutrient,
                          yValueMapper: (NutrientData data, _) => data.value,
                        )
                      ],
                    )
                        // AspectRatio(
                        //   aspectRatio: 20 / 12,
                        //   child: DChartPie(
                        //     donutWidth: 22,
                        //     data: [
                        //       {'domain': 'Carbs', 'measure': 28},
                        //       {'domain': 'Fat', 'measure': 27},
                        //       {'domain': 'Protein', 'measure': 20},
                        //     ],
                        //     fillColor: (pieData, index) {
                        //       switch (pieData['domain']) {
                        //         case 'Carbs':
                        //           return Colors.blue;
                        //         case 'Fat':
                        //           return Colors.blueAccent;
                        //         case 'Protein':
                        //           return Colors.lightBlue;
                        //         default:
                        //           return Colors.orange;
                        //       }
                        //     },
                        //     pieLabel: (pieData, index) {
                        //       return "${pieData['domain']}:\n${pieData['measure']}%";
                        //     },
                        //     labelPosition: PieLabelPosition.outside,
                        //     labelLinelength: 4.5,
                        //   ),
                        // ),
                        ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "1402",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(orangeShade),
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.all(10),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                            width: double.infinity,
                                            height: 300,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white),
                                            padding: EdgeInsets.fromLTRB(
                                                20, 50, 20, 20),
                                            child: ListView.builder(
                                              itemCount: 4,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0, 0.0, 20.0, 10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 0,
                                                        child: SizedBox(
                                                            width: 38,
                                                            height: 38,
                                                            child: Image(
                                                                image: AssetImage(
                                                                    "assets/Images/breakfast.png"))),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              'Breakfast',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 21,
                                                              )),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 0,
                                                        child: Text('110 Cals',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  orangeShade),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ))
                                      ],
                                    ));
                              });
                        });
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(orangeShade),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Food Log",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (!isCardSelected) {
                        isCardSelected = true;
                      } else {
                        isCardSelected = false;
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Card(
                      shape: isCardSelected
                          ? new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0))
                          : new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: SizedBox(
                                  width: 34,
                                  height: 34,
                                  child: Image(
                                      image: AssetImage(
                                          "assets/Images/breakfast.png"))),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Breakfast',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Text('110 Cals',
                                  style: TextStyle(
                                    color: Color(orangeShade),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
      ],
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
        Container(
          child: Tab(
            child: Text(
              "This Week",
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

  List<NutrientData> getNutrientData() {
    final List<NutrientData> nutrientData = [
      NutrientData('Carbs', 500),
      NutrientData('Protien', 120),
      NutrientData('Fats', 80),
    ];
    return nutrientData;
  }
}

class NutrientData {
  NutrientData(this.nutrient, this.value);

  final String nutrient;
  final double value;
}
