//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:student/Lesson/Association/association_search.dart';
import 'package:student/Lesson/Association/association_video.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student/Lesson/Association/association_list.dart';
import 'package:student/Lesson/Association/readFile.dart';
import 'package:student/globals.dart' as globals;

class Association extends StatefulWidget {
  @override
  State<Association> createState() => _AssociationState();
}

class _AssociationState extends State<Association> {
  AssociationFileReader fileReader = AssociationFileReader(
      '${globals.folderPath}/Lesson/Association/association.txt');
  List<AssociationList> associations = [];

  late AssociationVideoCard associationVideoCard;

  int _index = 0;
  Player videoPlayer = Player(
    id: 91,
    registerTexture: false,
  );
  late int len;
  Set<String> imageList = {};
  final Player _audioPlayer = Player(id: 19);

  final CarouselController _controller = CarouselController();
  int activateIndex = 0;

  bool carouselAutoPlay = false;

  MediaType mediaType = MediaType.file;
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();

  List<Media> medias = <Media>[];

  double bufferingProgress = 0.0;

  _AssociationState() {
    _index = 0;
    // videoPlayer
    associations = fileReader.associationList;
    len = associations.length;
  }

  @override
  initState() {
    super.initState();
    proxyInitState();
  }

  proxyInitState() {
    // associations = fileReader.associationList;
    // len = associations.length;

    if (associations[_index].audio != '') {
      listenStreams(_audioPlayer);
    } else {
      listenStreams(videoPlayer);
      checkVideo();
    }
  }

