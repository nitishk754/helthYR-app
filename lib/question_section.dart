import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:health_wellness/custom_radio_button_2.dart';
import 'package:health_wellness/login.dart';
import 'package:health_wellness/services/api_services.dart';

import 'custom_radio_button.dart';
import 'model/question_model.dart';

class QuestionSection extends StatefulWidget {
  const QuestionSection({super.key});

  @override
  State<QuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  double _initial = 1.0;
  int _value = 0;
  int _value2 = 0;
  int _value3 = 0;
  String? chooseReligion = null;
  double questionval = 0.0;
  double totalQuestions = 0.0;
  QuestionModel? questionModel;

  List<String> menuItems = [
    "kg",
    "lb",
  ];
  List<String> menuItems2 = [
    "kg",
    "lb",
  ];

  void initState() {
    super.initState();
    _getData();
    _getUser();
  }

  Future<void> _getUser() async {
    (await ApiService().getUser());
  }

  void _getData() async {
    questionModel = (await ApiService().getQuestion());
    print("hefhfrehff " + questionModel!.data.data.length.toString());
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
          _initial = 1.0 / questionModel!.data.data.length;
          totalQuestions = 1.0 / questionModel!.data.data.length;
          questionval = 1.0 / questionModel!.data.data.length;
          // saveAns.length = questionModel!.data.length;
        }));
  }

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
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "HELTHYR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(blueColor),
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 50, right: 50),
                      child: LinearProgressIndicator(
                        value: _initial,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Color(blueColor)),
                      ),
                    ),
                    ExpandablePageView.builder(
                        controller: controller,
                        itemCount: questionModel!.data.data.length,
                        itemBuilder: (context, index) {
                          return ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              (questionModel!.data.data[index].qType ==
                                      "open-ended")
                                  ? (questionModel!.data.data[index].qTxt
                                          .contains("weight"))
                                      ? weightScreen()
                                      : Container()
                                  : (questionModel!.data.data[index].qType ==
                                          "single-choice")
                                      ? selectOneTypeQuestions(index)
                                      : Container()
                            ],
                          );
                        })
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
                              onPressed: () {},
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
                                setState(() {
                                  if (_initial != 1.0) {
                                    _initial = _initial + 0.25;
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  }
                                });
                                controller.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
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

  ListView weightScreen() {
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
        currentWeight(),
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
        goalWeight(),
      ],
    );
  }

  Row goalWeight() {
    return Row(
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
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true, //<-- SEE HERE
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
        MyRadioListTile2<int>(
          value: 1,
          groupValue: _value2,
          leading: 'kg',
          title: Text('One'),
          onChanged: (value) => setState(() => _value2 = value!),
        ),
        MyRadioListTile2<int>(
          value: 2,
          groupValue: _value2,
          leading: 'lbs',
          title: Text('One'),
          onChanged: (value) => setState(() => _value2 = value!),
        ),
      ],
    );
  }

  Row currentWeight() {
    return Row(
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
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true, //<-- SEE HERE
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
        MyRadioListTile2<int>(
          value: 3,
          groupValue: _value3,
          leading: 'kg',
          title: Text('One'),
          onChanged: (value) => setState(() => _value3 = value!),
        ),
        MyRadioListTile2<int>(
          value: 4,
          groupValue: _value3,
          leading: 'lbs',
          title: Text('One'),
          onChanged: (value) => setState(() => _value3 = value!),
        ),
      ],
    );
  }

  ListView selectOneTypeQuestions(int index) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: Text(
            questionModel!.data.data[index].qTxt,
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
        // ListView(
        //   shrinkWrap: true,
        //   physics: ClampingScrollPhysics(),
        //   children: [
        //     MyRadioListTile<int>(
        //       value: 1,
        //       groupValue: _value,
        //       leading: 'Male',
        //       title: Text('One'),
        //       onChanged: (value) => setState(() => _value = value!),
        //     ),
        //     MyRadioListTile<int>(
        //       value: 2,
        //       groupValue: _value,
        //       leading: 'Female',
        //       title: Text('One'),
        //       onChanged: (value) => setState(() => _value = value!),
        //     )
        //   ],
        // )
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: questionModel!.data.data[index].choice.length,
          itemBuilder: (BuildContext context, int choiceIndex) {
            return optionVal(index, choiceIndex);
          },
        )
      ],
    );
  }

  MyRadioListTile<int> optionVal(int index, int choice_index) {
    return MyRadioListTile<int>(
      value: questionModel!.data.data[index].choice[choice_index].id,
      groupValue: _value,
      leading: questionModel!.data.data[index].choice[choice_index].choiceText,
      // title: Text('One'),
      onChanged: (value) => setState(() {
        _value = value!;
        debugPrint("selectedVal: $_value");
      }),
    );
    // return MyRadioListTile<int>(
    //   value: 2,
    //   groupValue: _value,
    //   leading: 'Female',
    //   title: Text('Two'),
    //   onChanged: (value) => setState(() => _value = value!),
    // );
  }
}
