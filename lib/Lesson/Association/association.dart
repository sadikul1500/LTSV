//https://pastebin.com/ZSgj4LU3
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:student/Lesson/Association/association_search.dart';
import 'package:student/Lesson/Association/association_video.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student/Lesson/Association/association_list.dart';

class Association extends StatefulWidget {
  @override
  State<Association> createState() => _AssociationState();
}

class _AssociationState extends State<Association> {
  AssociationList associationList = AssociationList();
  late List<AssociationItem> associations;
  late AssociationVideoCard associationVideoCard;
  List<AssociationItem> assignToStudent = [];
  int _index = 0;
  late Player videoPlayer;
  late int len;
  List<String> imageList = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  final CarouselController _controller = CarouselController();
  int activateIndex = 0;

  bool _isPlaying = false;
  bool carouselAutoPlay = false;
  bool _isPaused = true;

  Widget _associationCard() {
    if (associations.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: Text(
            'No Data Found!!!',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      );
    } else {
      loadData();
    }
    if (imageList.isEmpty) {
      return associationVideoWidgetCard();
    } else {
      if (_audioPlayer.processingState != ProcessingState.ready) {
        loadAudio();

        return const CircularProgressIndicator();
      }

      return associationCardWidget();
    }
  }

  _AssociationState() {
    _index = 0;
    videoPlayer = Player(
      id: 0,
      //videoDimensions: VideoDimensions(640, 360),
      registerTexture: false,
    );
  }

  @override
  initState() {
    super.initState();
    proxyInitState();
  }

  proxyInitState() {
    associations = associationList.getList();
    len = associations.length;
    loadData(); //check if it is image and audio //.then((List<String> value) {    //   if (value.isNotEmpty)
    if (imageList.isNotEmpty) {
      loadAudio().then((value) {
        _associationCard();
      });
    }
  }

  @override
  void dispose() {
    videoPlayer.dispose();
    super.dispose();
  }

  List<String> loadData() {
    if (associations.isEmpty) {
      return []; //await loadData();
    }

    imageList = associations[_index].imgList;

    return imageList;
  }

