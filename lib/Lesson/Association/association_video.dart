import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';

class AssociationVideoCard {
  late Player player; //= Player(

  MediaType mediaType = MediaType.file;
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  VideoDimensions videoDimensions = const VideoDimensions(0, 0);
  List<Media> medias = <Media>[];
  List<Device> devices = <Device>[];
  TextEditingController controller = TextEditingController();
  TextEditingController metasController = TextEditingController();
  double bufferingProgress = 0.0;
  Media? metasMedia;
  List<File> files = [];

  AssociationVideoCard(String videoFilePath, this.player) {
    player.currentStream.listen((current) {
      this.current = current;
    });
    player.positionStream.listen((position) {
      this.position = position;
    });
    player.playbackStream.listen((playback) {
      this.playback = playback;
    });
    player.generalStream.listen((general) {
      general = general;
    });
    player.videoDimensionsStream.listen((videoDimensions) {
      videoDimensions = videoDimensions;
    });
    player.bufferingProgressStream.listen(
      (bufferingProgress) {
        this.bufferingProgress = bufferingProgress;
      },
    );
    player.errorStream.listen((event) {
      throw Error(); //'libvlc error.'
    });
    devices = Devices.all;
    Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
    equalizer.setPreAmp(10.0);
    equalizer.setBandAmp(31.25, 10.0);
    player.setEqualizer(equalizer);
    player.open(Media.file(File(videoFilePath)), autoStart: false);
  }

  //@override
  Widget getAssociationVideoCard() {
    return SizedBox(
      height: 420,
      width: 600,
      child: NativeVideo(
        player: player,
        width: 600, //640,
        height: 420, //360,
        volumeThumbColor: Colors.blue,
        volumeActiveColor: Colors.blue,
        showControls: true, //!isPhone
      ),
    );
  }
}
