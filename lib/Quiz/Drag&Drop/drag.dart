import 'dart:io';
// import 'dart:math';
import 'dart:async';

// import 'package:confetti/confetti.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:student/Quiz/Drag&Drop/drag_question.dart';
import 'package:student/Quiz/Drag&Drop/readFile.dart';
import 'package:student/Reward/rewardInterface.dart';
import 'package:student/globals.dart' as globals;

//for preview option
class ItemModel {
  String value;
  bool accepting;

  ItemModel(this.value, {this.accepting = false});
}

class Drag extends StatefulWidget {
  // Drag() {
  //   DartVLC.initialize(useFlutterNativeView: true);
  // }
  @override
  State<Drag> createState() => _DragState();
}

class _DragState extends State<Drag> {
  DragQuestionFileReader fileReader =
      DragQuestionFileReader('${globals.folderPath}/Quiz/DragDrop/drag.json');

  List<DragQuestion> dragQuestions = [];

  int _index = 0, total_solved = 0, len = 0;
  int wrong_tries = 0;
  int score = 0;

  late Timer _timer;
  int _start = 0;

  bool gameOver = false;
  List<ItemModel> items1 = [];
  List<ItemModel> items2 = [];
  String question = '';

  final player = Player(id: 6600);

  // MediaType mediaType = MediaType.file;
  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();

  // List<Media> medias = <Media>[];
  // List<Device> devices = <Device>[];

  double bufferingProgress = 0.0;
  // List<File> files = [];

