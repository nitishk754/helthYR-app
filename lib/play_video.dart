import 'package:flutter/material.dart';
import 'package:health_wellness/constants/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideo extends StatefulWidget {
  final String videoId;
  final String categoryType;
  final String videoName;
  final String videoDesc;
  PlayVideo(this.videoId, this.categoryType, this.videoName, this.videoDesc);
  @override
  State<PlayVideo> createState() => __PlayVideoState();
}

class __PlayVideoState extends State<PlayVideo> {
  String id = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.videoId;
  }

// ignore: prefer_final_fields
  // YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: id,
  //   flags: YoutubePlayerFlags(
  //     autoPlay: false,
  //     mute: false,
  //   ),
  // );

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
                "${widget.categoryType}",
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
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                color: Colors.white,
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: id,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
              child: Text(
                "${widget.videoName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
              child: Text(
                "${widget.videoDesc}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
