import 'package:flutter/material.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:health_wellness/constants/urls.dart';
import 'package:health_wellness/play_video.dart';
import 'package:health_wellness/services/api_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({super.key});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  bool _spinner = false;
  Map educationalContentData = {};
  late String _videoContent = "Educational video";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEducationalContent("Educational video");
  }

  Future<void> getEducationalContent(String contentCategory) async {
    educationalContentData = {};
    setState(() => _spinner = true);
    await ApiService()
        .getEducationalContent('video', contentCategory)
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

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'Q13MuvHJ7s4',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: true,
    ),
  );
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
                "Video Content",
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0,8,20.0,8.0),
            child: Text("Select Video Category",
             style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        )),
          
          Padding(
            padding: const EdgeInsets.only(left:20.0, right: 20.0),
            child: Container(
              height: 50.0, // Set the desired height
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width: 2),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: DropdownButton(
                    value: _videoContent,
                    // padding: EdgeInsets.only(left: 5),
                    // DropdownButton properties...
                    underline: Container(), // Hide the underline
                    items: [
                      DropdownMenuItem(
                        value: "Educational video",
                        child: Text(
                          'Educational Video',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ), // Displayed when selectedValue is null
                      ),
                      DropdownMenuItem(
                        value: 'affirmation video',
                        child: Text('Affirmation Video',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ),
                      DropdownMenuItem(
                        value: 'workout video',
                        child: Text('Workout Video',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _videoContent = value.toString();
                      });
                      getEducationalContent(_videoContent);
                    },
                  ),
                ),
              ),
            ),
          ),
          _spinner ? Center(child: CircularProgressIndicator()) : videoList(),
        ],
      ),
    );
  }

  ListView videoList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: educationalContentData["data"].length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 280,
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
                                  builder: (context) => PlayVideo("${YoutubePlayer.convertUrlToId(educationalContentData['data'][index]['url'])}",
                                  _videoContent,"${educationalContentData['data'][index]['title']}",
                                  "${educationalContentData['data'][index]['description']}")));
                  },
                  child: Column(children: [
                    // YoutubePlayer(
                    //   controller: _controller,
                    //   showVideoProgressIndicator: true,
                    // ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Image(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            image: NetworkImage(
                                'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(educationalContentData['data'][index]['url'])}/0.jpg'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: Center(
                            child: Center(
                                child: Icon(
                              Icons.play_circle_outline,
                              size: 60,
                              color: Colors.red,
                            )),
                          ),
                        ),
                      ],
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
                    
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
