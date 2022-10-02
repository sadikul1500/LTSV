//https://pastebin.com/ZSgj4LU3
//working version.... edit here....
//screenshot package didn't work....
//trying with RenderRepaintBoundary... it shws wrong... couldn't even write and run code....
//snapShot...............
//list items in a LIST.........
//import 'dart:ffi';

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:student/Quiz/Matching/matching_list.dart';
// import 'package:student/Lesson/Activity/activity_search.dart';
import 'package:student/Quiz/Matching/readFile.dart';
import 'package:student/Reward/rewardInterface.dart';

import 'package:student/globals.dart' as globals;

class Matching extends StatefulWidget {
  @override
  State<Matching> createState() => _MatchingState();
}

class _MatchingState extends State<Matching> {
  MatchingFileReader fileReader =
      MatchingFileReader('${globals.folderPath}/Quiz/Matching/matching.txt');

  List<MatchingList> matchinges = [];

  int _index = 0;
  int wrong_tries = 0;
  int score = 0;

  late Timer _timer;
  int _start = 0;
  List<bool> hasPressed = [false, false, false, false];
  List<bool> isCorrect = [false, false, false, false];
  bool hasAnswered = false;

  late int len;
  // late File file;

  _MatchingState() {
    _index = 0;
  }

  @override
  initState() {
    super.initState();

    proxyInitState();
  }

  proxyInitState() {
    File(globals.logFilePath).createSync(recursive: true);
    matchinges = fileReader.matchingList;
    len = matchinges.length;
    startTimer();
    // listenStreams();
  }

