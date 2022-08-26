//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:student/Lesson/Noun/noun_list.dart';
import 'package:student/Lesson/Noun/noun_search.dart';
import 'package:student/globals.dart' as globals;

import 'package:carousel_slider/carousel_slider.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student/Lesson/Noun/readFile.dart';

class Noun extends StatefulWidget {
  @override
  State<Noun> createState() => _NounState();
}

class _NounState extends State<Noun> {
  FileReader fileReader =
      FileReader('${globals.folderPath}/Lesson/Noun/noun.txt');
  List<NounList> names = [];
  int _index = 0;
  late int len;
  List<String> imageList = [];
  // final AudioPlayer _audioPlayer = AudioPlayer();
  final player = Player(id: 1003);

  final CarouselController _controller = CarouselController();
  int activateIndex = 0;

  //bool _isPlaying = false;
  bool carouselAutoPlay = false;
  //bool _isPaused = true;

  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  double bufferingProgress = 0.0;

  Widget _nounCard() {
    // loadData().then((data) {
    //   if (data.isEmpty) {
    //     loadData();
    //   } else {
    //     return nounCardWidget();
    //   }
    //   //setState(() {});
    // });
    if (imageList.isEmpty) {
      // _nounCard
      //loadData();
      loadData().then((data) {
        if (data.isEmpty) {
          print('data empty _nounCard');
          print(imageList.length);
          loadData();
        } else {
          loadAudio();
          return nounCardWidget();
        }
        //setState(() {});
      });
      return const CircularProgressIndicator();
    }
    // else if (_audioPlayer.processingState != ProcessingState.ready) {
    //   loadAudio();

    //   return const CircularProgressIndicator();
    // }
    else {
      // loadAudio();
      return nounCardWidget(); //NounCard(names.elementAt(_index), _audioPlayer);
    }
  }

  _NounState() {
    _index = 0;
  }

  @override
  initState() {
    super.initState();
    proxyInitState();
  }

  @override
  void dispose() {
    // _audioPlayer.dispose();
    player.dispose();
    super.dispose();
  }

  proxyInitState() async {
    names = fileReader.nounList;
    len = names.length;

    // await loadData().then((data) {
    //   if (data.isEmpty) {
    //     print('data empty proxy');
    //     print(imageList.length);
    //     loadData();
    //   } else {
    //     print('proxy--- not empty');
    //     print(imageList.length);
    //   }
    //   //setState(() {});
    // });
    // loadAudio();
    if (mounted) {
      print('mounted');
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
      // this.devices = Devices.all;
      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
    }
    // _nounCard();
    // loadAudio().then((value) {
    //   //print('then2');
    //   _nounCard();
    // });
  }

  loadData() async {
    // names = fileReader.nounList;

    // len = names.length;
    if (imageList.isEmpty) {
      print('call get image Path');
      imageList = await names[_index].getImagePath(); //getImagePath();
    }
    print('load  data noun.dart');
    print(imageList);
    print(imageList.length);
    // if (imageList.length == 0) {
    //   load..Data();
    // }
    // _nounCard();
    // await Future.delayed(const Duration(milliseconds: 500));
    //setState(() {});
    return imageList;
  }

