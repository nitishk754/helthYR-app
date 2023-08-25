import 'package:flutter/material.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({super.key});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
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
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      color: Colors.white,
                      child: Column(children: [
                        YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                        ),
                        // Stack(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(top:10.0),
                        //       child: Image(
                        //         height: 200,
                        //         width: MediaQuery.of(context).size.width,
                        //         image: AssetImage("assets/Images/videos.png"),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(top: 70.0),
                        //       child: Center(
                        //         child: Center(
                        //             child: Icon(
                        //           Icons.play_circle_outline,
                        //           size: 60,
                        //           color: Colors.red,
                        //         )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                          child: Text(
                            "Video Name",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                          child: Text(
                            "Duration",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
