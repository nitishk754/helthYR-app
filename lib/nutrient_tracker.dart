import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_wellness/recipe_details.dart';
import 'package:health_wellness/services/api_services.dart';
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
  late TooltipBehavior _tooltip;
  bool _customTileExpanded = false;
  bool _spinner = false;
  Map nutrientData = {};
  List<BarNutrientData> barData = [];
  // late List<_ChartData> data;
  // late TooltipBehavior _tooltip;

  @override
  void initState() {
    // TODO: implement initState
    // _nutData = getNutrientData();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    getCurrentDate();
    getNutrientTracker('today');
  }

  Future<void> getNutrientTracker(String range) async {
    setState(() => _spinner = true);
    await ApiService().getNutrientData(range).then((value) {
      var res = value["data"];
      setState(() => _spinner = false);
      if (res["status"] == "success") {
        setState(() {
          nutrientData = res["data"];
          if (nutrientData['graph_data'].containsKey('bar_chart')) {
            print("condTrue");
            for (int i = 0;
                i < nutrientData['graph_data']['bar_chart'].length;
                i++) {
              barData.add(BarNutrientData(
                  nutrientData['graph_data']['bar_chart'][i]['meal_day'],
                  double.parse((nutrientData['graph_data']['bar_chart'][i]
                          ["total_calories"])
                      .roundToDouble()
                      .round()
                      .toString())));
            }
          } else {
            print("condFalse");
          }
        });
      }
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
              return _spinner
                  ? Center(child: CircularProgressIndicator())
                  : (nutrientData["graph_data"]["toal_calories"] == 0)
                      ? Center(
                          child: Container(
                            child: Text(
                              "No Meal Added To The Nutritient Tracker",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : caloriesCount();
            } else if (tabIndex == 1) {
              return _spinner
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
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
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                width: 310,
                                height: 250,
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    // primaryYAxis: NumericAxis(
                                    //     minimum: 0, maximum: 40, interval: 10),
                                    series: <ChartSeries<BarNutrientData,
                                        String>>[
                                      ColumnSeries<BarNutrientData, String>(
                                          dataSource: barData,
                                          xValueMapper:
                                              (BarNutrientData barData, _) =>
                                                  barData.weekDay,
                                          yValueMapper:
                                              (BarNutrientData barData, _) =>
                                                  barData.value,
                                          // name: 'Gold',
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: Color(blueColor))
                                    ]),
                              ),
                            ))),
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
                        Visibility(
                            visible: (nutrientData.containsKey("food_log"))
                                ? false
                                : true,
                            child: Center(
                                child: Text(
                              "No Meal Added To The Tracker",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ))),
                        Visibility(
                          visible: (nutrientData.containsKey("food_log"))
                              ? true
                              : false,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: (nutrientData.containsKey("food_log"))
                                  ? nutrientData["food_log"].length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 5.0, 20.0, 5.0),
                                    child: Card(
                                      child: ExpansionTile(
                                        title: Text(
                                            "${nutrientData["food_log"][index]["meal_type"]}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                        subtitle: Text(
                                            "${(nutrientData["food_log"][index]["total_calories"]).roundToDouble().round()}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w600)),
                                        trailing: Icon(
                                          _customTileExpanded
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                        ),
                                        onExpansionChanged: (bool expanded) {
                                          setState(() {
                                            _customTileExpanded = expanded;
                                          });
                                        },
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  nutrientData["food_log"]
                                                              [index]["item"]
                                                          ["items"]
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index1) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10.0, 2.5, 10.0, 2.5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        print(
                                                            "recipeId: ${nutrientData["food_log"][index]["item"]["items"][index1]["recipe_details"]["id"]}");
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    RecipeDetails(
                                                                        "${nutrientData["food_log"][index]["item"]["items"][index1]["recipe_details"]["id"]}")));
                                                      });
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              12.0,
                                                              5.5,
                                                              12.0,
                                                              5.5),
                                                      height: 70,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            flex: 1,
                                                            child: Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  child:
                                                                      SizedBox(
                                                                    width: 55,
                                                                    height: 55,
                                                                    child: Image(
                                                                        image: AssetImage(
                                                                            "assets/Images/breakfast.jpeg")),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            7.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          //width: MediaQuery.of(context).size.width,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 1.0),
                                                                            child:
                                                                                Container(
                                                                              // width: 150,
                                                                              child: Text(
                                                                                "${nutrientData["food_log"][index]["item"]["items"][index1]["recipe_details"]["name"]}",
                                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                              flex: 0,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0,
                                                                          right:
                                                                              8.0),
                                                                      child: Text(
                                                                          "${double.parse((nutrientData["food_log"][index]["item"]["items"][index1]["calories"])).roundToDouble().round()} Cals",
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              color: Color(orangeShade),
                                                                              fontWeight: FontWeight.w600)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })
                                        ],
                                      ),
                                    ));
                              }),
                        )
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
                width: 320,
                height: 250,
                child: Stack(
                  children: [
                    Center(
                        child: SfCircularChart(
                      tooltipBehavior: _tooltip,
                      annotations: <CircularChartAnnotation>[
                        CircularChartAnnotation(
                            height: '90%',
                            width: '90%',
                            widget: PhysicalModel(
                              shape: BoxShape.circle,
                              elevation: 0,
                              color: Colors.white,
                              child: Container(),
                            )),
                        CircularChartAnnotation(
                            widget: Text(
                                "${nutrientData["graph_data"]["toal_calories"].roundToDouble().round()}",
                                style: TextStyle(
                                  color: Color(orangeShade),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                )))
                      ],
                      series: <CircularSeries>[
                        DoughnutSeries<NutrientData, String>(
                          radius: "85",
                            animationDuration: 1000.0,
                            explode: true,
                            explodeGesture: ActivationMode.singleTap,
                            dataSource: [
                              NutrientData(
                                  nutrientData['graph_data']['dounts'][0]
                                      ["key"],
                                  double.parse((nutrientData['graph_data']
                                          ['dounts'][0]["value"])
                                      .roundToDouble()
                                      .round()
                                      .toString()),
                                  Color(donutBlueShadeDark)),
                              NutrientData(
                                  nutrientData['graph_data']['dounts'][1]
                                      ["key"],
                                  double.parse((nutrientData['graph_data']
                                          ['dounts'][1]["value"])
                                      .roundToDouble()
                                      .round()
                                      .toString()),
                                  Color(donutBlueShadeMed)),
                              NutrientData(
                                  nutrientData['graph_data']['dounts'][2]
                                      ["key"],
                                  double.parse((nutrientData['graph_data']
                                          ['dounts'][2]["value"])
                                      .roundToDouble()
                                      .round()
                                      .toString()),
                                  Color(donutBlueShadeLite)),
                            ],
                            pointColorMapper: (NutrientData data, _) =>
                                data.color,
                            xValueMapper: (NutrientData data, _) =>
                                data.nutrient,
                            yValueMapper: (NutrientData data, _) => data.value,
                            dataLabelMapper: (NutrientData data, _) =>
                                data.nutrient,
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                connectorLineSettings:
                                    ConnectorLineSettings(width: 3.0,length: "8%"),
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)))
                      ],
                    )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showFoodDialog();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "Details",
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
        Visibility(
          visible: (nutrientData.containsKey("food_log")) ? true : false,
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: (nutrientData.containsKey("food_log"))
                  ? nutrientData["food_log"].length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: Card(
                      child: ExpansionTile(
                        title: Text(
                            "${nutrientData["food_log"][index]["meal_type"]}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            "${(nutrientData["food_log"][index]["total_calories"]).roundToDouble().round()}",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600)),
                        trailing: Icon(
                          _customTileExpanded
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _customTileExpanded = expanded;
                          });
                        },
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: nutrientData["food_log"][index]["item"]
                                      ["items"]
                                  .length,
                              itemBuilder: (BuildContext context, int index1) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 2.5, 10.0, 2.5),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        print(
                                            "recipeId: ${nutrientData["food_log"][index]["item"]["items"][index1]["recipe_details"]["id"]}");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => RecipeDetails(
                                                    "${nutrientData["food_log"][index]["item"]["items"][index1]["recipe_details"]["id"]}")));
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          12.0, 5.5, 12.0, 5.5),
                                      height: 70,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  child: SizedBox(
                                                    width: 55,
                                                    height: 55,
                                                    child: Image(
                                                        image: AssetImage(
                                                            "assets/Images/breakfast.jpeg")),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          //width: MediaQuery.of(context).size.width,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        1.0),
                                                            child: Container(
                                                              // width: 150,
                                                              child: Text(
                                                                "${nutrientData["food_log"][index]["item"]["items"][index1]["recipe_details"]["name"]}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                              flex: 0,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                          "${double.parse((nutrientData["food_log"][index]["item"]["items"][index1]["calories"])).roundToDouble().round()} Cals",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(
                                                                  orangeShade),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    )
                    // InkWell(
                    //   onTap: () {
                    //     setState(() {
                    //       if (!isCardSelected) {
                    //         isCardSelected = true;
                    //       } else {
                    //         isCardSelected = false;
                    //       }
                    //     });
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 60,
                    //     child: Card(
                    //       shape: isCardSelected
                    //           ? new RoundedRectangleBorder(
                    //               side: new BorderSide(
                    //                   color: Colors.blue, width: 2.0),
                    //               borderRadius: BorderRadius.circular(5.0))
                    //           : new RoundedRectangleBorder(
                    //               side: new BorderSide(
                    //                   color: Colors.white, width: 2.0),
                    //               borderRadius: BorderRadius.circular(5.0)),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               flex: 0,
                    //               child: SizedBox(
                    //                   width: 34,
                    //                   height: 34,
                    //                   child: Image(
                    //                       image: AssetImage(
                    //                           "assets/Images/breakfast.png"))),
                    //             ),
                    //             Expanded(
                    //               flex: 1,
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text('Breakfast',
                    //                     style: TextStyle(
                    //                       color: Colors.black87,
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 18,
                    //                     )),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex: 0,
                    //               child: Text('110 Cals',
                    //                   style: TextStyle(
                    //                     color: Color(orangeShade),
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 14,
                    //                   )),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    );
              }),
        )
      ],
    );
  }

  Future<dynamic> showFoodDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Macros",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),
             shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                     ),
              // backgroundColor: Colors.transparent,
              // insetPadding: EdgeInsets.all(10),
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                 
                  // padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: ListView.builder(
                    itemCount: nutrientData['graph_data']['dounts'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${nutrientData['graph_data']['dounts'][index]['key']}',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 21,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Text(
                                  '${(nutrientData['graph_data']['dounts'][index]['value']).roundToDouble().round()} Cals',
                                  style: TextStyle(
                                    color: Color(orangeShade),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  )));
        });
  }

  TabBar tabbar() {
    return TabBar(
      onTap: (value) {
        // index = value
        // print(value.toString());
        setState(() {
          tabIndex = value;
          if (tabIndex == 0) {
            getNutrientTracker('today');
          } else {
            getNutrientTracker('week');
          }
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

  // List<NutrientData> getNutrientData() {
  //   final List<NutrientData> nutrientData = [
  //     NutrientData('Carbs', 500),
  //     NutrientData('Protien', 120),
  //     NutrientData('Fats', 80),
  //   ];
  //   return nutrientData;
  // }
}

class NutrientData {
  NutrientData(this.nutrient, this.value, this.color);

  final String nutrient;
  final double value;
  final Color color;
}

class BarNutrientData {
  BarNutrientData(this.weekDay, this.value);

  final String weekDay;
  final double value;
}