  _DragState() {
    dragQuestions = fileReader.dragQuestions;
    len = dragQuestions.length;

    // final media = Media.asset('assets/Audios/win.wav');
    // player.open(media, autoStart: false);

    startTimer();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
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
      // player.videoDimensionsStream.listen((videoDimensions) {
      //   videoDimensions = videoDimensions;
      // });
      player.bufferingProgressStream.listen(
        (bufferingProgress) {
          setState(() {
            this.bufferingProgress = bufferingProgress;
          });
        },
      );
      player.errorStream.listen((event) {
        throw Error(); //'libvlc error.'
      });
      // devices = Devices.all;
      Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
      equalizer.setPreAmp(10.0);
      equalizer.setBandAmp(31.25, 10.0);
      player.setEqualizer(equalizer);
      player.open(
          Media.file(File('D:/Sadi/Student/student/assets/Audios/win.wav')),
          autoStart: false); //'assets/Audios/win.wav'//asset file did not work
    }
    initDrag();
  }

  @override
  void dispose() {
    _timer.cancel();
    player.dispose();
    super.dispose();
  }

  initDrag() {
    score = 0;
    gameOver = false;
    // print(dragQuestions.length);
    prepareQuestion();

    items1.shuffle();
    items2.shuffle();
  }

  void prepareQuestion() {
    for (int i = 0; i < dragQuestions[_index].values.length; i++) {
      String filePath =
          '${globals.folderPath}/Quiz/DragDrop/${dragQuestions[_index].files[i]}';
      ItemModel item =
          ItemModel('$filePath space ${dragQuestions[_index].values[i]}');
      items1.add(item);
    }
    for (int i = 0; i < dragQuestions[_index].valuesRight.length; i++) {
      ItemModel item = ItemModel(dragQuestions[_index].valuesRight[i]);
      items2.add(item);
    }
    question = dragQuestions[_index].question;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
  }

  void nextStep() {
    setState(() {
      gameOver = true;
      _timer.cancel();
    });
    writeInFile('drag & drop', _start, wrong_tries);
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RewardInterface('drag & drop')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (score == items1.length + score) {
      total_solved += 1;
      if (total_solved == len) {
        nextStep();
      } else {
        setState(() {
          // score = 0;
          _index = (_index + 1) % len;
          initDrag();
        });
      }
      // _confettiController.play();
    }
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text.rich(TextSpan(children: [
            const TextSpan(
                text: 'স্কোর : ', //'Score: ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            TextSpan(
                text: '$score / ${items1.length + score}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
          ]))),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                'প্রশ্ন. $question',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              // gameOver == false?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //CENTER LEFT -- Emit right
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: ConfettiWidget(
                  //     confettiController: _confettiLeftController,
                  //     blastDirection: 0, // radial value - RIGHT
                  //     emissionFrequency: 0.09,
                  //     minimumSize: const Size(8,
                  //         8), // set the minimum potential size for the confetti (width, height)
                  //     maximumSize: const Size(18,
                  //         18), // set the maximum potential size for the confetti (width, height)
                  //     numberOfParticles: 7,
                  //     gravity: 0.1,
                  //   ),
                  // ),
                  Column(
                    children: items1.map((item) {
                      return Container(
                        margin:
                            const EdgeInsets.fromLTRB(100.0, 10.0, 25.0, 8.0),
                        child: Draggable<ItemModel>(
                          data: item,
                          childWhenDragging: SizedBox(
                              height: 150,
                              width: 150,
                              child: Image.file(
                                File(item.value.split(' space ').first),
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                //colorBlendMode: BlendMode.darken,
                              )),
                          feedback: SizedBox(
                              height: 100,
                              width: 150,
                              child: Image.file(
                                File(item.value.split(' space ').first),
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              )),
                          child: SizedBox(
                              height: 150,
                              width: 200,
                              child: Image.file(
                                File(item.value.split(' space ').first),
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              )),
                        ),
                      );
                    }).toList(),
                  ),

                  // Align(
                  //   alignment: Alignment.center,
                  //   child: ConfettiWidget(
                  //     confettiController: _smallConfettiController,
                  //     blastDirectionality: BlastDirectionality.explosive,
                  //     // don't specify a direction, blast randomly
                  //     shouldLoop:
                  //         false, // start again as soon as the animation is finished
                  //     colors: const [
                  //       Colors.green,
                  //       Colors.blue,
                  //       Colors.pink,
                  //       Colors.orange,
                  //       Colors.purple
                  //     ], // manually specify the colors to be used
                  //     createParticlePath:
                  //         drawStar, // define a custom shape/path.
                  //   ),
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: items2.map((item) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(25, 10, 100, 8.0),
                        child: DragTarget<ItemModel>(
                          onAccept: (receivedItem) async {
                            if (item.value ==
                                receivedItem.value.split(' ').last) {
                              setState(() {
                                // playConfetti = true;
                                // _smallConfettiController.play();
                                // _confettiRightController.play();
                                // _confettiLeftController.play();

                                items1.remove(receivedItem);
                                items2.remove(item);
                                //dispose();
                                score += 1;
                                player.play();
                                item.accepting = false;
                              });

                              // await audioPlay();
                            } else {
                              setState(() {
                                //score -= 1;
                                item.accepting = false;
                                wrong_tries += 1;
                                // playConfetti = false;
                              });
                            }
                          },
                          onLeave: (receivedItem) {
                            setState(() {
                              item.accepting = false;
                              // playConfetti = false;
                              //audioPlayer.stop();
                            });
                          },
                          onWillAccept: (receivedItem) {
                            setState(() {
                              item.accepting = true;
                              // playConfetti = false;
                            });
                            return true;
                          },
                          builder: (context, acceptedItem, rejectedItem) =>
                              Container(
                            color: item.accepting ? Colors.red : Colors.blue,
                            height: 70,
                            width: 150,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(8.0),
                            child: Text(item.value,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  //CENTER RIGHT -- Emit left
                  //     Align(
                  //       alignment: Alignment.centerRight,
                  //       child: ConfettiWidget(
                  //         confettiController: _confettiRightController,
                  //         blastDirection: pi, // radial value - LEFT
                  //         particleDrag: 0.05, // apply drag to the confetti
                  //         emissionFrequency: 0.09, // how often it should emit
                  //         numberOfParticles: 7, // number of particles to emit
                  //         gravity: 0.1, // gravity - or fall speed
                  //         shouldLoop: false,
                  //         colors: const [
                  //           Colors.green,
                  //           Colors.blue,
                  //           Colors.pink
                  //         ], // manually specify the colors to be used
                  //         // strokeWidth: 1,
                  //         // strokeColor: Colors.white,
                  //       ),
                  //     ),
                ],
              ) //,
              // : _showReward()
            ],
          ),
        ),
      ),
    );
  }

  // Widget _showReward() {
  //   return Column(
  //     children: <Widget>[
  //       const Text('Quiz Complete !!!',
  //           style: TextStyle(
  //             color: Colors.blue,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 30,
  //           )),
  //       const SizedBox(height: 30),
  //       //_confetti(_confettiController, true),
  //       const SizedBox(height: 30),
  //       Center(
  //         child: SizedBox(
  //             height: 250,
  //             width: 300,
  //             child: Image.file(
  //               File(
  //                   'D:/Sadi/FlutterProjects/Flutter_Desktop_Application-main/assets/Rewards/congrats2.gif'),
  //               fit: BoxFit.contain,
  //               filterQuality: FilterQuality.high,
  //             )),
  //       ),
  //     ],
  //   );
  // }

  void writeInFile(String quizType, int time, int wrongTries) async {
    File file = File(globals.logFilePath);
    final dateTime = DateTime.now();
    await file.writeAsString('$quizType; $time; $wrongTries; $dateTime\n',
        mode: FileMode.append);
  }
}
