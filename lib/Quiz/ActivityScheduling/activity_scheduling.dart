import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student/Quiz/ActivityScheduling/activity_list.dart';

import 'package:student/Quiz/ActivityScheduling/readFile.dart';
import 'package:student/globals.dart' as globals;

class ItemModel {
  //same as Quiz/DragDrop/item_model.dart
  String value;
  bool accepting; //on will accept
  bool isSuccessful;
  ItemModel(this.value, {this.accepting = false, this.isSuccessful = false});
}

class ActivityScheduling extends StatefulWidget {
  // final List<File> files;
  //List<ItemModel> values = [];
  //final List<ItemModel> items2;
  //final String question;
  // const ActivityDrag(); //this.items2, this.question this.files
  @override
  State<ActivityScheduling> createState() => _ActivityDragState();
}

class _ActivityDragState extends State<ActivityScheduling> {
  ActivityFileReader fileReader = ActivityFileReader(
      '${globals.folderPath}/Quiz/Activity_Scheduling/activity_scheduling.txt');
  List<ActivityList> activityList = [];

  List<ItemModel> values = []; //drag target
  List<ItemModel> items = []; //draggable

  _ActivityDragState() {
    activityList = fileReader.activityList.cast<ActivityList>();
  }
  @override
  initState() {
    final len = activityList.length;
    //widget.items.shuffle();
    //var values = List<int>.generate(widget.items.length, (i) => i);
    for (int i = 0; i < len; i++) {
      values.add(ItemModel(i.toString()));
      items.add(ItemModel('${activityList[i].image} space $i'));
    }
    //print(items[0].value);
    items.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Quiz'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Row(
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
                            // playConfetti = true;
                            // _smallConfettiController.play();
                            // _confettiRightController.play();
                            // _confettiLeftController.play();

                            items.remove(receivedItem);
                            // widget.items2.remove(item);
                            //dispose();
                            // score += 1;
                            //item = receivedItem;
                            item.accepting = false;
                            item.isSuccessful = true;
                            item.value = receivedItem.value;
                            //print('....matched......'); //hot reload.....
                          });

                          //await audioPlay();
                        } else {
                          setState(() {
                            //score -= 1;
                            // print('*' +
                            //     item.value +
                            //     '*aaa*' +
                            //     receivedItem.value.split(' space ').last +
                            //     "*");
                            item.accepting = false;
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
          )),
    );
  }
}