  void listenStreams() {
    // if (mounted) {
    //   videoPlayer.currentStream.listen((current) {
    //     this.current = current;
    //   });
    //   videoPlayer.positionStream.listen((position) {
    //     this.position = position;
    //   });
    //   videoPlayer.playbackStream.listen((playback) {
    //     this.playback = playback;
    //   });
    //   videoPlayer.generalStream.listen((general) {
    //     general = general;
    //   });
    //   videoPlayer.videoDimensionsStream.listen((videoDimensions) {
    //     videoDimensions = videoDimensions;
    //   });
    //   videoPlayer.bufferingProgressStream.listen(
    //     (bufferingProgress) {
    //       bufferingProgress = bufferingProgress;
    //     },
    //   );
    //   videoPlayer.errorStream.listen((event) {
    //     throw Error(); //'libvlc error.'
    //   });
    //   //devices = Devices.all;
    //   Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
    //   equalizer.setPreAmp(10.0);
    //   equalizer.setBandAmp(31.25, 10.0);
    //   videoPlayer.setEqualizer(equalizer);
    //   // videoPlayer.open(Playlist(medias: medias), autoStart: false);
    // }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // void createPlaylist(int index) {
  //   medias = [Media.file(File(activities[index].video))];
  //   print(medias.length);
  //   videoPlayer.open(Playlist(medias: medias), autoStart: false);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // stop();
        _timer.cancel();
        // print('this cancel called');
        setState(() {});

        Navigator.pop(context);

        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Text(
              'Activity',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              matchinges.isEmpty
                  ? const SizedBox(
                      height: 400,
                      child: Center(
                        child: Text(
                          'No Data Found!!!',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.fromLTRB(120, 30, 120, 0),
                      color: Colors.white.withOpacity(0.80),
                      child: Align(
                          alignment: const Alignment(0, 0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  _timer.cancel();
                                  _start = 0;
                                  startTimer();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(24)),
                                child: Text(
                                  '$_start',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              // Container(
                              //   decoration: const BoxDecoration(
                              //       color: Colors.blueAccent, shape: BoxShape.circle),
                              //   child: Text('$_start'),
                              // ),
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      height: 300,
                                      width: 400,
                                      child: Image.file(
                                        File(matchinges[_index].image),
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      )),
                                  const SizedBox(width: 100),
                                  Column(children: <Widget>[
                                    Text('Q. ${matchinges[_index].question}',
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 200.0,
                                          height: 50.0,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // _timer.cancel();
                                              if (!hasAnswered) {
                                                hasPressed[0] = true;
                                                hasAnswered = true;

                                                if (matchinges[_index].answer ==
                                                    'A') {
                                                  setState(() {
                                                    _timer.cancel();
                                                    isCorrect[0] = true;
                                                    score += 1;
                                                    popup('Congratulations',
                                                        'Wooha!!!! You have given correct answer');
                                                    Future.delayed(
                                                            const Duration(
                                                                seconds: 3))
                                                        .then((_) {
                                                      nextStep();
                                                    });
                                                  });
                                                } else {
                                                  wrong_tries += 1;
                                                  popup('Wrong answer',
                                                      'You have selected the wrong option $_start');
                                                  int index = matchinges[_index]
                                                          .answer
                                                          .codeUnits[0] -
                                                      'A'.codeUnits[0];
                                                  setState(() {
                                                    // isCorrect[index] = true;
                                                    // hasPressed[index] = true;
                                                  });
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: hasPressed[0]
                                                    ? (isCorrect[0]
                                                        ? Colors.green[700]
                                                        : Colors.red[700])
                                                    : Colors.blueAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                )),
                                            child: Text(
                                                'A. ${matchinges[_index].options[0]}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                        const SizedBox(width: 100),
                                        SizedBox(
                                          width: 200.0,
                                          height: 50.0,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (!hasAnswered) {
                                                hasPressed[1] = true;
                                                hasAnswered = true;
                                                if (matchinges[_index].answer ==
                                                    'B') {
                                                  setState(() {
                                                    score += 1;
                                                    isCorrect[1] = true;
                                                    _timer.cancel();
                                                    popup('Congratulations',
                                                        'Wooha!!!! You have given correct answer');
                                                    Future.delayed(
                                                            const Duration(
                                                                seconds: 3))
                                                        .then((_) {
                                                      nextStep();
                                                    });
                                                  });
                                                } else {
                                                  wrong_tries += 1;
                                                  popup('Wrong answer',
                                                      'You have selected the wrong option $_start');
                                                  int index = matchinges[_index]
                                                          .answer
                                                          .codeUnits[0] -
                                                      'A'.codeUnits[0];
                                                  setState(() {
                                                    // isCorrect[index] = true;
                                                    // hasPressed[index] = true;
                                                  });
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: hasPressed[1]
                                                    ? (isCorrect[1]
                                                        ? Colors.green[700]
                                                        : Colors.red[700])
                                                    : Colors.blueAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                )),
                                            child: Text(
                                                'B. ${matchinges[_index].options[1]}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 200.0,
                                          height: 50.0,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // _timer.cancel();
                                              if (!hasAnswered) {
                                                hasPressed[2] = true;
                                                hasAnswered = true;
                                                if (matchinges[_index].answer ==
                                                    'C') {
                                                  setState(() {
                                                    isCorrect[2] = true;
                                                    _timer.cancel();
                                                    score += 1;
                                                    popup('Congratulations',
                                                        'Wooha!!!! You have given correct answer');
                                                    Future.delayed(
                                                            const Duration(
                                                                seconds: 3))
                                                        .then((_) {
                                                      nextStep();
                                                    });
                                                  });
                                                } else {
                                                  wrong_tries += 1;
                                                  popup('Wrong answer',
                                                      'You have selected the wrong option $_start ');
                                                  int index = matchinges[_index]
                                                          .answer
                                                          .codeUnits[0] -
                                                      'A'.codeUnits[0];
                                                  setState(() {
                                                    // isCorrect[index] = true;
                                                    // hasPressed[index] = true;
                                                  });
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: hasPressed[2]
                                                    ? (isCorrect[2]
                                                        ? Colors.green[700]
                                                        : Colors.red[700])
                                                    : Colors.blueAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                )),
                                            child: Text(
                                                'C. ${matchinges[_index].options[2]}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                        const SizedBox(width: 100),
                                        SizedBox(
                                          width: 200.0,
                                          height: 50.0,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // _timer.cancel();
                                              if (!hasAnswered) {
                                                hasPressed[3] = true;
                                                hasAnswered = true;
                                                if (matchinges[_index].answer ==
                                                    'D') {
                                                  setState(() {
                                                    isCorrect[3] = true;
                                                    score += 1;
                                                    _timer.cancel();
                                                    popup('Congratulations',
                                                        'Wooha!!!! You have given correct answer');
                                                    Future.delayed(
                                                            const Duration(
                                                                seconds: 3))
                                                        .then((_) {
                                                      nextStep();
                                                    });
                                                  });
                                                } else {
                                                  wrong_tries += 1;
                                                  popup('Wrong answer',
                                                      'You have selected the wrong option $_start');
                                                  int index = matchinges[_index]
                                                          .answer
                                                          .codeUnits[0] -
                                                      'A'.codeUnits[0];
                                                  setState(() {
                                                    //isCorrect[3] = false;
                                                    // isCorrect[index] = true;
                                                    // hasPressed[index] = true;
                                                  });
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: hasPressed[3]
                                                    ? (isCorrect[3]
                                                        ? Colors.green[700]
                                                        : Colors.red[700])
                                                    : Colors.blueAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                )),
                                            child: Text(
                                                'D. ${matchinges[_index].options[3]}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ],
                              ),
                              //Text(widget.question.correctAnswer),
                            ],
                          )),
                    ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // children: <Widget>[
                // ElevatedButton.icon(
                //   onPressed: () {
                //     // stop();

                //     setState(() {
                //       // videoPlayer.previous();
                //       try {
                //         _index = (_index - 1) % len;
                //         // createPlaylist(_index);
                //         //files.clear();
                //       } catch (e) {
                //         //print(e);
                //       }
                //     });
                //   },
                //   label: const Text(
                //     'Prev',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 17,
                //     ),
                //   ),
                //   icon: const Icon(
                //     Icons.navigate_before,
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     alignment: Alignment.center,
                //     minimumSize: const Size(100, 42),
                //   ),
                // ),
                // const SizedBox(width: 30),
                // const SizedBox(width: 30),
                // ElevatedButton(
                //   onPressed: () {
                //     // stop();
                //     setState(() {
                //       // videoPlayer.next();
                //       try {
                //         _index = (_index + 1) % len;
                //         // createPlaylist(_index);
                //         //files.clear();
                //       } catch (e) {
                //         //print(e);
                //       }
                //     });
                //   },
                //   style: ElevatedButton.styleFrom(
                //     alignment: Alignment.center,
                //     minimumSize: const Size(100, 42),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: const <Widget>[
                //       Text('Next',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 17,
                //           )),
                //       SizedBox(
                //         width: 5,
                //       ),
                //       Icon(Icons.navigate_next_rounded),
                //     ],
                //   ),
                // ),
                // ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void popup(String title, String content) {
    bool manuallyClosed = false;
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (!manuallyClosed) {
        reset();
        Navigator.of(context).pop();
      }
    });
    showAnimatedDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          contentText: content,
          onPositiveClick: () {
            manuallyClosed = true;
            reset();
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            manuallyClosed = true;
            reset();
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.rotate3D,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  void nextStep() {
    if (score == len) {
      writeInFile('matching', _start, wrong_tries);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RewardInterface('matching')),
      );
    } else {
      setState(() {
        reset();
        _index = (_index + 1) % len;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
  }

  void reset() {
    hasAnswered = false;
    for (int i = 0; i < 4; i++) {
      hasPressed[i] = false;
      isCorrect[i] = false;
    }
    setState(() {});
  }

  void writeInFile(String quizType, int time, int wrongTries) async {
    File file = File(globals.logFilePath);
    final dateTime = DateTime.now();
    await file.writeAsString('$quizType; $time; $wrongTries; $dateTime\n',
        mode: FileMode.append);
  }

  // Future stop() async {
  //   videoPlayer.stop();
  // }

}
