import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 1, vsync: this);
    _meals();
  }

  _meals() async {
    setState(() =>_spinner = true);
    await ApiService().meals().then((value) {
      var res = value["data"];
      setState(() => _spinner = false);
      print(res);
      if (!res.containsKey('errors')) {
        if(res["data"].length > 0){
          //setState(() => caloriesBurned = res["data"][0]["calories_burned"].toString());
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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 30,
                  color: Color(blueColor),
                )),
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
                  fontSize: 30,
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
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
                onDateSelected: (date) {
                  print(date.toString());
                },
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Card(child: Center(child: tabbar())),
          SizedBox(
            height: 25,
          ),
          Builder(builder: (_) {
            if (tabIndex == 0) {
              return ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  mealWidget(),
                  mealWidget(),
                  mealWidget(),
                  mealWidget(),
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

  ListView mealWidget() {
    return ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 2.5, 20.0, 2.5),
                      child: Text("Breakfast",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 2.5),
                      child: Text(
                        "400 cal",
                        style: TextStyle(
                            fontSize: 15, color: Color(orangeShade)),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 2.5, 20.0, 2.5),
                            child: Card(
                              child: Stack(children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      12.0, 5.5, 12.0, 5.5),
                                  height: 90,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(7),
                                        child: SizedBox(
                                          width: 65,
                                          height: 65,
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/Images/breakfast.jpeg")),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "2 Egg",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text("400 Cal",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                orangeShade),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child:
                                                  Text("prep time: 10 mins"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child:
                                                  Text("cook time: 35 mins"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 90,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:11.0),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.add_circle,size: 30,color: Color(blueColor),)),
                                  ),
                                )
                              ]),
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
              style: TextStyle(fontSize: 20),
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
