import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_wellness/recipe_details.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'constants/colors.dart';

class MealPlan extends StatefulWidget {
  const MealPlan({super.key});

  @override
  State<MealPlan> createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController;
  bool _spinner = false;
  Map mealPlanData = {};
  Map weeklyMealPlanData = {};
  List allResult = [];
  // bool _isMealAdded = false;
  bool _customTileExpanded = false;
  List<bool> isMealAdded = [];
  List weekPlan = [];
  List<double> caloryVal = [];
  double sumCalVal = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _meals('today');
  }

  _meals(String range) async {
    setState(() => _spinner = true);
    await ApiService().meals(range).then((value) {
      setState(() {
        mealPlanData = {};
        allResult = [];
        var res = value["data"];
        _spinner = false;
        if (!res.containsKey('errors')) {
          if (res["status"] == "success") {
            setState(() => mealPlanData = res["data"]);
          }
        }
        mealPlanData.removeWhere((key, value) => value == null);
        mealPlanData.keys.forEach((key) {
          if (mealPlanData[key].length > 0) {
            allResult
                .add({"meal_duration": key, "meal_data": mealPlanData[key]});
          }
        });

        final snackBar = SnackBar(content: Text(res["message"]));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  getWeeklyMealPlanData() async {
    setState(() => _spinner = true);
    await ApiService().getWeeklyMeals().then((value) {
      setState(() {
        var res = value["data"];
        _spinner = false;
        if (!res.containsKey('errors')) {
          if (res["status"] == "success") {
            setState(() => weeklyMealPlanData = value["data"]);
          }
        }
        // weeklyMealPlanData.removeWhere((key, value) => value == null);
        // weeklyMealPlanData.keys.forEach((key) {
        //   allResult.add({"meal_duration": key, "meal_data": mealPlanData[key]});
        // });
        for (int i = 0; i < weeklyMealPlanData['data'].length; i++) {
          sumCalVal = 0.0;
          for (int j = 0;
              j < weeklyMealPlanData['data'][i]['mealData'].length;
              j++) {
            if (weeklyMealPlanData['data'][i]['mealData'][j]['data'].length >
                0) {
                  sumCalVal = sumCalVal + double.parse(weeklyMealPlanData['data'][i]['mealData']
                  [j]['data'][0]['total_calories']);
              // caloryVal.add(double.parse(weeklyMealPlanData['data'][i]['mealData']
              //     [j]['data'][0]['recepie']['recipe_nutritions']['calories']));
            }
          }
          caloryVal.add(sumCalVal);
        }
        // double.parse(weeklyMealPlanData['data'][index]['mealData'][index1]['data'][0]['recepie']['recipe_nutritions']['calories']).toStringAsFixed(2)

        final snackBar = SnackBar(content: Text(res["message"]));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  saveMeals(String mealId, String recipeId, String mealType) async {
    await ApiService().saveMeals(mealId, recipeId, mealType).then((value) {
      var res = value["data"];
      // setState(() => _spinner = false);
      if (!res.containsKey('errors')) {
        if (res["status"] == "success") {
          _meals('today');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en');
    return Scaffold(
      body: ListView(
        // physics: NeverScrollableScrollPhysics(),
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
              padding: const EdgeInsets.fromLTRB(35.0, 5.0, 10.0, 5.0),
              child: Text(
                "Meal Plan",
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
          SizedBox(
            height: 60,
            child: Card(
              child: HorizontalCalendar(
                date: DateTime.now(),
                textColor: Colors.black45,
                backgroundColor: Colors.white,
                selectedColor: Colors.blue,
                showMonth: false,
                initialDate: DateTime(2023),
                onDateSelected: (date) {
                  if (date.isAfter(DateTime.now())) {
                    Fluttertoast.showToast(
                        msg: 'You have selected a future date');

                    return;
                  } else {
                    print(date.toString());
                  }
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
                  : ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        for (var i = 0; i < allResult.length; i++) ...[
                          mealWidget(allResult[i]),
                        ]
                      ],
                    );
            } else {
              return _spinner
                  ? Center(child: CircularProgressIndicator())
                  : weeklyMealPlan();
            }
          })
        ],
      ),
    );
  }

  ListView weeklyMealPlan() {
    int counter = 0;
    bool isVisible = true;
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: weeklyMealPlanData['data'].length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: Text(
                "${weeklyMealPlanData['data'][index]['weekDay']} ( ${weeklyMealPlanData['data'][index]['date']} )",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            subtitle: Text("${caloryVal[index].roundToDouble().round()} cal",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600)),
            trailing: Icon(
              _customTileExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
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
                  itemCount:
                      weeklyMealPlanData['data'][index]['mealData'].length,
                  itemBuilder: (BuildContext context, int index1) {
                    return Visibility(
                      visible: (weeklyMealPlanData['data'][index]['mealData']
                                      [index1]['data']
                                  .length >
                              0)
                          ? true
                          : false,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 2.5, 20.0, 2.5),
                            child: Text(
                                "${weeklyMealPlanData['data'][index]['mealData'][index1]['meal_type']}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 2.5),
                            child: Text(
                              (weeklyMealPlanData['data'][index]['mealData']
                                              [index1]['data']
                                          .length >
                                      0)
                                  ? "${double.parse(weeklyMealPlanData['data'][index]['mealData'][index1]['data'][0]['total_calories']).roundToDouble().round()} Cal"
                                  : "0 Cal",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(orangeShade)),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: weeklyMealPlanData['data'][index]
                                      ['mealData'][index1]['data']
                                  .length,
                              itemBuilder: (BuildContext context, int index2) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 2.5, 10.0, 2.5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RecipeDetails(
                                                  "${weeklyMealPlanData['data'][index]['mealData'][index1]['data'][index2]['recipe_id']}")));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          12.0, 5.5, 12.0, 5.5),
                                      height: 65,
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
                                                                "${weeklyMealPlanData['data'][index]['mealData'][index1]['data'][index2]['recepie']['name']}",
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
                                                          "${double.parse(weeklyMealPlanData['data'][index]['mealData'][index1]['data'][index2]['total_calories']).roundToDouble().round()} Cal",
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
                    );
                  })
            ],
          );
        });
  }

  ListView mealWidget(Map _data) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 2.5, 20.0, 2.5),
          child: Text("${capitalizeFirstLetter(_data['meal_duration'])}",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 2.5),
          child: Text(
            "${double.parse(_data["meal_data"][0]['total_calories']).roundToDouble().round()} Cals",
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(orangeShade)),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: _data["meal_data"].length,
            itemBuilder: (BuildContext context, int index) {
              isMealAdded.add(false);
              Map? mealData = _data["meal_data"][index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 2.5),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetails("${mealData?['recipe_id']}")));
                    });
                  },
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(12.0, 5.5, 12.0, 5.5),
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: SizedBox(
                                    width: 65,
                                    height: 65,
                                    child: Image(
                                        image: AssetImage(
                                            "assets/Images/breakfast.jpeg")),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          //width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 1.0),
                                            child: Container(
                                              // width: 150,
                                              child: Text(
                                                "${mealData?['recepie']['name']}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                            "prep time: ${mealData?['recepie']['prep_time']} mins",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Text(
                                              "cook time: ${mealData?['recepie']['cook_time']} mins",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500)),
                                        )
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
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                          "${double.parse(mealData?['total_calories']).roundToDouble().round()} Cals"
                                          // "${mealData?['recipe_nutritions']['calories']} Cal"
                                          ,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Color(orangeShade),
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          if ((mealData?['is_taken'] == 1)) {
                                            Fluttertoast.showToast(
                                                msg: "Meal Already Added");
                                          } else {
                                            saveMeals(
                                                "${mealData?['id']}",
                                                "${mealData?['recipe_id']}",
                                                "${mealData?['meal_type']}");
                                          }

                                          // setState(() {
                                          //   isMealAdded[index]
                                          //       ? isMealAdded[index] = false
                                          //       : isMealAdded[index] = true;
                                          // });
                                        },
                                        child: Icon(
                                          (mealData?['is_taken'] == 1)
                                              ? Icons.check_circle
                                              : Icons.add_circle,
                                          size: 25,
                                          color: (mealData?['is_taken'] == 1)
                                              ? Colors.green
                                              : Color(blueColor),
                                        ),
                                      )),
                                ],
                              ))
                        ],
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
          if (tabIndex == 0) {
            _meals('today');
          } else {
            getWeeklyMealPlanData();
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
              "Weekly",
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

String capitalizeFirstLetter(String s) =>
    (s.isNotEmpty ?? false) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
