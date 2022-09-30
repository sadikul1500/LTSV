// import 'dart:js';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_view/flutter_native_view.dart';
import 'package:student/Lesson/Activity/activity.dart';
import 'package:student/Lesson/Association/association.dart';
import 'package:student/Lesson/Noun/noun.dart';
import 'package:student/Lesson/Verb/verb.dart';
import 'package:student/Quiz/Matching/matching.dart';
import 'package:student/Quiz/quizOptionpage.dart';
import 'package:student/home.dart';
import 'package:student/secondHome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterNativeView.ensureInitialized();
  await DartVLC.initialize(
      useFlutterNativeView: true); //useFlutterNativeView: true

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home': (context) => const Home(),
      '/homeOption': (context) => const HomeOption(),
      '/noun': (context) => Noun(),
      '/activity': (context) => Activity(),
      '/association': (context) => Association(),
      '/verb': (context) => Verb(),
      '/quiz': (context) => Quiz(),
      '/matching': (context) => Matching()
    },
  ));
}
