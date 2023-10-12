import 'package:flutter/material.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:health_wellness/viewBlogs.dart';

class ReadingContent extends StatefulWidget {
  const ReadingContent({super.key});

  @override
  State<ReadingContent> createState() => _ReadingContentState();
}

class _ReadingContentState extends State<ReadingContent> {
  bool _spinner = false;
  Map educationalContentData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEducationalContent("blog");
  }

  Future<void> getEducationalContent(String contentCategory) async {
    educationalContentData = {};
    setState(() => _spinner = true);
    await ApiService()
        .getEducationalContent('reading', contentCategory)
        .then((value) {
      var res = value["data"];
      setState(() => _spinner = false);
      if (res["status"] == "success") {
        setState(() {
          educationalContentData = value["data"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 10.0, 0.0),
              child: Text(
                "Reading Content",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _spinner ? Center(child: CircularProgressIndicator()) : readingList()
        ],
      ),
    );
  }

  ListView readingList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: educationalContentData['data'].length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewBlog(
                                  "${educationalContentData['data'][index]['url']}",
                                  "${educationalContentData['data'][index]['title']}",
                                )));
                  },
                  child: Column(children: [
                    // YoutubePlayer(
                    //   controller: _controller,
                    //   showVideoProgressIndicator: true,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        image: AssetImage('assets/Images/blogs.jpg'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                      child: Text(
                        "${educationalContentData['data'][index]['title']}",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                    //   child: Text(
                    //     "${educationalContentData['data'][index]['description']}",
                    //     style: TextStyle(
                    //         fontSize: 15,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.black87),
                    //   ),
                    // ),
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