  Future loadAudio() async {
    await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.file(associations[_index].audio)),
        initialPosition: Duration.zero,
        preload: true);

    _audioPlayer.setLoopMode(LoopMode.one);
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {});
    });
    return _audioPlayer;
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
            'Association',
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
                    delegate: AssociationSearch(associations),
                  );
                  setState(() {
                    _index = max(
                        0,
                        associations
                            .indexWhere((element) => element.text == result));
                  });
                },
                icon: const SafeArea(child: Icon(Icons.search_sharp)))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _associationCard(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      stop();

                      setState(() {
                        _isPlaying = false;

                        try {
                          _index = (_index - 1) % len;
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
                          icon: (_isPaused)
                              ? const Icon(Icons.play_circle_outline)
                              : const Icon(Icons.pause_circle_filled),
                          iconSize: 40,
                          onPressed: () {
                            if (!_isPaused) {
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
                        } catch (e) {
                          //print(e);
                        }
                      });
                    },
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
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      minimumSize: const Size(100, 42),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: Row(
          children: [
            const SizedBox(width: 25.0),
            FloatingActionButton.extended(
              heroTag: 'btn1',
              onPressed: () {
                stop();
                teachStudent();
              },
              icon: const Icon(Icons.add),
              label: const Text('Assign to student',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
            const Spacer(),
            FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: () async {
                stop();

                await Navigator.of(context)
                    .pushNamed('/associationForm')
                    .then((value) => setState(() {
                          proxyInitState();
                        }));
              },
              icon: const Icon(Icons.add),
              label: const Text('Add an Association',
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future stop() async {
    if (imageList.isNotEmpty) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _isPaused = true;
        carouselAutoPlay = false;
      });
    } else {
      videoPlayer.stop();
    }
  }

  pause() {
    _audioPlayer.pause();
    setState(() {
      _isPaused = true;
      carouselAutoPlay = false;
    });
  }

  Future play() async {
    _audioPlayer.play();

    setState(() {
      _isPlaying = true;
      _isPaused = false;
      carouselAutoPlay = true;
    });
    //}
  }

  Widget associationVideoWidgetCard() {
    AssociationItem association = associations.elementAt(_index);
    associationVideoCard =
        AssociationVideoCard(associations[_index].video, videoPlayer);
    return Card(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const SizedBox(height: 15),
                    associationVideoCard.getAssociationVideoCard(),
                    const SizedBox(height: 15),
                  ],
                ),
                rightSidePanel(association)
              ])),
    ); //associationVideoCard.getAssociationVideoCard();
  }

  Widget associationCardWidget() {
    AssociationItem association = associations.elementAt(_index);
    List<String> images = association.getImgList();

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
                    itemCount: images.length,
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
                      if (index >= images.length) {
                        index = 0;
                      }
                      final img = images[index];

                      return buildImage(img, index);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                buildIndicator(images),
              ],
            ),
            rightSidePanel(association)
          ],
        ),
      ),
    );
  }

  Widget rightSidePanel(AssociationItem association) {
    return SizedBox(
      width: 500,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checkbox(
                  value: association.isSelected,
                  onChanged: (value) {
                    //setState(() {
                    association.isSelected = !association.isSelected;
                    if (association.isSelected) {
                      assignToStudent.add(associations[_index]);
                    } else {
                      assignToStudent.remove(associations[_index]);
                    }
                    //});
                  }),
              IconButton(
                  onPressed: () {
                    setState(() {
                      associationList.removeItem(association);
                      proxyInitState();
                    });
                  },
                  tooltip: 'Remove this item',
                  icon: const Icon(Icons.delete_forever_rounded)),
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
                            association.text,
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
        activeIndex: activateIndex % images.length,
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

  Future teachStudent() async {
    if (assignToStudent.isEmpty) {
      //alert popup
      _showMaterialDialog();
    } else {
      String? selectedDirectory = await FilePicker.platform
          .getDirectoryPath(dialogTitle: 'Choose student\'s folder');

      if (selectedDirectory == null) {
        // User canceled the picker
      } else {
        selectedDirectory.replaceAll('\\', '/');

        File(selectedDirectory + '/Lesson/Association/association.txt')
            .createSync(recursive: true);
        _write(File(selectedDirectory + '/Lesson/Association/association.txt'));
        copyImage(selectedDirectory + '/Lesson/Association');
        copyAudio(selectedDirectory + '/Lesson/Association');
        copyVideo(selectedDirectory + '/Lesson/Association');
      }
    }
  }

  Future<void> copyAudio(String destination) async {
    for (AssociationItem association in assignToStudent) {
      if (association.audio.isNotEmpty) {
        File file = File(association.audio);
        await file.copy(destination + '/${file.path.split('/').last}');
      }
    }
  }

  Future<void> copyVideo(String destination) async {
    for (AssociationItem association in assignToStudent) {
      if (association.video.isNotEmpty) {
        File file = File(association.video);
        await file.copy(destination + '/${file.path.split('/').last}');
      }
    }
  }

  Future<void> copyImage(String destination) async {
    for (AssociationItem association in assignToStudent) {
      if (association.dir.isNotEmpty) {
        String folder = association.dir.split('/').last;
        final newDir =
            await Directory(destination + '/$folder').create(recursive: true);
        final oldDir = Directory(association.dir);

        await for (var original in oldDir.list(recursive: false)) {
          if (original is File) {
            await original
                .copy('${newDir.path}/${original.path.split('\\').last}');
          }
        }
      }
    }
  }

  Future _write(File file) async {
    for (AssociationItem association in assignToStudent) {
      await file.writeAsString(
          association.text +
              '; ' +
              association.meaning +
              '; ' +
              association.dir +
              '; ' +
              association.audio +
              '; ' +
              association.video +
              '\n',
          mode: FileMode.append);
    }
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No item was selected'),
            content:
                const Text('Please select at least one item before assigning'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: const Text('Close')),
            ],
          );
        });
  }
}