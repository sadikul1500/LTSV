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
    id: 0,
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

  int activateIndex = 0;

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
      player.videoDimensionsStream.listen((videoDimensions) {
        setState(() => this.videoDimensions = videoDimensions);
      });
      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() => this.bufferingProgress = bufferingProgress);
        },
      );
      player.errorStream.listen((event) {
        print('libvlc error.');
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
    print("proxy initstate called");
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
        appBar: AppBar(
          title: const Text('dart_vlc'),
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
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(4.0),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                // SizedBox(
                //   width: 500,
                //   height: 250,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: <Widget>[
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: const <Widget>[],
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: <Widget>[
                //           Column(
                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //             children: <Widget>[
                //               Card(
                //                 color: Colors.white70,
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(20.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: const <Widget>[
                //                       Text(
                //                         'Title: ',
                //                         style: TextStyle(
                //                           fontSize: 24,
                //                           fontWeight: FontWeight.w600,
                //                         ),
                //                       ),
                //                       Text(
                //                         'Meaning:',
                //                         style: TextStyle(
                //                           fontSize: 24,
                //                           fontWeight: FontWeight.w600,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //           Column(
                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //             children: <Widget>[
                //               Card(
                //                 //margin: const EdgeInsets.all(122.0),
                //                 color: Colors.blue[400],
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(18.0),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: <Widget>[
                //                       const Text(
                //                         'Test', // activities.elementAt(_index).title,
                //                         style: const TextStyle(
                //                           fontSize: 24,
                //                           fontWeight: FontWeight.w600,
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                       const SizedBox(height: 5),
                //                       Text(
                //                         'Test m', //activities.elementAt(_index).meaning,
                //                         style: const TextStyle(
                //                           fontSize: 24,
                //                           fontWeight: FontWeight.w600,
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
    // );
  }
}
