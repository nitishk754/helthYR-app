import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  final List<String> items = [
    'Normal',
    'High',
  ];
  String? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 1, vsync: this);
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
                "Activities",
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
            height: 50,
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
                      height: 130,
                      width: 150,
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
                            child: Text(
                              "3000",
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
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 0.0),
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
                                          size: 40,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Running",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "min",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(orangeShade)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 60,
                                              height: 35,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: TextFormField(
                                                  maxLength: 4,
                                                  textAlign: TextAlign.center,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      filled:
                                                          true, //<-- SEE HERE
                                                      fillColor: Colors.white,
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      width:
                                                                          0.1)),
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
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 0.0, 8.0, 0.0),
                                            child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                    //                              color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color:
                                                            Color(blueColor))),
                                                child: Text(
                                                  "Intensity",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
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
