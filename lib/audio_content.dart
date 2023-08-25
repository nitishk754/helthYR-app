import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:health_wellness/constants/colors.dart';

class AudioContent extends StatefulWidget {
  const AudioContent({super.key});

  @override
  State<AudioContent> createState() => _AudioContentState();
}

class _AudioContentState extends State<AudioContent> {
  final player = AudioPlayer();
  
  bool isPlayed = false;
  @override
  Widget build(BuildContext context) {
    player.onPlayerComplete.listen((event) {
      setState(()=>isPlayed=false);
    },);
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
                    player.stop();
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
                "Audio Content",
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
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 1.5, 5.0, 1.5),
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      color: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Color(blueColor),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Image(
                                            height: 50,
                                            width: 50,
                                            image: AssetImage(
                                                "assets/Images/listen.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Text(
                                            "Audio Name",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          child: Text(
                                            "Duration",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 0,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          if (isPlayed) {
                                            await player.stop();
                                            setState(() {
                                              isPlayed = false;
                                            });
                                          } else {
                                            await player.play(AssetSource(
                                                'sounds/sampleAudio.wav'));
                                            setState(() {
                                              isPlayed = true;
                                            });
                                          }
                                        },
                                        icon: isPlayed
                                            ? Icon(Icons.pause_circle)
                                            : Icon(Icons.play_circle_outline))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
