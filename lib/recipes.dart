import 'dart:async';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_wellness/recipe_details.dart';
import 'package:health_wellness/services/api_services.dart';

import 'constants/colors.dart';

class RecipesWidget extends StatefulWidget {
  const RecipesWidget({super.key});

  @override
  State<RecipesWidget> createState() => _RecipesWidgetState();
}

class _RecipesWidgetState extends State<RecipesWidget> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = <String>[];
  bool _visibility = false;
  bool _spinner = false;
  Map recipeSearchResult = {};
  bool selected = false;

  @override
  void initState() {
    items = duplicateItems;
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      items = duplicateItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> getRecipes(String query) async {
    setState(() => _spinner = true);
    await ApiService().getRecipeSearch(query).then((value) {
      var res = value["data"];
      setState(() => _spinner = false);
      if (res["status"] == "success") {
        // log(value["data"]);
        setState(() => recipeSearchResult = value["data"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchValue;
    return Scaffold(
        // appBar: AppBar(
        //     title: EasySearchBar(
        //         title: Text('Example'),
        //         onSearch: (value) => setState(() => searchValue = value))),
        body: SafeArea(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
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
                "Recipes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          Padding(
            
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Card(
                shape: RoundedRectangleBorder(
                    //<-- SEE HERE
                        
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: TextField(
                  onChanged: (value) {
                    // filterSearchResults(value);
                    if (value.length > 2) {
                      getRecipes(value);
                      setState(() {
                        _visibility = true;
                      });
                    }
                        
                    if (value.isEmpty) {
                      setState(() {
                        _visibility = false;
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    }
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search by ingredients or recipes",
                      hintText: "Search by ingredients or recipes",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
            ),
          ),
          _visibility
              ? Visibility(
                  child: _spinner
                      ? Center(child: CircularProgressIndicator())
                      : searchList(),
                  visible: _visibility,
                )
              : Visibility(
                // visible: (_visibility),
                  child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,
                        left: 20.0, right: 20.0, bottom: 50.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Search By Typing Ingredients or Recipes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(orangeShade),
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DefaultTextStyle(
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                  child: AnimatedTextKit(
                                      pause: Duration(milliseconds: 1),
                                      // isRepeatingAnimation: true,
                                      repeatForever: true,
                                      animatedTexts: [
                                        RotateAnimatedText(
                                            "Try Typing ' Fish '",
                                            textStyle: TextStyle(
                                                color: Color(orangeShade))),
                                        RotateAnimatedText(
                                            "Try Typing ' Grilled Chicken '",
                                            textStyle: TextStyle(
                                                color: Color(orangeShade))),
                                        RotateAnimatedText(
                                            "Try Typing ' Avacado '",
                                            textStyle: TextStyle(
                                                color: Color(orangeShade))),
                                        RotateAnimatedText(
                                            "Try Typing ' Salad '",
                                            textStyle: TextStyle(
                                                color: Color(orangeShade))),
                                        RotateAnimatedText(
                                            "Try Typing ' Soup '",
                                            textStyle: TextStyle(
                                                color: Color(orangeShade))),
                                        RotateAnimatedText(
                                            "Try Typing ' Coconut '",
                                            textStyle: TextStyle(
                                                color: Color(orangeShade))),
                                        RotateAnimatedText(
                                            "Try Typing ' Chickpea Curry '",
                                            textStyle: TextStyle(
                                                color: Color(orangeShade)))
                                      ]),
                                ),
                              ],
                            ),
                          ),

                          //
                        )
                      ],
                    ),
                  ),
                ))
          // searchList(),
        ],
      ),
    ));
  }

  Expanded searchList() {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: recipeSearchResult["data"].length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 2.5),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeDetails("${recipeSearchResult["data"][index]["id"]}")));
                },
                child: Card(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(12.0, 1.5, 12.0, 1.5),
                    height: 90,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //width: MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 1.0),
                                          child: Container(
                                            // width: 150,
                                            child: Text(
                                              '${recipeSearchResult["data"][index]["name"]}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          "prep time: ${recipeSearchResult["data"][index]["prep_time"]} mins",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                            "cook time: ${recipeSearchResult["data"][index]["cook_time"]} mins",
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
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text((recipeSearchResult["data"][index]['recipe_nutritions']==null)?
                                  "0 Cal":
                                  "${double.parse(recipeSearchResult["data"][index]['recipe_nutritions']['calories']).roundToDouble().round().toString()} Cal",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(orangeShade),
                                        fontWeight: FontWeight.w600)),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
