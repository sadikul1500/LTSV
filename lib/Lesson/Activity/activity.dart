// //https://pastebin.com/ZSgj4LU3
// //working version.... edit here....
// //screenshot package didn't work....
// //trying with RenderRepaintBoundary... it shws wrong... couldn't even write and run code....
// //snapShot...............
// //list items in a LIST.........
// //import 'dart:ffi';
// import 'dart:io';
// import 'dart:math';

// import 'package:dart_vlc/dart_vlc.dart';
// import 'package:flutter/material.dart';

// import 'package:student/Lesson/Activity/activity_list.dart';
// import 'package:student/Lesson/Activity/activity_search.dart';
// import 'package:student/Lesson/Activity/readFile.dart';

// import 'package:student/globals.dart' as globals;

// class Activity extends StatefulWidget {
//   @override
//   State<Activity> createState() => _ActivityState();
// }

// class _ActivityState extends State<Activity> {
//   ActivityFileReader fileReader =
//       ActivityFileReader('${globals.folderPath}/Lesson/Activity/activity.txt');
//   // await DartVLC.initialize(useFlutterNativeView: true);
//   // ActivityList activityList = ActivityList();
//   // late List<ActivityItem> activities;
//   List<ActivityList> activities = [];

//   int _index = 0;
//   // Player videoPlayer;
//   late int len;

//   int activateIndex = 0;

//   List<Media> medias = <Media>[];
//   CurrentState current = CurrentState();
//   PositionState position = PositionState();
//   PlaybackState playback = PlaybackState();
//   GeneralState general = GeneralState();
//   VideoDimensions videoDimensions = const VideoDimensions(0, 0);
//   double bufferingProgress = 0.0;

//   //_ActivityState() {
//   // _index = 0;

//   Player videoPlayer = Player(
//     id: 0,
//     //videoDimensions: VideoDimensions(640, 360),
//     registerTexture: false,
//   );
//   //}

//   @override
//   initState() {
//     super.initState();
//     // print("init state called");
//     if (mounted) {
//       videoPlayer.currentStream.listen((current) {
//         setState(() => this.current = current);
//       });
//       videoPlayer.positionStream.listen((position) {
//         setState(() => this.position = position);
//       });
//       videoPlayer.playbackStream.listen((playback) {
//         setState(() => this.playback = playback);
//       });
//       videoPlayer.generalStream.listen((general) {
//         setState(() => this.general = general);
//       });
//       videoPlayer.videoDimensionsStream.listen((videoDimensions) {
//         setState(() => this.videoDimensions = videoDimensions);
//       });
//       videoPlayer.bufferingProgressStream.listen(
//         (bufferingProgress) {
//           setState(() => this.bufferingProgress = bufferingProgress);
//         },
//       );
//       videoPlayer.errorStream.listen((event) {
//         // print('libvlc error.');
//         throw Error();
//       });
//       // devices = Devices.all;
//       Equalizer equalizer = Equalizer.createMode(EqualizerMode.live);
//       equalizer.setPreAmp(10.0);
//       equalizer.setBandAmp(31.25, 10.0);
//       videoPlayer.setEqualizer(equalizer);
//     }
//     proxyInitState();
//   }

//   proxyInitState() {
//     //await DartVLC.initialize(useFlutterNativeView: true);
//     activities = fileReader.activityList;
//     len = activities.length;
//     // listenStreams();
//     createPlaylist(_index);
//   }

//   @override
//   void dispose() {
//     videoPlayer.dispose();
//     super.dispose();
//   }

