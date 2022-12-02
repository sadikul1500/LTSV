import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_vlc/dart_vlc.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student/Quiz/JigsawPuzzle/jigsaw_list.dart';
import 'package:student/Quiz/JigsawPuzzle/puzzlePiece.dart';
import 'package:student/Quiz/JigsawPuzzle/readFile.dart';
import 'package:student/Reward/rewardInterface.dart';
import 'package:student/globals.dart' as globals;

//2X2 puzzle
class ItemModel {
  Uint8List bytes;
  bool accepting; //on will accept
  bool isSuccessful;
  ItemModel(this.bytes, {this.accepting = false, this.isSuccessful = false});
}

class Jigsaw extends StatefulWidget {
  @override
  State<Jigsaw> createState() => _JigsawState();
}

class _JigsawState extends State<Jigsaw> {
  JigsawFileReader fileReader =
      JigsawFileReader('${globals.folderPath}/Quiz/jigsaw/jigsaw.txt');
  List<JigsawList> jigsawList = [];

  late List<Uint8List> puzzlePieces; // = PuzzlePiece(widget.file)
  double? height = 400;
  double? width = 400;
  List<ItemModel> draggableObjects = [];
  List<ItemModel> dragTargetObjects = [];
  // List<bool> selected = [];
  List<File> assignToStudent = [];

  final player = Player(id: 7311);

  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  double bufferingProgress = 0.0;

  int currentIndex = 0;
  int len = 0;
  int level = 0, total_solved = 0;
  int wrong_tries = 0, score = 0;

  late Timer _timer;
  int _start = 0;
  late int childWhenDraggingHeight, childWhenDraggingWidth;

  _JigsawState() {
    jigsawList = fileReader.jigsawList;
    len = jigsawList.length;
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
    proxyInitState();
  }

  void proxyInitState() {
    // print('init state');

    // for (int i = 0; i < len; i++) {
    //   selected.add(false);
    // }
    loadPuzzlePiece();
    // loadAudio();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    player.dispose();
    super.dispose();
  }

  void loadPuzzlePiece() {
    // print('load puzzle piece');
    piecePuzzle(currentIndex);
    dragTargetObjects.clear();
    draggableObjects.clear();

    int numberOfPiece = int.parse(jigsawList[currentIndex].level) * 2;

    for (int i = 0; i < numberOfPiece; i++) {
      draggableObjects.add(ItemModel(puzzlePieces[i]));
      dragTargetObjects.add(ItemModel(puzzlePieces[i]));
    }
    draggableObjects.shuffle();
  }

  void piecePuzzle(int index) {
    level = int.parse(jigsawList[index].level);
    final object = PuzzlePiece(File(jigsawList[index].image), level);
    puzzlePieces = object.splitImage();
    childWhenDraggingHeight = object.height;
    childWhenDraggingWidth = object.width;
    try {
      height = Image.memory(puzzlePieces[0]).height;
      width = Image.memory(puzzlePieces[0]).width;
    } on Exception catch (_) {
      print('empty puzzle list');
    }
  }

  void nextStep() {
    setState(() {
      // gameOver = true;
      _timer.cancel();
    });
    writeInFile('jigsaw puzzle', _start, wrong_tries);
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RewardInterface('drag & drop')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (score == level * 2) {
      score = 0;
      total_solved += 1;

      if (total_solved == len) {
        nextStep();
      } else {
        setState(() {
          // score = 0;
          currentIndex = (currentIndex + 1) % len;
          proxyInitState();
        });
      }
    }
    //loadPuzzlePiece();
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Jigsaw Puzzle')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    constraints: const BoxConstraints(
                        minHeight: 350,
                        maxHeight: 400,
                        minWidth: 500,
                        maxWidth: 550),
                    color: Colors.grey[300],
                    child: Center(
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 2,
                        runSpacing: 2,
                        children: dragTargetObjects.map((item) {
                          return DragTarget<ItemModel>(
                            onAccept: (receivedItem) async {
                              if (item.bytes == receivedItem.bytes) {
                                setState(() {
                                  item.accepting = false;
                                  item.isSuccessful = true;
                                  draggableObjects.remove(receivedItem);
                                  score += 1;
                                });
                                player.play(); // await audioPlay();
                              } else {
                                setState(() {
                                  item.accepting = false;
                                  wrong_tries += 1;
                                });
                              }
                            },
                            onLeave: (receivedItem) {
                              setState(() {
                                item.accepting = false;
                              });
                            },
                            onWillAccept: (receivedItem) {
                              setState(() {
                                if (!item.isSuccessful) item.accepting = true;
                              });
                              return true;
                            },
                            builder: (context, acceptedItem, rejectedItem) =>
                                Container(
                                    decoration: BoxDecoration(
                                        color: item.accepting
                                            ? Colors.red
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: item.isSuccessful
                                                ? Colors.black
                                                : Colors.black12,
                                            width: item.isSuccessful ? 2 : 1)),
                                    height: height,
                                    width: width,
                                    child: Image.memory(item.bytes,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                        colorBlendMode: BlendMode.modulate,
                                        color: item.isSuccessful
                                            ? Colors.white.withOpacity(1.0)
                                            : item.accepting
                                                ? Colors.white.withOpacity(0.1)
                                                : Colors.white
                                                    .withOpacity(0.6))),
                          );
                        }).toList(),
                      ),
                    )),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    constraints: const BoxConstraints(
                        minHeight: 350,
                        maxHeight: 400,
                        minWidth: 500,
                        maxWidth: 550),
                    color: draggableObjects.isNotEmpty
                        ? Colors.grey[300]
                        : Colors.transparent,
                    child: Center(
                        child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 2,
                      runSpacing: 2,
                      children: draggableObjects.map((item) {
                        return Draggable<ItemModel>(
                          data: item,
                          childWhenDragging: Container(
                              alignment: Alignment.center,
                              height: childWhenDraggingHeight * .99,
                              width: childWhenDraggingWidth * .99,
                              child: Image.memory(item.bytes,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  colorBlendMode: BlendMode.modulate,
                                  color: Colors.white.withOpacity(0.4))),
                          feedback: SizedBox(
                              //child that I drop....
                              height: height,
                              width: width,
                              child: Image.memory(
                                item.bytes,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              )),
                          child: SizedBox(
                              height: height,
                              width: width,
                              //alignment: Alignment.center,
                              child: Image.memory(
                                item.bytes,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              )),
                        );
                      }).toList(),
                    )))
              ],
            )
          ],
        ),
      ),
    );
  }

  void writeInFile(String quizType, int time, int wrongTries) async {
    File file = File(globals.logFilePath);
    final dateTime = DateTime.now();
    await file.writeAsString('$quizType; $time; $wrongTries; $dateTime; ${jigsawList[0].topic}\n',
        mode: FileMode.append);
  }
}
