import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:student/Reward/reward_list.dart';
import 'package:student/Reward/reward.dart';
// import 'package:student/globals.dart' as globals;
import 'package:student/main.dart';

class RewardInterface extends StatefulWidget {
  // final List<RewardList> rewards = rewardds;
  // final List<RewardList> rewardds = Reward().rewards;
  String category;

  RewardInterface(this.category, {super.key});
  @override
  State<RewardInterface> createState() => _RewardInterfaceState();
}

class _RewardInterfaceState extends State<RewardInterface> {
  var rewardd;
  String category = '';
  final List<RewardList> rewardds = Reward().rewards;
  bool isImage = false;

  Player player = Player(
    id: 1011,
    // videoDimensions: const VideoDimensions(640, 360),
    registerTexture: !Platform.isWindows,
  );
  MediaType mediaType = MediaType.file;
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  VideoDimensions videoDimensions = const VideoDimensions(0, 0);
  List<Media> medias = <Media>[];

  double bufferingProgress = 0.0;
  Media? metasMedia;

  _RewardInterfaceState() {
    fixReward();
  }

  @override
  void initState() {
    category = widget.category;
    super.initState();
    if (!isImage) {
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
          throw Error(); //print('libvlc error.');
        });

        Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
        equalizer.setPreAmp(10.0);
        equalizer.setBandAmp(31.25, 10.0);
        player.setEqualizer(equalizer);
      }
      createPlayList();
    }
  }

  void fixReward() {
    // print(rewardds.length);
    for (var x in rewardds) {
      if (x.category == category) {
        rewardd = x;
        break;
      } else if (x.category == 'all') {
        rewardd = x;
      }
    }
    if (rewardd.video == '') {
      isImage = true;
    }
  }

  void createPlayList() {
    medias = [Media.file(File(rewardd.video))];
    player.open(
        Playlist(
          medias: medias,
        ),
        autoStart: false);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          // stop();
          // setState(() {});

          Navigator.pop(context);

          return Future.value(true);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                'Reward',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
            ),
            body: Center(
                child: isImage
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        height: 300,
                        width: 400,
                        child: Image.file(
                          File(rewardd.imagePath),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      )
                    : SizedBox(
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
                      ))));
  }
}
