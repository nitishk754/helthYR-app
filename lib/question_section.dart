import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:health_wellness/custom_radio_button_2.dart';
import 'package:health_wellness/login.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:numberpicker/numberpicker.dart';

import 'custom_radio_button.dart';
import 'main.dart';
import 'model/question_model.dart';

class QuestionSection extends StatefulWidget {
  const QuestionSection({super.key});

  @override
  State<QuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  double _initial = 0.0;
  String _choice = '';
  String _weight = 'lbs';
  // String _goalWeight = 'kg';
  String _height = 'Ft';
  String _heightIn = 'In';
  double totalQuestions = 0.0;

  QuestionModel? questionModel;

  final currentWeightController = TextEditingController();
  final goalWeightController = TextEditingController();
  ScrollController _controllerScroll = new ScrollController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    questionModel = (await ApiService().getQuestion());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          _initial = 1.0 / questionModel!.data.data.length;
          totalQuestions = 1.0 / questionModel!.data.data.length;
        }));
  }

  String capitalize(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  int _currentAge = 23;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      backgroundColor: Color(0xFFF6F8F7),
      body: (questionModel == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView(
                  controller: _controllerScroll,
                  // shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 25),
                    Text(
                      "HELTHYR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(blueColor),
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 50, right: 50),
                      child: LinearProgressIndicator(
                        value: _initial,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Color(blueColor)),
                      ),
                    ),
                    ExpandablePageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller,
                      children: questionModel!.data.data.map((model) {
                        //
                        // debugPrint('qType ==> ${model.qTxt}');
                        return ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: [
                            SizedBox(height: 30),
                            (model.qType == "open-ended")
                                ? (model.qTxt.contains("Weight") ||
                                        model.qTxt.contains("weight"))
                                    ? SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: weightScreen(model))
                                    : (model.qTxt.contains("Tall") ||
                                            model.qTxt.contains("tall"))
                                        ? SingleChildScrollView(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            child: heightScreen(model))
                                        : Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: Text(
                                                  model.qTxt,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 25),
                                              NumberPicker(
                                                value: _currentAge,
                                                itemHeight: 60,
                                                // itemWidth: 100,
                                                textStyle: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                selectedTextStyle: TextStyle(
                                                    color: Color(orangeShade),
                                                    fontSize: 44,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                itemCount: 5,
                                                minValue: 12,
                                                maxValue: 65,
                                                onChanged: (value) {
                                                  setState(() =>
                                                      _currentAge = value);
                                                  userInput['${model.id}'] = {
                                                    "question": model.qTxt,
                                                    "question_id": model.id,
                                                    "answer_text": _currentAge
                                                  };
                                                },
                                              ),
                                            ],
                                          )
                                : (model.qType == "single-choice")
                                    ? selectOneTypeQuestions(model)
                                    : Center(child: Text(model.qTxt))
                          ],
                        );
                      }).toList()
                        ..removeAt(4),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(30.0, 5.0, 10.0, 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_initial != 0) {
                                    _initial = _initial - 0.20;
                                  }
                                });
                                controller.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              child: const Text(
                                '  Back  ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0)),
                                backgroundColor:
                                    Color.fromARGB(255, 184, 184, 184),
                                // onSurface:
                                //     Colors.transparent,
                                // shadowColor: Colors.red.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 5.0, 30.0, 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                print("weightValue: $_weight");
                                FocusManager.instance.primaryFocus?.unfocus();
                                var page = controller.page?.toInt() ?? 0;
                                var length = userInput.values.length;

                                debugPrint('page => $page, length => $length');
                                if (length > page) {
                                  if (goalWeightController.text == "" &&
                                      page == 3) {
                                    Fluttertoast.showToast(
                                        msg: 'Please enter your goal weight');
                                  } else if (page == 4 && length == 5) {
                                    Fluttertoast.showToast(
                                        msg: 'Please select your typical day');
                                  } else if (page == 5 && length == 6) {
                                    Fluttertoast.showToast(
                                        msg: 'Please select your diet follow ');
                                  } else {
                                    setState(() {
                                      if (_initial != 1.0) {
                                        _initial = _initial + 0.20;
                                      }
                                    });
                                    controller.nextPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    if (page == 5) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                                    }
                                  }
                                } else {
                                  switch (page) {
                                    case 0:
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please select your biological sex');
                                      break;
                                    case 1:
                                      Fluttertoast.showToast(
                                          msg: 'Please select your age');
                                      break;
                                    case 2:
                                      Fluttertoast.showToast(
                                          msg: 'Please enter your height');
                                      break;
                                    case 3:
                                      if (length < 5) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please enter your current weight');
                                        debugPrint("one");
                                        break;
                                      }
                                      // if (length<5) {
                                      //   Fluttertoast.showToast(
                                      //       msg:
                                      //           'Please enter your goal weight');
                                      //   debugPrint("two");
                                      //   // break;
                                      // }

                                      break;
                                    case 4:
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please select your typical day');
                                      break;
                                    case 5:
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please select your diet follow');
                                      break;
                                  }

                                  // if (questionModel!.data.data[page].qTxt
                                  //     .contains("Goal Weight")) {
                                  //   questionModel!.data.data.removeAt(page);

                                  //   switch (
                                  //       questionModel!.data.data[page].qType) {
                                  //     case "open-ended":
                                  //       if (questionModel!.data.data[page].qTxt
                                  //           .contains("Weight")) {
                                  //         if (goalWeightController.text == "") {
                                  //           Fluttertoast.showToast(
                                  //               msg:
                                  //                   'Please enter your goal weight');
                                  //           break;
                                  //         }
                                  //         if (currentWeightController.text ==
                                  //             "") {
                                  //           Fluttertoast.showToast(
                                  //               msg:
                                  //                   'Please enter your current weight');
                                  //           break;
                                  //         }
                                  //       } else {
                                  //         Fluttertoast.showToast(
                                  //             msg:
                                  //                 'Please enter your response');
                                  //       }
                                  //       break;
                                  //     case "single-choice":
                                  //       Fluttertoast.showToast(
                                  //           msg: 'Please select your response');
                                  //       break;
                                  //   }
                                  // }
                                }
                              },
                              child: const Text(
                                '  Continue  ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0)),
                                backgroundColor: Color(0xFFF6A03D),
                                // onSurface:
                                //     Colors.transparent,
                                // shadowColor: Colors.red.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
    );
  }

  Padding weightScreen(Datum model) {
    var goalWeight = questionModel?.data.data.firstWhere(
            (e) => e.qTxt.toLowerCase().contains('goal weight'),
            orElse: () => model) ??
        model;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        // shrinkWrap: true,
        // physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            child: Text(
              model.qTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child:
                      Image(image: AssetImage("assets/Images/weightIcon.png")),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Flexible(
                flex: 1,
                child: Text("Weight",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 0,
                child: SizedBox(
                  width: 80,
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: currentWeightController,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          userInput['${model.id}'] = {
                            "question": model.qTxt,
                            "question_id": model.id,
                            "answer_text": '$value $_weight'
                          };
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(width: 1)),
                          hintText: '',
                          labelText: "",
                          counterText: ""),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 0,
                child: Row(
                  children: [
                    MyRadioListTile2<String>(
                      value: 'kg',
                      leading: 'kg',
                      groupValue: _weight,
                      onChanged: (value) {
                        setState(() {
                          _weight = value!;
                          userInput['${model.id}'] = {
                            "question": model.qTxt,
                            "question_id": model.id,
                            "answer_text":
                                '${currentWeightController.text} $_weight'
                          };

                          userInput['${goalWeight.id}'] = {
                            "question": goalWeight.qTxt,
                            "question_id": goalWeight.id,
                            "answer_text":
                                '${goalWeightController.text} $_weight'
                          };
                        });
                      },
                    ),
                    MyRadioListTile2<String>(
                      value: 'lbs',
                      leading: 'lbs',
                      groupValue: _weight,
                      onChanged: (value) {
                        setState(() {
                          _weight = value!;
                          userInput['${model.id}'] = {
                            "question": model.qTxt,
                            "question_id": model.id,
                            "answer_text":
                                '${currentWeightController.text} $_weight'
                          };

                          userInput['${goalWeight.id}'] = {
                            "question": goalWeight.qTxt,
                            "question_id": goalWeight.id,
                            "answer_text":
                                '${goalWeightController.text} $_weight'
                          };
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Text(
              goalWeight.qTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Image(image: AssetImage("assets/Images/goalIcon.png")),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text("Goal Weight",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: SizedBox(
                  width: 80,
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TextFormField(
                      controller: goalWeightController,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() {
                          userInput['${goalWeight.id}'] = {
                            "question": goalWeight.qTxt,
                            "question_id": goalWeight.id,
                            "answer_text": '$value $_weight'
                          };
                        });
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(width: 1)),
                          hintText: '',
                          labelText: "",
                          counterText: ""),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  MyRadioListTile2<String>(
                      value: 'kg',
                      leading: 'kg',
                      groupValue: _weight,
                      onChanged: (value) {
                        setState(() {
                          _weight = value!;
                          userInput['${goalWeight.id}'] = {
                            "question": goalWeight.qTxt,
                            "question_id": goalWeight.id,
                            "answer_text":
                                '${goalWeightController.text} $_weight'
                          };

                          userInput['${model.id}'] = {
                            "question": model.qTxt,
                            "question_id": model.id,
                            "answer_text":
                                '${currentWeightController.text} $_weight'
                          };
                        });
                      }),
                  MyRadioListTile2<String>(
                      value: 'lbs',
                      leading: 'lbs',
                      groupValue: _weight,
                      onChanged: (value) {
                        setState(() {
                          _weight = value!;
                          userInput['${goalWeight.id}'] = {
                            "question": goalWeight.qTxt,
                            "question_id": goalWeight.id,
                            "answer_text":
                                '${goalWeightController.text} $_weight'
                          };

                          userInput['${model.id}'] = {
                            "question": model.qTxt,
                            "question_id": model.id,
                            "answer_text":
                                '${currentWeightController.text} $_weight'
                          };
                        });
                      }),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Padding heightScreen(Datum model) {
    var controllerFt = TextEditingController();
    var controllerIn = TextEditingController();
    // var textFromValue = '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        // shrinkWrap: true,
        // physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Text(
              model.qTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 5),
              Text("Height",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 21,
                  )),
              SizedBox(width: 15),
              SizedBox(
                width: 80,
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 4,
                    controller: controllerFt,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        //<-- SEE HERE
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(width: 1)),
                        hintText: '',
                        labelText: "",
                        counterText: ""),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(width: 20),
              MyRadioListTile2<String>(
                value: 'Ft',
                leading: 'Ft',
                groupValue: _height,
                onChanged: (value) => setState(() => _height = value!),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 5),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: false,
                child: Text("Height",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 80,
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextFormField(
                    maxLength: 4,
                    controller: controllerIn,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.next,
                     keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      userInput['${model.id}'] = {
                        "question": model.qTxt,
                        "question_id": model.id,
                        "answer_text":
                            '${controllerFt.text} $_height $value $_heightIn'
                      };
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        //<-- SEE HERE
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(width: 1)),
                        hintText: '',
                        labelText: "",
                        counterText: ""),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(width: 20),
              MyRadioListTile2<String>(
                value: 'In',
                leading: 'In',
                groupValue: _heightIn,
                onChanged: (value) => setState(() => _heightIn = value!),
              ),
              // StatefulBuilder(builder: (context, setState) {
              //   controller.addListener(() {
              //     if (_height == 'cm') {
              //       double inches = 0.3937 * double.parse(controller.text);
              //       double feet = inches / 12;
              //       double leftover = inches % 12;
              //       textFromValue = '${feet.toInt()}`${leftover.toInt()}';
              //       userInput['${model.id}'] = {
              //         "question": model.qTxt,
              //         "question_id": model.id,
              //         "answer_text": '${feet.toInt()}fit${leftover.toInt()}in',
              //       };
              //     } else {
              //       double feet = 1 * double.parse(controller.text);
              //       textFromValue = feet.toStringAsFixed(2);
              //       userInput['${model.id}'] = {
              //         "question": model.qTxt,
              //         "question_id": model.id,
              //         "answer_text": '${textFromValue}fit0in',
              //       };
              //     }
              //     setState(() => false);
              //   });
              //   return SizedBox(
              //     width: 120,
              //     height: 35,
              //     child: Padding(
              //       padding: const EdgeInsets.all(0.0),
              //       child: TextFormField(
              //         maxLength: 4,
              //         enabled: false,
              //         onChanged: (value) {

              //         },
              //         controller: TextEditingController(text: textFromValue),
              //         textAlign: TextAlign.center,
              //         textInputAction: TextInputAction.next,
              //         decoration: InputDecoration(
              //             contentPadding: EdgeInsets.zero,
              //             filled: true,
              //             //<-- SEE HERE
              //             fillColor: Colors.white,
              //             border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(5),
              //                 borderSide: BorderSide(width: 1)),
              //             hintText: '',
              //             labelText: "",
              //             counterText: ""),
              //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   );
              // }),
              // SizedBox(width: 20),
              // Text('Fit',
              //     style: TextStyle(
              //       color: Colors.grey[800],
              //       fontWeight: FontWeight.bold,
              //     )),
            ],
          ),
        ],
      ),
    );
  }

  ListView selectOneTypeQuestions(Datum model) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: Text(
            model.qTxt,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: model.choice.length,
          itemBuilder: (BuildContext context, int choiceIndex) {
            var choice = model.choice[choiceIndex].choiceText.toLowerCase();
            return MyRadioListTile<String>(
              value: choice,
              leading: capitalize(choice),
              groupValue: _choice,
              onChanged: (value) => setState(() {
                _choice = value!;
                userInput['${model.id}'] = {
                  "question": model.qTxt,
                  "question_id": model.id,
                  "answer_text": _choice
                };
                debugPrint("selectedVal: $_choice");
              }),
            );
          },
        )
      ],
    );
  }
}
