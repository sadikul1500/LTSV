import 'dart:io';
// import 'dart:ui' as ui;
// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:student/Lesson/Activity/activity_list.dart';
import 'package:student/Lesson/Activity/readFile.dart';
import 'package:student/globals.dart' as globals;

class DartVLCExample extends StatefulWidget {
  @override
  DartVLCExampleState createState() => DartVLCExampleState();
}

class DartVLCExampleState extends State<DartVLCExample> {
  Player player = Player(
    id: 107,
    registerTexture: false,
  );
  ActivityFileReader fileReader =
      ActivityFileReader('${globals.folderPath}/Lesson/Activity/activity.txt');
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  VideoDimensions videoDimensions = const VideoDimensions(0, 0);
  List<Media> medias = <Media>[];

  double bufferingProgress = 0.0;

  DartVLCExampleState() {
    activities = fileReader.activityList;
    len = activities.length;
  }
  List<ActivityList> activities = [];

  int _index = 0;

  late int len;

  // int activateIndex = 0;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      player.currentStream.listen((current) {
        setState(() => this.current = current);
      });
      player.positionStream.listen((position) {
        setState(() => this.position = position);
      });
      player.playbackStream.listen((playback) {
        setState(() => this.playback = playback);
      });
      player.generalStream.listen((general) {
        setState(() => this.general = general);
      });
      // player.videoDimensionsStream.listen((videoDimensions) {
      //   setState(() => this.videoDimensions = videoDimensions);
      // });
      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() => this.bufferingProgress = bufferingProgress);
        },
      );
      player.errorStream.listen((event) {
        throw Error(); //print('libvlc error.');
      });

      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
    }
    proxyInitState(); // createPlayList();
  }

  void proxyInitState() {
    // print(len);
    // createPlaylist(_index);
    // print("proxy initstate called");
    medias = [
      Media.file(File(activities[_index].video))
    ]; //activities[index].video
    player.open(
        Playlist(
          medias: medias,
        ),
        autoStart: false);
  }

  // void createPlaylist(int index) {
  //   // print(activities[index].video);
  //   medias = [Media.file(File('D:/puppy.mp4'))]; //activities[index].video
  //   player.open(
  //       Playlist(
  //         medias: medias,
  //       ),
  //       autoStart: false);
  // }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('কর্মধারা শিখন'), //'Activity'),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Column(
            // shrinkWrap: true,
            // padding: const EdgeInsets.all(4.0),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 420,
                    width: 620,
                    child: NativeVideo(
                      player: player,
                      width: 620, //,isPhone ? 320 : 640,
                      height: 420, //isPhone ? 180 : 360,
                      volumeThumbColor: Colors.blue,
                      volumeActiveColor: Colors.blue,
                      showControls: true, //!isPhone,
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const <Widget>[],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Card(
                                  color: Colors.white70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const <Widget>[
                                        Text(
                                          'ইংরেজিতে :', //'Title: ',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          'বাংলায় : ', //'Meaning:',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Card(
                                  //margin: const EdgeInsets.all(122.0),
                                  color: Colors.blue[400],
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          activities.elementAt(_index).title,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          activities.elementAt(_index).meaning,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     ElevatedButton.icon(
              //       onPressed: () {
              //         player.stop();

              //         setState(() {
              //           // videoPlayer.previous();
              //           try {
              //             _index = (_index - 1) % len;
              //             proxyInitState();
              //             //files.clear();
              //           } catch (e) {
              //             //print(e);
              //           }
              //         });
              //       },
              //       label: const Text(
              //         'পূর্ববর্তী', //'Prev',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 17,
              //         ),
              //       ),
              //       icon: const Icon(
              //         Icons.navigate_before,
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         alignment: Alignment.center,
              //         minimumSize: const Size(100, 42),
              //       ),
              //     ),
              //     const SizedBox(width: 30),
              //     const SizedBox(width: 30),
              //     ElevatedButton(
              //       onPressed: () {
              //         player.stop();
              //         setState(() {
              //           // videoPlayer.next();
              //           try {
              //             _index = (_index + 1) % len;
              //             proxyInitState();
              //             //files.clear();
              //           } catch (e) {
              //             //print(e);
              //           }
              //         });
              //       },
              //       style: ElevatedButton.styleFrom(
              //         alignment: Alignment.center,
              //         minimumSize: const Size(100, 42),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: const <Widget>[
              //           Text('পরবর্তী', //'Next',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 17,
              //               )),
              //           SizedBox(
              //             width: 5,
              //           ),
              //           Icon(Icons.navigate_next_rounded),
              //         ],
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
    // );
  }
}
