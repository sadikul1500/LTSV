import 'dart:io';
import 'dart:convert';
// import 'package:student/Lesson/Association/association_list.dart';
import 'package:student/Quiz/Drag&Drop/drag_question.dart';

class DragQuestionFileReader {
  String filePath;
  List<DragQuestion> dragQuestions = [];

  DragQuestionFileReader(this.filePath) {
    readFile();
  }

  void readFile() {
    File file = File(filePath);
    String contents = file.readAsStringSync();
    final jsonResponse = jsonDecode(contents);
    print(jsonResponse);

    for (var p in jsonResponse) {
      print(11);
      // print(x);
      print(123);

      // DragQuestion p = DragQuestion.fromJson(x);
      print(p.runtimeType);
      // DragQuestion question = DragQuestion(
      //     p['files'], p['values'], p['valuesRight'], p['question']);
      dragQuestions.add(DragQuestion.fromJson(p));
    }
    print('reader ${dragQuestions.length}');
  }

  // readFile() {
  //   List<String> lines = File(filePath).readAsLinesSync();
  //   for (var line in lines) {
  //     AssociationList association = AssociationList(line);
  //     associationList.add(association);
  //   }
  // }
}
