//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:student/Lesson/Verb/verb_list.dart';
import 'package:student/Lesson/Verb/verb_search.dart';
import 'package:student/globals.dart' as globals;

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student/Lesson/Verb/readFile.dart';

class Verb extends StatefulWidget {
  @override
  State<Verb> createState() => _VerbState();
}

class _VerbState extends State<Verb> {
  VerbFileReader fileReader =
      VerbFileReader('${globals.folderPath}/Lesson/Verb/verb.txt');
  List<VerbList> verbs = [];
  int _index = 0;
  late int len;
  Set<String> imageList = {};

  final player = Player(id: 1003);

  final CarouselController _controller = CarouselController();
  int activateIndex = 0;

  bool carouselAutoPlay = false;

  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  double bufferingProgress = 0.0;

  Widget _verbCard() {
    if (imageList.isEmpty) {
      loadData().then((data) {
        if (imageList.isEmpty) {
          loadData();
        } else {
          loadAudio();
          return verbCardWidget();
        }
      });
      return const CircularProgressIndicator();
    } else {
      return verbCardWidget(); //NounCard(names.elementAt(_index), _audioPlayer);
    }
  }

  _VerbState() {
    _index = 0;
  }

  @override
  initState() {
    super.initState();
    proxyInitState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  proxyInitState() async {
    verbs = fileReader.verbList;
    len = verbs.length;

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
        print('libvlc error.');
      });

      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
    }
  }

  loadData() async {
    if (imageList.isEmpty) {
      imageList = await verbs[_index].getImagePath(); //getImagePath();
    }

    return imageList;
  }

  loadAudio() {
    player.setPlaylistMode(PlaylistMode.repeat);
    Media media = Media.file(File(verbs[_index].audio));

    player.open(media, autoStart: false);

    print(verbs[_index].audio);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        stop();
        setState(() {});

        Navigator.pop(context);

        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Noun',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  stop();
                  setState(() {});
                  var result = await showSearch<String>(
                    context: context,
                    delegate: CustomDelegate(verbs),
                  );
                  setState(() {
                    _index = max(0,
                        verbs.indexWhere((element) => element.title == result));
                  });
                }, //Navigator.pushNamed(context, '/searchPage'),

                icon: const SafeArea(child: Icon(Icons.search_sharp)))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            //resizeTo
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              _verbCard(),
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
                        } catch (e) {
                          throw Exception(e); //print(e);
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
                  IconButton(
                      icon: (!player.playback.isPlaying) //_isPaused
                          ? const Icon(Icons.play_circle_outline)
                          : const Icon(Icons.pause_circle_filled),
                      iconSize: 40,
                      onPressed: () {
                        if (player.playback.isPlaying) {
                          pause(); //stop()
                        } else {
                          play();
                        }
                      }),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      stop();
                      setState(() {
                        try {
                          _index = (_index + 1) % len;
                          activateIndex = 0;
                          imageList.clear();
                        } catch (e) {
                          throw Exception(e); //print(e);
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
      ),
    );
  }

  stop() {
    player.stop();
    carouselAutoPlay = false;
  }

  pause() {
    player.pause();
    setState(() {
      carouselAutoPlay = false;
    });
  }

  play() {
    player.play();
    setState(() {
      carouselAutoPlay = true;
    });
  }

  Widget verbCardWidget() {
    VerbList verb = verbs.elementAt(_index);

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
            SizedBox(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const <Widget>[
                                  Text(
                                    'Noun: ',
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
                            color: Colors.blue[400],
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    verb.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    verb.meaning,
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
            ),
          ],
        ),
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
        activeIndex: images.isEmpty
            ? 0
            : activateIndex % images.length, //== 0 ? 1 : images.length
        count: images.length,
        effect: const JumpingDotEffect(
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
      throw Exception(e);
    }
  }
}