//   void createPlaylist(int index) {
//     // for (ActivityList activity in activities) {
//     //   medias.add(Media.file(File(activity.video)));
//     // }
//     medias = [Media.file(File('D:/puppy.mp4'))]; //activities[index].video
//     // print(medias.length);
//     videoPlayer.open(Playlist(medias: medias), autoStart: false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text(
//           'Activity',
//           style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 stop();
//                 setState(() {});
//                 var result = await showSearch<String>(
//                   context: context,
//                   delegate: CustomDelegate(activities),
//                 );
//                 setState(() {
//                   _index = max(
//                       0,
//                       activities
//                           .indexWhere((element) => element.title == result));
//                 });
//               },
//               icon: const SafeArea(child: Icon(Icons.search_sharp)))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             activities.isEmpty
//                 ? const SizedBox(
//                     height: 400,
//                     child: Center(
//                       child: Text(
//                         'No Data Found!!!',
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 24),
//                       ),
//                     ),
//                   )
//                 : Card(
//                     shape: RoundedRectangleBorder(
//                       side: const BorderSide(color: Colors.white70, width: .1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: <Widget>[
//                                   const SizedBox(height: 15),
//                                   SizedBox(
//                                     height: 420,
//                                     width: 620,
//                                     child: NativeVideo(
//                                       //native video
//                                       player: videoPlayer,
//                                       width: 620, //640,
//                                       height: 420, //360,
//                                       volumeThumbColor: Colors.blue,
//                                       volumeActiveColor: Colors.blue,
//                                       showControls: true, //!isPhone
//                                       //fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 15),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 500,
//                                 height: 250,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: const <Widget>[
//                                         // Checkbox(
//                                         //     value: activities
//                                         //         .elementAt(_index)
//                                         //         .isSelected,
//                                         //     onChanged: (value) {
//                                         //       activities
//                                         //               .elementAt(_index)
//                                         //               .isSelected =
//                                         //           !activities
//                                         //               .elementAt(_index)
//                                         //               .isSelected;
//                                         //       if (activities
//                                         //           .elementAt(_index)
//                                         //           .isSelected) {
//                                         //         assignToStudent
//                                         //             .add(activities[_index]);
//                                         //       } else {
//                                         //         assignToStudent.remove(
//                                         //             activities[_index]);
//                                         //       }
//                                         //       setState(() {
//                                         //         //videoPlayer.playOrPause();
//                                         //       });
//                                         //     }),
//                                         // IconButton(
//                                         //     onPressed: () {
//                                         //       setState(() {
//                                         //         activityList.removeItem(
//                                         //             activities
//                                         //                 .elementAt(_index));
//                                         //       });
//                                         //     },
//                                         //     tooltip: 'Remove this item',
//                                         //     icon: const Icon(Icons
//                                         //         .delete_forever_rounded)),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: <Widget>[
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: <Widget>[
//                                             Card(
//                                               color: Colors.white70,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(20.0),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: const <Widget>[
//                                                     Text(
//                                                       'Title: ',
//                                                       style: TextStyle(
//                                                         fontSize: 24,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       'Meaning:',
//                                                       style: TextStyle(
//                                                         fontSize: 24,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: <Widget>[
//                                             Card(
//                                               //margin: const EdgeInsets.all(122.0),
//                                               color: Colors.blue[400],
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(18.0),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: <Widget>[
//                                                     Text(
//                                                       activities
//                                                           .elementAt(_index)
//                                                           .title,
//                                                       style: const TextStyle(
//                                                         fontSize: 24,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 5),
//                                                     Text(
//                                                       activities
//                                                           .elementAt(_index)
//                                                           .meaning,
//                                                       style: const TextStyle(
//                                                         fontSize: 24,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     // Row(
//                                     //   mainAxisAlignment:
//                                     //       MainAxisAlignment.center,
//                                     //   children: <Widget>[
//                                     //     ElevatedButton(
//                                     //       style: ButtonStyle(
//                                     //           fixedSize:
//                                     //               MaterialStateProperty.all(
//                                     //                   const Size(150, 40)),
//                                     //           padding:
//                                     //               MaterialStateProperty.all(
//                                     //                   const EdgeInsets
//                                     //                           .fromLTRB(
//                                     //                       0, 10, 0, 10))),
//                                     //       onPressed: () {
//                                     //         makeAquiz(); //show captured widget
//                                     //       },
//                                     //       child: const Text(
//                                     //         'Make a quiz',
//                                     //         style: TextStyle(
//                                     //             fontSize: 20,
//                                     //             fontWeight: FontWeight.bold),
//                                     //       ),
//                                     //       // style: ElevatedButton.styleFrom(
//                                     //       //   alignment: Alignment.center,
//                                     //       //   minimumSize: const Size(100, 42),
//                                     //       // ),
//                                     //     )
//                                     //   ],
//                                     // )
//                                   ],
//                                 ),
//                               )
//                               //rightSidePanel(activities.elementAt(_index))
//                             ])),
//                   ),
//             const SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     stop();

//                     setState(() {
//                       // videoPlayer.previous();
//                       try {
//                         _index = (_index - 1) % len;
//                         createPlaylist(_index);
//                         //files.clear();
//                       } catch (e) {
//                         //print(e);
//                       }
//                     });
//                   },
//                   label: const Text(
//                     'Prev',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17,
//                     ),
//                   ),
//                   icon: const Icon(
//                     Icons.navigate_before,
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     alignment: Alignment.center,
//                     minimumSize: const Size(100, 42),
//                   ),
//                 ),
//                 const SizedBox(width: 30),
//                 // ElevatedButton.icon(
//                 //   icon: const Icon(Icons.screenshot_monitor),
//                 //   label: const Text(
//                 //     'Take a screenshot',
//                 //     style: TextStyle(
//                 //       fontWeight: FontWeight.bold,
//                 //       fontSize: 17,
//                 //     ),
//                 //   ),
//                 //   onPressed: () async {
//                 //     if (playback.isPlaying) {
//                 //       videoPlayer.pause();
//                 //     }
//                 //     await takeScreenShot(); //just take a screenshot
//                 //     // .then((_) {
//                 //     //   //print(files);
//                 //     //   Navigator.push(
//                 //     //       context,
//                 //     //       MaterialPageRoute(
//                 //     //           builder: (context) =>
//                 //     //               ShowCapturedWidget(files: files)));
//                 //     // });
//                 //   },
//                 //   style: ElevatedButton.styleFrom(
//                 //     alignment: Alignment.center,
//                 //     minimumSize: const Size(100, 42),
//                 //   ),
//                 // ),
//                 const SizedBox(width: 30),
//                 ElevatedButton(
//                   onPressed: () {
//                     stop();
//                     setState(() {
//                       // videoPlayer.next();
//                       try {
//                         _index = (_index + 1) % len;
//                         createPlaylist(_index);
//                         //files.clear();
//                       } catch (e) {
//                         //print(e);
//                       }
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     alignment: Alignment.center,
//                     minimumSize: const Size(100, 42),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: const <Widget>[
//                       Text('Next',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17,
//                           )),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Icon(Icons.navigate_next_rounded),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//       // floatingActionButton: Row(
//       //   children: [
//       //     const SizedBox(width: 25.0),
//       //     FloatingActionButton.extended(
//       //       heroTag: 'btn1',
//       //       onPressed: () {
//       //         stop();
//       //         teachStudent();
//       //       },
//       //       icon: const Icon(Icons.add),
//       //       label: const Text('Assign to student',
//       //           style: TextStyle(
//       //             fontSize: 18,
//       //           )),
//       //     ),
//       //     const Spacer(),
//       //     FloatingActionButton.extended(
//       //       heroTag: 'btn2',
//       //       onPressed: () {
//       //         stop();

//       //         Navigator.of(context)
//       //             .pushNamed('/activityForm')
//       //             .then((value) => setState(() {
//       //                   proxyInitState();
//       //                 }));
//       //       },
//       //       icon: const Icon(Icons.add),
//       //       label: const Text('Add an Activity',
//       //           style: TextStyle(
//       //             fontSize: 18,
//       //           )),
//       //     ),
//       //   ],
//       // ),
//     );
//   }

//   Future stop() async {
//     videoPlayer.stop();
//   }

//   // _dismissDialog() {
//   //   Navigator.pop(context);
//   // }

//   // void _showMaterialDialog(String title, String content) {
//   //   showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return AlertDialog(
//   //           title: Text(title),
//   //           content: Text(content),
//   //           actions: <Widget>[
//   //             TextButton(
//   //                 onPressed: () {
//   //                   _dismissDialog();
//   //                 },
//   //                 child: const Text('Close')),
//   //           ],
//   //         );
//   //       });
//   // }
// }
