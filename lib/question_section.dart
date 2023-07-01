import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
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
  double _initial = 1.0;
  String _choice = '';
  String _currentWeight = 'kg';
  String _goalWeight = 'kg';
  String _height = 'Fit';

  QuestionModel? questionModel;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    questionModel = (await ApiService().getQuestion());
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          _initial = 1.0 / questionModel!.data.data.length;
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
      appBar: null,
      backgroundColor: Color(0xFFF6F8F7),
      body: (questionModel == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView(
                  children: [
                    SizedBox(height: 50),
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
                      controller: controller,
                      children: questionModel!.data.data.map((model) {
                        //
                        // debugPrint('qType ==> ${model.qTxt}');
                        return ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: [
                            SizedBox(height: 50),
                            (model.qType == "open-ended")
                                ? (model.qTxt.contains("weight"))
                                    ? weightScreen(model)
                                    : (model.qTxt.contains("tall"))
                                        ? heightScreen(model)
                                        : Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10.0, 5.0, 10.0, 5.0),
                                                child: Text(
                                                  "What is your age?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              NumberPicker(
                                                value: _currentAge,
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
                                style: TextStyle(fontSize: 20),
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
                                var page = controller.page?.toInt() ?? 0;
                                var length = userInput.values.length;
                                debugPrint('page => $page, length => $length');
                                if (length > page) {
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
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Please give answer to continue');
                                }
                              },
                              child: const Text(
                                '  Continue  ',
                                style: TextStyle(fontSize: 20),
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

  ListView weightScreen(Datum model) {
    var goalWeight = questionModel?.data.data.firstWhere(
            (e) => e.qTxt.toLowerCase().contains('goal weight'),
            orElse: () => model) ??
        model;
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: Text(
            "What Is Your Current Weight?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Image(image: AssetImage("assets/Images/weightIcon.png")),
            ),
            SizedBox(
              width: 5,
            ),
            Text("Weight",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 80,
              height: 35,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    userInput['${model.id}'] = {
                      "question": model.qTxt,
                      "question_id": model.id,
                      "answer_text": '$value $_currentWeight'
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            MyRadioListTile2<String>(
              value: 'kg',
              leading: 'kg',
              groupValue: _currentWeight,
              onChanged: (value) => setState(() => _currentWeight = value!),
            ),
            MyRadioListTile2<String>(
              value: 'lbs',
              leading: 'lbs',
              groupValue: _currentWeight,
              onChanged: (value) => setState(() => _currentWeight = value!),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: Text(
            "What Is Your Goal Weight?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Image(image: AssetImage("assets/Images/goalIcon.png")),
            ),
            SizedBox(
              width: 5,
            ),
            Text("Goal Weight",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 80,
              height: 35,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    userInput['${goalWeight.id}'] = {
                      "question": goalWeight.qTxt,
                      "question_id": goalWeight.id,
                      "answer_text": '$value $_goalWeight'
                    };
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            MyRadioListTile2<String>(
              value: 'kg',
              leading: 'kg',
              groupValue: _goalWeight,
              onChanged: (value) => setState(() => _goalWeight = value!),
            ),
            MyRadioListTile2<String>(
              value: 'lbs',
              leading: 'lbs',
              groupValue: _goalWeight,
              onChanged: (value) => setState(() => _goalWeight = value!),
            ),
          ],
        ),
      ],
    );
  }

  ListView heightScreen(Datum model) {
    var controller = TextEditingController();
    var textFromValue = '';
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: Text(
            "How tall are you?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            Text("Height",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            SizedBox(width: 15),
            SizedBox(
              width: 80,
              height: 35,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  maxLength: 4,
                  controller: controller,
                  textAlign: TextAlign.center,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 20),
            MyRadioListTile2<String>(
              value: 'Fit',
              leading: 'Fit',
              groupValue: _height,
              onChanged: (value) => setState(() => _height = value!),
            ),
            MyRadioListTile2<String>(
              value: 'cm',
              leading: 'cm',
              groupValue: _height,
              onChanged: (value) => setState(() => _height = value!),
            ),
          ],
        ),
        SizedBox(
          height: 90,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 15),
            Text("",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            SizedBox(width: 15),
            StatefulBuilder(builder: (context, setState) {
              controller.addListener(() {
                if (_height == 'cm') {
                  double inches = 0.3937 * double.parse(controller.text);
                  double feet = inches / 12;
                  double leftover = inches % 12;
                  textFromValue = '${feet.toInt()}`${leftover.toInt()}';
                  userInput['${model.id}'] = {
                    "question": model.qTxt,
                    "question_id": model.id,
                    "answer_text": '${feet.toInt()}fit${leftover.toInt()}in',
                  };
                } else {
                  double feet = 1 * double.parse(controller.text);
                  textFromValue = feet.toStringAsFixed(2);
                  userInput['${model.id}'] = {
                    "question": model.qTxt,
                    "question_id": model.id,
                    "answer_text": '${textFromValue}fit0in',
                  };
                }
                setState(() => false);
              });
              return SizedBox(
                width: 120,
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextFormField(
                    maxLength: 4,
                    enabled: false,
                    onChanged: (value) {

                    },
                    controller: TextEditingController(text: textFromValue),
                    textAlign: TextAlign.center,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
            SizedBox(width: 20),
            Text('Fit',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ],
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
              fontSize: 30,
            ),
          ),
        ),
        SizedBox(
          height: 50,
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
