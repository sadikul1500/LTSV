// import 'dart:js';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_view/flutter_native_view.dart';
import 'package:student/Lesson/Activity/activity.dart';
import 'package:student/Lesson/Activity/video.dart';
import 'package:student/Lesson/Association/association.dart';
import 'package:student/Lesson/Noun/noun.dart';
import 'package:student/Lesson/Verb/verb.dart';
import 'package:student/Quiz/ActivityScheduling/activity_scheduling.dart';
import 'package:student/Quiz/Drag&Drop/drag.dart';
import 'package:student/Quiz/JigsawPuzzle/jigsaw.dart';
import 'package:student/Quiz/Matching/matching.dart';
import 'package:student/Quiz/quizOptionpage.dart';
// import 'package:student/Reward/reward.dart';
// import 'package:student/Reward/reward_list.dart';
import 'package:student/home.dart';
import 'package:student/secondHome.dart';

// final List<RewardList> rewardds = Reward().rewards;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterNativeView.ensureInitialized();
  await DartVLC.initialize(
      useFlutterNativeView: true); //useFlutterNativeView: true
  // Reward reward = Reward();
  // List<RewardList> rewards = reward.rewards;

  runApp(MaterialApp(
    theme: ThemeData(
        // scaffoldBackgroundColor: const Color.fromARGB(255, 226, 135, 67),
        brightness: Brightness.light), // ThemeData(
    //     brightness: Brightness.dark,
    //     // backgroundColor: Colors.orange,
    //     // scaffoldBackgroundColor: Colors.black12,

    //     buttonTheme: const ButtonThemeData(
    //         buttonColor: Colors.amber, disabledColor: Colors.black),
    //     primaryColor: Colors.amber,
    //     colorScheme:
    //         ColorScheme.fromSwatch().copyWith(secondary: Colors.amber)),
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => const Home(),
      '/homeOption': (context) => const HomeOption(),
      '/noun': (context) => Noun(),
      '/activity': (context) => DartVLCExample(), //Activity(), //Activity(),
      '/association': (context) => Association(),
      '/verb': (context) => Verb(),
      '/quiz': (context) => Quiz(),
      '/matching': (context) => Matching(),
      '/drag': (context) => Drag(),
      '/activityScheduling': (context) => ActivityScheduling(),
      '/jigsaw': (context) => Jigsaw()
    },
  ));
}
