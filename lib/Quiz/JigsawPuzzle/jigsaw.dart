import 'dart:io';
import 'dart:typed_data';

import 'package:dart_vlc/dart_vlc.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student/Quiz/JigsawPuzzle/jigsaw_list.dart';
import 'package:student/Quiz/JigsawPuzzle/puzzlePiece.dart';
import 'package:student/Quiz/JigsawPuzzle/readFile.dart';
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
  List<bool> selected = [];
  List<File> assignToStudent = [];

  final player = Player(id: 7311);

  CurrentState current = CurrentState();
  PositionState position = PositionState();
  PlaybackState playback = PlaybackState();
  GeneralState general = GeneralState();
  double bufferingProgress = 0.0;

  int currentIndex = 0;
  int len = 0;

  _JigsawState() {
    jigsawList = fileReader.jigsawList;
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
  }

  void proxyInitState() {
    len = jigsawList.length;
    for (int i = 0; i < len; i++) {
      selected.add(false);
    }
    loadPuzzlePiece();
    // loadAudio();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void loadPuzzlePiece() {
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
    print('puzzle piece.....');
    final object = PuzzlePiece(
        File(jigsawList[index].image), int.parse(jigsawList[index].level));
    puzzlePieces = object.splitImage();
    try {
      height = Image.memory(puzzlePieces[0]).height;
      width = Image.memory(puzzlePieces[0]).width;
    } on Exception catch (_) {
      print('empty puzzle list');
    }
  }

  @override
  Widget build(BuildContext context) {
    //loadPuzzlePiece();
    return Scaffold(
      appBar: AppBar(title: const Text('Jigsaw Puzzle')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // SizedBox(
                  //   width: 400,
                  //   child: Row(
                  //     //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: <Widget>[
                  //       Checkbox(
                  //           value: selected[currentIndex],
                  //           onChanged: (value) {
                  //             setState(() {
                  //               selected[currentIndex] =
                  //                   !selected[currentIndex];
                  //               if (selected[currentIndex]) {
                  //                 assignToStudent
                  //                     .add(widget.files[currentIndex]);
                  //               } else {
                  //                 assignToStudent
                  //                     .remove(widget.files[currentIndex]);
                  //               }
                  //             });
                  //           }),
                  //       const Spacer(),
                  //       IconButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               widget.files.removeAt(currentIndex);
                  //               selected.removeAt(currentIndex);
                  //               len -= 1;
                  //             });
                  //           },
                  //           icon: const Icon(Icons.delete_forever_rounded)),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 15),
                  Container(
                      constraints: const BoxConstraints(
                          minHeight: 350,
                          maxHeight: 400,
                          minWidth: 500,
                          maxWidth: 550),
                      // width: 550,
                      // height: 400,
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
                                  });
                                  player.play(); // await audioPlay();
                                } else {
                                  setState(() {
                                    item.accepting = false;
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
                                              width:
                                                  item.isSuccessful ? 2 : 1)),
                                      height: height,
                                      width: width,
                                      child: Image.memory(item.bytes,
                                          fit: BoxFit.contain,
                                          filterQuality: FilterQuality.high,
                                          colorBlendMode: BlendMode.modulate,
                                          color: item.isSuccessful
                                              ? Colors.white.withOpacity(1.0)
                                              : item.accepting
                                                  ? Colors.white
                                                      .withOpacity(0.1)
                                                  : Colors.white
                                                      .withOpacity(0.6))),
                            );
                          }).toList(),
                        ),
                      )),
                  Container(
                      constraints: const BoxConstraints(maxHeight: 550),
                      width: 300,
                      //height: 600,
                      color: draggableObjects.isNotEmpty
                          ? Colors.grey[300]
                          : Colors.transparent,
                      child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Center(
                              child: Wrap(
                            spacing: 10,
                            direction: Axis.vertical,
                            children: draggableObjects.map((item) {
                              return Draggable<ItemModel>(
                                data: item,
                                childWhenDragging: Container(
                                    alignment: Alignment.center,
                                    height: height,
                                    width: width,
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
                          ))))
                  // const SizedBox(height: 20),
                  // SizedBox(
                  //   width: 400,
                  //   child: Row(
                  //     //mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       ElevatedButton.icon(
                  //         onPressed: () {
                  //           //stop();

                  //           setState(() {
                  //             //_isPlaying = false;

                  //             try {
                  //               currentIndex = (currentIndex - 1) % len;
                  //               loadPuzzlePiece();
                  //             } catch (e) {
                  //               //print(e);
                  //             }
                  //           });
                  //         },
                  //         label: const Text(
                  //           'Prev',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 17,
                  //           ),
                  //         ),
                  //         icon: const Icon(
                  //           Icons.navigate_before,
                  //         ),
                  //         style: ElevatedButton.styleFrom(
                  //           alignment: Alignment.center,
                  //           minimumSize: const Size(100, 42),
                  //         ),
                  //       ),
                  //       const Spacer(),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           //stop();
                  //           setState(() {
                  //             try {
                  //               currentIndex = (currentIndex + 1) % len;
                  //               loadPuzzlePiece();
                  //             } catch (e) {
                  //               //print(e);
                  //             }
                  //           });
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //           alignment: Alignment.center,
                  //           minimumSize: const Size(100, 42),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: const <Widget>[
                  //             Text('Next',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 17,
                  //                 )),
                  //             SizedBox(
                  //               width: 5,
                  //             ),
                  //             Icon(Icons.navigate_next_rounded),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            // Container(
            //     constraints: const BoxConstraints(maxHeight: 550),
            //     width: 300,
            //     //height: 600,
            //     color: draggableObjects.isNotEmpty
            //         ? Colors.grey[300]
            //         : Colors.transparent,
            //     child: SingleChildScrollView(
            //         padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            //         child: Center(
            //             child: Wrap(
            //           spacing: 10,
            //           direction: Axis.vertical,
            //           children: draggableObjects.map((item) {
            //             return Draggable<ItemModel>(
            //               data: item,
            //               childWhenDragging: Container(
            //                   alignment: Alignment.center,
            //                   height: height,
            //                   width: width,
            //                   child: Image.memory(item.bytes,
            //                       fit: BoxFit.contain,
            //                       filterQuality: FilterQuality.high,
            //                       colorBlendMode: BlendMode.modulate,
            //                       color: Colors.white.withOpacity(0.4))),
            //               feedback: SizedBox(
            //                   //child that I drop....
            //                   height: height,
            //                   width: width,
            //                   child: Image.memory(
            //                     item.bytes,
            //                     fit: BoxFit.contain,
            //                     filterQuality: FilterQuality.high,
            //                   )),
            //               child: SizedBox(
            //                   height: height,
            //                   width: width,
            //                   //alignment: Alignment.center,
            //                   child: Image.memory(
            //                     item.bytes,
            //                     fit: BoxFit.contain,
            //                     filterQuality: FilterQuality.high,
            //                   )),
            //             );
            //           }).toList(),
            //         ))))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     if (assignToStudent.isNotEmpty) {
      //       assignContentToStudent();
      //     } else {
      //       showMaterialDialog();
      //     }
      //   },
      //   icon: const Icon(Icons.add),
      //   label: const Text('Assign to student',
      //       style: TextStyle(
      //         fontSize: 14,
      //       )),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Future assignContentToStudent() async {
  //   String? selectedDirectory = await FilePicker.platform
  //       .getDirectoryPath(dialogTitle: 'Choose student\'s folder');

  //   if (selectedDirectory == null) {
  //     // User canceled the picker
  //   } else {
  //     selectedDirectory.replaceAll('\\', '/');

  //     copyImage(selectedDirectory);
  //   }
  //   // }
  // }

  // Future<void> copyImage(String destination) async {
  //   final newDir =
  //       await Directory(destination + '/Quiz/Jigsaw').create(recursive: true);
  //   for (File file in assignToStudent) {
  //     file.copy('${newDir.path}/${file.path.split("\\").last}');
  //   }
  // }

  // void showMaterialDialog() {
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
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Close')),
  //           ],
  //         );
  //       });
  // }
}
