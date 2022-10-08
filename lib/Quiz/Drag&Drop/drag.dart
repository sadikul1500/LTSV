import 'dart:io';
import 'dart:math';
import 'dart:async';

// import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:student/Quiz/Drag&Drop/drag_question.dart';
import 'package:student/Quiz/Drag&Drop/readFile.dart';
import 'package:student/globals.dart' as globals;

//for preview option
class ItemModel {
  String value;
  bool accepting;

  ItemModel(this.value, {this.accepting = false});
}

class Drag extends StatefulWidget {
  @override
  State<Drag> createState() => _DragState();
}

class _DragState extends State<Drag> {
  DragQuestionFileReader fileReader =
      DragQuestionFileReader('${globals.folderPath}/Quiz/DragDrop/drag.json');

  List<DragQuestion> dragQuestions = [];

  int _index = 0;
  int wrong_tries = 0;
  int score = 0;

  late Timer _timer;
  int _start = 0;

  bool gameOver = false;
  List<ItemModel> items1 = [];
  List<ItemModel> items2 = [];
  String question = '';

  @override
  void initState() {
    super.initState();
    initDrag();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initDrag() {
    score = 0;
    gameOver = false;
    prepareQuestion();
    // items1.shuffle();
    // items2.shuffle();
  }

  void prepareQuestion() {
    for (int i = 0; i < dragQuestions[_index].values.length; i++) {
      ItemModel item = ItemModel(
          '${dragQuestions[_index].files[i]} space ${dragQuestions[_index].values[i]}');
      items1.add(item);
    }
    for (int i = 0; i < dragQuestions[_index].valuesRight.length; i++) {
      ItemModel item = ItemModel(dragQuestions[_index].valuesRight[i]);
      items2.add(item);
    }
    question = dragQuestions[_index].question;
  }
}
