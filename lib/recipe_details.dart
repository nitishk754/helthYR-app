import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants/colors.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
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
                  ),
                )),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Image(image: AssetImage("assets/Images/recipe_detail.png")),
          ),
          recipeName(),
          servingCookPrep(),
          caloriesExtract(),
          ingredientsList(),
          instructions()
        ],
      ),
    );
  }

  Padding instructions() {
    return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Instructions",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("1",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(orangeShade))),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Lorem ipsum dolor sit amet, consetetur sadipscing",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        );
  }

  Padding ingredientsList() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Ingredients",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          color: Color(blueColor),
                          size: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Chicken",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("100g",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(orangeShade))),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Padding caloriesExtract() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15, 20.0, 15.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                  height: 100,
                  child: Card(
                    elevation: 2.5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(blueColor),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Carbs",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("98g",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(orangeShade))),
                      ],
                    ),
                  )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                  height: 100,
                  child: Card(
                    elevation: 2.5,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(blueColor),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Carbs",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("98g",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(orangeShade))),
                      ],
                    ),
                  )),
            ),
          ),
          Expanded(
            child: Container(
                height: 100,
                child: Card(
                  elevation: 2.5,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color(blueColor),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Carbs",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Text("98g",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(orangeShade))),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Padding servingCookPrep() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 2.5, 20.0, 5.0),
      child: Row(
        children: [
          Row(
            children: [
              Text("Serving:",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text("4",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(orangeShade))),
              )
            ],
          ),
          VerticalDivider(
            width: 5,
            color: Color(blueColor),
          ),
          Row(
            children: [
              Text("Prep Time:",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text("10 min",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(orangeShade))),
              )
            ],
          ),
          VerticalDivider(
            width: 5,
            color: Color(blueColor),
          ),
          Row(
            children: [
              Text("Cook Time:",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text("25 min",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(orangeShade))),
              )
            ],
          ),
        ],
      ),
    );
  }

  Padding recipeName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Garlic-Pepper Chicken",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("400 Cal",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(orangeShade))),
          ),
        ],
      ),
    );
  }
}
