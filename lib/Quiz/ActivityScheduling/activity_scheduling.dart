import 'dart:async';
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:student/Quiz/ActivityScheduling/activity_list.dart';

import 'package:student/Quiz/ActivityScheduling/readFile.dart';
import 'package:student/Reward/rewardInterface.dart';
import 'package:student/globals.dart' as globals;

class ItemModel {
  //same as Quiz/DragDrop/item_model.dart
  String value;
  bool accepting; //on will accept
  bool isSuccessful;
  ItemModel(this.value, {this.accepting = false, this.isSuccessful = false});
}

class ActivityScheduling extends StatefulWidget {
  @override
  State<ActivityScheduling> createState() => _ActivityDragState();
}

class _ActivityDragState extends State<ActivityScheduling> {
  ActivityFileReader fileReader = ActivityFileReader(
      '${globals.folderPath}/Quiz/Activity_Scheduling/activity_scheduling.txt');
  List<ActivityList> activityList = [];

  List<ItemModel> values = []; //drag target
  List<ItemModel> items = []; //draggable

  int wrong_tries = 0, score = 0, _start = 0, len = 0;
  late Timer _timer;

  final player = Player(id: 7711);

  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  double bufferingProgress = 0.0;

  _ActivityDragState() {
    activityList = fileReader.activityList;
    startTimer();
  }
  @override
  initState() {
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

  @override
  void dispose() {
    _timer.cancel();
    player.dispose();
    super.dispose();
  }

  void proxyInitState() {
    len = activityList.length;
    //widget.items.shuffle();
    //var values = List<int>.generate(widget.items.length, (i) => i);
    for (int i = 0; i < len; i++) {
      values.add(ItemModel(i.toString()));
      items.add(ItemModel('${activityList[i].image} space $i'));
    }
    //print(items[0].value);
    items.shuffle();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (score == len) {
      nextStep();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('কর্মধারা পরীক্ষা'), //'Activity Quiz'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'বামপাশ থেকে ড্র্যাগ করে ডানপাশের সাথে ম্যাচ করুন',
            style: TextStyle(fontSize: 22),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(minHeight: 400),
                padding: const EdgeInsets.all(10),
                //height: MediaQuery.of(context).size.height,
                width: 550,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2)),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 10,
                  children: items.map((item) {
                    return Draggable<ItemModel>(
                      data: item,
                      childWhenDragging: Container(
                          alignment: Alignment.center,
                          height: 168,
                          width: 248,
                          child: Image.file(
                              File(item.value.split(' space ').first),
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              colorBlendMode: BlendMode.modulate,
                              color: Colors.white.withOpacity(0.4))),
                      feedback: SizedBox(
                          //child that I drop....
                          height: 168,
                          width: 248,
                          child: Image.file(
                            File(item.value.split(' space ').first),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          )),
                      child: SizedBox(
                          height: 168,
                          width: 248,
                          //alignment: Alignment.center,
                          child: Image.file(
                            File(item.value.split(' space ').first),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          )),
                    );
                  }).toList(),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minHeight: 400),
                padding: const EdgeInsets.all(10),
                //height: MediaQuery.of(context).size.height,
                width: 550,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2)),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 10,
                  children: values.map((item) {
                    return DragTarget<ItemModel>(
                      onAccept: (receivedItem) async {
                        if (item.value ==
                            receivedItem.value.split(' space ').last) {
                          setState(() {
                            items.remove(receivedItem);

                            score += 1;
                            player.play();

                            item.accepting = false;
                            item.isSuccessful = true;
                            item.value = receivedItem.value;
                            //print('....matched......'); //hot reload.....
                          });

                          //await audioPlay();
                        } else {
                          setState(() {
                            item.accepting = false;
                            wrong_tries += 1;
                            //playConfetti = false;
                          });
                        }
                      },
                      onLeave: (receivedItem) {
                        setState(() {
                          item.accepting = false;
                          //playConfetti = false;
                          //audioPlayer.stop();
                        });
                      },
                      onWillAccept: (receivedItem) {
                        setState(() {
                          item.accepting = true;
                          //playConfetti = false;
                        });
                        return true;
                      },
                      builder: (context, acceptedItem, rejectedItem) =>
                          Container(
                        color: item.accepting
                            ? Colors.red
                            : item.isSuccessful
                                ? Colors.white
                                : Colors.blue,
                        height: 168,
                        width: 248,
                        alignment: Alignment.center,
                        //margin: const EdgeInsets.all(8.0),
                        child: item.isSuccessful
                            ? Image.file(
                                File(item.value.split(' space ').first),
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              )
                            : Text((int.parse(item.value) + 1).toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0)),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          const SizedBox(height: 70)
        ],
      ),
    );
  }

  void nextStep() {
    setState(() {
      // gameOver = true;
      _timer.cancel();
    });
    writeInFile('activity scheduling', _start, wrong_tries);
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RewardInterface('activity scheduling')),
      );
    });
  }

  void writeInFile(String quizType, int time, int wrongTries) async {
    File file = File(globals.logFilePath);
    final dateTime = DateTime.now();
    await file.writeAsString(
        '$quizType; $time; $wrongTries; $dateTime; ${activityList[0].topic}\n',
        mode: FileMode.append);
  }
}