  loadAudio() {
    player.setPlaylistMode(PlaylistMode.repeat);
    Media media = Media.file(File(names[_index].audio));
    // player.open(Playlist(medias: [media], playlistMode: PlaylistMode.repeat),
    //     autoStart: false);
    player.open(media, autoStart: false);
    print('load audio');
    print(names[_index].audio);
    //if (!mounted) return;
    // await _audioPlayer.setAudioSource(
    //     AudioSource.uri(Uri.file(names[_index].audio)),
    //     initialPosition: Duration.zero,
    //     preload: true);

    // ///print('load audio function done');
    // _audioPlayer.setLoopMode(LoopMode.one);
    // _audioPlayer.playerStateStream.listen((state) {
    //   setState(() {});
    // });
    // return _audioPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        stop();
        setState(() {});

        Navigator.pop(context);

        //we need to return a future
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
                    delegate: CustomDelegate(names),
                  );
                  setState(() {
                    _index = max(0,
                        names.indexWhere((element) => element.title == result));
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
              _nounCard(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      stop();

                      setState(() {
                        //_isPlaying = false;

                        try {
                          _index = (_index - 1) % len;
                          imageList.clear();
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
                  IconButton(
                      icon: (!player.playback.isPlaying) //_isPaused
                          ? const Icon(Icons.play_circle_outline)
                          : const Icon(Icons.pause_circle_filled),
                      iconSize: 40,
                      onPressed: () {
                        if (player.playback.isPlaying) {
                          //!_isPaused
                          //print('---------is playing true-------');
                          pause(); //stop()
                        } else {
                          //print('-------is playing false-------');
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
                          imageList.clear();
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
        // floatingActionButton: Row(
        //   children: [
        //     const SizedBox(width: 25.0),
        //     FloatingActionButton.extended(
        //       heroTag: 'btn1',
        //       onPressed: () {
        //         stop();
        //         teachStudent();
        //       },
        //       icon: const Icon(Icons.add),
        //       label: const Text('Assign to student',
        //           style: TextStyle(
        //             fontSize: 18,
        //           )),
        //     ),
        //     const Spacer(),
        //     FloatingActionButton.extended(
        //       heroTag: 'btn2',
        //       onPressed: () {
        //         stop();

        //         Navigator.of(context)
        //             .pushNamed('/nounForm')
        //             .then((value) => setState(() {
        //                   proxyInitState();
        //                 }));
        //       },
        //       icon: const Icon(Icons.add),
        //       label: const Text('Add a Noun',
        //           style: TextStyle(
        //             fontSize: 18,
        //           )),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  stop() {
    // await _audioPlayer.stop();
    player.stop();
    setState(() {
      //_isPlaying = false;
      //_isPaused = true;
      carouselAutoPlay = false;
    });
  }

  pause() {
    // _audioPlayer.pause();
    player.pause();
    setState(() {
      //_isPaused = true;
      carouselAutoPlay = false;
    });
  }

  play() {
    //_audioPlayer.play();
    player.play();

    setState(() {
      //_isPlaying = true;
      //_isPaused = false;
      carouselAutoPlay = true;
    });
  }

  Widget nounCardWidget() {
    NounList name = names.elementAt(_index);
    //loadAudio();
    //List<String> images = name.imagePath;

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
                        //pageSnapping: false,
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
                      final img = imageList[index]; //}catch(error){
                      // print('eror');
                      // }

                      return buildImage(img, index);
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
                      // Checkbox(
                      //     value: name.isSelected,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         name.isSelected = !name.isSelected;
                      //         if (name.isSelected) {
                      //           assignToStudent.add(names[_index]);
                      //         } else {
                      //           assignToStudent.remove(names[_index]);
                      //         }
                      //       });
                      //     }),
                      // IconButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         nameList.removeItem(name);
                      //         names.remove(name);
                      //       });
                      //     },
                      //     icon: const Icon(Icons.delete_forever_rounded)),
                    ],
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
                            //margin: const EdgeInsets.all(122.0),
                            color: Colors.blue[400],
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    name.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    name.meaning,
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

  Widget buildImage(String img, int index) {
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

  Widget buildIndicator(List<String> images) => AnimatedSmoothIndicator(
        activeIndex: images.isEmpty
            ? 0
            : activateIndex % images.length, //== 0 ? 1 : images.length
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

  // Future teachStudent() async {
  //   if (assignToStudent.isEmpty) {
  //     //alert popup
  //     _showMaterialDialog();
  //   } else {
  //     String? selectedDirectory = await FilePicker.platform
  //         .getDirectoryPath(dialogTitle: 'Choose student\'s folder');

  //     if (selectedDirectory == null) {
  //       // User canceled the picker
  //     } else {
  //       selectedDirectory.replaceAll('\\', '/');

  //       File(selectedDirectory + '/Lesson/Noun/noun.txt')
  //           .createSync(recursive: true);
  //       _write(File(selectedDirectory + '/Lesson/Noun/noun.txt'));
  //       copyImage(selectedDirectory + '/Lesson/Noun');
  //       copyAudio(selectedDirectory + '/Lesson/Noun');
  //     }
  //   }
  // }

  // Future<void> copyAudio(String destination) async {
  //   for (NounItem name in assignToStudent) {
  //     File file = File(name.audio);
  //     await file.copy(destination + '/${file.path.split('/').last}');
  //   }
  // }

  // Future<void> copyImage(String destination) async {
  //   for (NounItem name in assignToStudent) {
  //     String folder = name.dir.split('/').last;
  //     final newDir =
  //         await Directory(destination + '/$folder').create(recursive: true);
  //     final oldDir = Directory(name.dir);

  //     await for (var original in oldDir.list(recursive: false)) {
  //       if (original is File) {
  //         await original
  //             .copy('${newDir.path}/${original.path.split('\\').last}');
  //       }
  //     }
  //   }
  // }

  // Future _write(File file) async {
  //   for (NounItem name in assignToStudent) {
  //     await file.writeAsString(
  //         name.text +
  //             '; ' +
  //             name.meaning +
  //             '; ' +
  //             name.dir +
  //             '; ' +
  //             name.audio +
  //             '\n',
  //         mode: FileMode.append);
  //   }
  // }

  // _dismissDialog() {
  //   Navigator.pop(context);
  // }

  // void _showMaterialDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('No item was selected'),
  //           content:
  //               const Text('Please select at least one item before assigning'),
  //           actions: <Widget>[
  //             TextButton(
  //                 onPressed: () {
  //                   _dismissDialog();
  //                 },
  //                 child: const Text('Close')),
  //           ],
  //         );
  //       });
  // }
}