  void listenStreams(Player player) {
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

      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() => this.bufferingProgress = bufferingProgress);
        },
      );
      player.errorStream.listen((event) {
        throw Error(); //'libvlc error.'
      });
      //devices = Devices.all;
      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
      // _audioPlayer.open(Playlist(medias: medias), autoStart: false);
    }
  }

  @override
  void dispose() {
    videoPlayer.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  loadData() async {
    if (associations.isEmpty) {
      return []; //await loadData();
    }

    if (imageList.isEmpty && associations[_index].audio != '') {
      imageList = await associations[_index].getImagePath(); //getImagePath();
    }
    // imageList = associations[_index].imgList;

    return imageList;
  }

  loadAudio() {
    _audioPlayer.setPlaylistMode(PlaylistMode.repeat);
    Media media = Media.file(File(associations[_index].audio));

    _audioPlayer.open(media, autoStart: false);

    // print('load audio association ${associations[_index].audio}');
  }

  checkVideo() {
    // print('came to check video function....');
    // print(associations[_index].video);
    // print("audio shoud be empty ${associations[_index].audio} ok");
    if (associations[_index].video != '') {
      // print('came to check video if condition....');
      medias = [
        Media.file(File(associations[_index].video))
      ]; //activities[index].video
      videoPlayer.open(
          Playlist(
            medias: medias,
          ),
          autoStart: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkVideo();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Association',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
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
          actions: [
            IconButton(
                onPressed: () async {
                  stop();
                  setState(() {});
                  var result = await showSearch<String>(
                    context: context,
                    delegate: CustomDelegate(associations),
                  );
                  setState(() {
                    _index = max(
                        0,
                        associations
                            .indexWhere((element) => element.title == result));
                  });
                },
                icon: const SafeArea(child: Icon(Icons.search_sharp)))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            associations[_index].audio != ''
                ? _associationCard()
                : Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white70, width: .1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    height: 420,
                                    width: 600,
                                    child: NativeVideo(
                                      player: videoPlayer,
                                      width: 600, //640,
                                      height: 420, //360,
                                      volumeThumbColor: Colors.blue,
                                      volumeActiveColor: Colors.blue,
                                      showControls: true, //!isPhone
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                              rightSidePanel(associations.elementAt(_index))
                            ])),
                  ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    stop();
                    setState(() {
                      try {
                        _index = (_index - 1) % len;
                        activateIndex = 0;
                        imageList.clear();
                        checkVideo();
                      } catch (e) {
                        //print(e);
                      }
                    });
                  },
                  label: const Text(
                    'Prev',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  icon: const Icon(
                    Icons.navigate_before,
                  ),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    minimumSize: const Size(100, 42),
                  ),
                ),
                const SizedBox(width: 30),
                imageList.isNotEmpty
                    ? IconButton(
                        icon: (!_audioPlayer.playback.isPlaying) //_isPaused
                            ? const Icon(Icons.play_circle_outline)
                            : const Icon(Icons.pause_circle_filled),
                        iconSize: 40,
                        onPressed: () {
                          if (_audioPlayer.playback.isPlaying) {
                            //print('---------is playing true-------');
                            pause(); //stop()
                          } else {
                            //print('-------is playing false-------');
                            play();
                          }
                        })
                    : const SizedBox(width: 40), //Text('        '),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    stop();
                    setState(() {
                      try {
                        _index = (_index + 1) % len;
                        activateIndex = 0;
                        imageList.clear();
                        checkVideo();
                      } catch (e) {
                        //print(e);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    minimumSize: const Size(100, 42),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const <Widget>[
                      Text('Next',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.navigate_next_rounded),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  stop() {
    if (imageList.isNotEmpty) {
      _audioPlayer.stop();
      carouselAutoPlay = false;
    } else {
      videoPlayer.stop();
    }
  }

  pause() {
    _audioPlayer.pause();
    carouselAutoPlay = false;
  }

  play() {
    _audioPlayer.play();

    carouselAutoPlay = true;
  }

  Widget _associationCard() {
    // if (associations[_index].audio == '') {
    //   return associationVideoWidgetCard();
    // } else {
    if (imageList.isEmpty) {
      loadData().then((data) {
        if (imageList.isEmpty) {
          loadData();
        } else {
          loadAudio();
          return associationCardWidget();
        }
      });
      return const CircularProgressIndicator();
    } else {
      return associationCardWidget(); //NounCard(names.elementAt(_index), _audioPlayer);
    }
    // }
  }

  // Widget associationVideoWidgetCard() {
  //   AssociationList association = associations.elementAt(_index);
  //   associationVideoCard =
  //       AssociationVideoCard(associations[_index].video, videoPlayer);
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       side: const BorderSide(color: Colors.white70, width: .1),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: <Widget>[
  //                   const SizedBox(height: 15),
  //                   associationVideoCard.getAssociationVideoCard(),
  //                   const SizedBox(height: 15),
  //                 ],
  //               ),
  //               rightSidePanel(association)
  //             ])),
  //   ); //associationVideoCard.getAssociationVideoCard();
  // }

  Widget associationCardWidget() {
    AssociationList association = associations.elementAt(_index);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 420,
                  width: 600,
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: imageList.length,
                    options: CarouselOptions(
                        height: 385.0,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        autoPlay: carouselAutoPlay,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayInterval: const Duration(seconds: 2),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1400),
                        viewportFraction: 0.8,
                        pauseAutoPlayOnManualNavigate: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activateIndex = index;
                          });
                        }),
                    itemBuilder: (context, index, realIndex) {
                      if (index >= imageList.length) {
                        index = 0;
                      }
                      final img = imageList.elementAt(index);

                      return buildImage(img);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                buildIndicator(imageList),
              ],
            ),
            rightSidePanel(association)
          ],
        ),
      ),
    );
  }

  Widget rightSidePanel(AssociationList association) {
    return SizedBox(
      width: 500,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const <Widget>[
                          Text(
                            'Title: ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Meaning:',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            association.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            association.meaning,
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
    );
  }

  Widget buildImage(String img) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey,
      child: Image.file(
        File(img),
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  Widget buildIndicator(Set<String> images) => AnimatedSmoothIndicator(
        activeIndex: images.isEmpty ? 0 : activateIndex % images.length,
        count: images.length,
        effect: const JumpingDotEffect(
          //SwapEffect
          activeDotColor: Colors.blue,
          dotColor: Colors.black12,
          dotHeight: 10,
          dotWidth: 10,
        ),
        onDotClicked: animateToSlide,
      );

  void animateToSlide(int index) {
    try {
      _controller.animateToPage(index);
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
  }
}
