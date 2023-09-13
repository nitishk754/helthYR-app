import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:health_wellness/services/api_services.dart';

import 'constants/colors.dart';

class RecipeDetails extends StatefulWidget {
  final String recipeId;
  RecipeDetails(this.recipeId);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  bool _spinner = false;
  Map recipeDetails = {};

  @override
  void initState() {
    super.initState();
    getRecipeDetails();
    print("recipeIdDetailPage: ${widget.recipeId}");
  }

  Future<void> getRecipeDetails() async {
    setState(() => _spinner = true);
    await ApiService().getRecipeDetails(widget.recipeId).then((value) {
      var res = value["data"];
      setState(() => _spinner = false);
      if (res["status"] == "success") {
        setState(() => recipeDetails = res["data"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _spinner
          ? Center(child: CircularProgressIndicator())
          : viewData(context),
    );
  }

  ListView viewData(BuildContext context) {
    return ListView(
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
        (recipeDetails["recipe_nutritions"] != null)?
        caloriesExtract():Container(
          width: 0,
          height: 0,
        ),
        Visibility(
            visible: (recipeDetails["recepie_ingredients"].length > 0)
                ? true
                : false,
            child: ingredientsList()),
        instructions()
      ],
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7.0),
              child: Html(
                data: "${recipeDetails["directions"]}",
              ),
            ),
            // Text("${recipeDetails["directions"]}"),
            Visibility(
              visible: false,
              child: ListView.builder(
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
                              child: Text(
                                  "Lorem ipsum dolor sit amet, consetetur sadipscing",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
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
                itemCount: recipeDetails["recepie_ingredients"].length,
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
                          child: Text(
                              "${recipeDetails["recepie_ingredients"][index]["ingredient"]["name"]}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              "${recipeDetails["recepie_ingredients"][index]["quantity"]}  ${recipeDetails["recepie_ingredients"][index]["unit"]}",
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
                        Text(
                            "${double.parse((recipeDetails["recipe_nutritions"]["net_carbs"])).toStringAsFixed(2)}",
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
                        Text("Protiens",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            "${double.parse((recipeDetails["recipe_nutritions"]["proteins"])).toStringAsFixed(2)}",
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
                      Text("Fats",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          "${double.parse((recipeDetails["recipe_nutritions"]["fats"])).toStringAsFixed(2)}",
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
                child: Text("${recipeDetails["servings"]}",
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
                child: Text("${recipeDetails["prep_time"]} min",
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
                child: Text("${recipeDetails["cook_time"]} min",
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
          Expanded(
            flex: 1,
            child: Text("${recipeDetails["name"]}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 0,
            child: Text(
                (recipeDetails["recipe_nutritions"]!=null)
                    ? "${double.parse((recipeDetails["recipe_nutritions"]["calories"])).toStringAsFixed(2)} cal"
                    : "0 Cal",
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
