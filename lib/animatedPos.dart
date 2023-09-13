import 'package:flutter/material.dart';

class AnimatedPos extends StatefulWidget {
  const AnimatedPos({super.key});

  @override
  State<AnimatedPos> createState() => _AnimatedPosState();
}

class _AnimatedPosState extends State<AnimatedPos> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 350,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            width: MediaQuery.of(context).size.width,
            height: 100,
            top: selected ? 20.0 : 100.0,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selected = !selected;
                });
              },
              child: Card(
              shape: RoundedRectangleBorder(
                  //<-- SEE HERE
                      
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: TextField(
                onChanged: (value) {
                  // filterSearchResults(value);
                  if (value.length > 2) {
                    // getRecipes(value);
                    setState(() {
                      // _visibility = true;
                    });
                  }
                      
                  if (value.isEmpty) {
                    setState(() {
                      // _visibility = false;
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  }
                },
                // controller: editingController,
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
        ],
      ),
    ),
      ),
    );
  }
}