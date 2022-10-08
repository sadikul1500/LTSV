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

  Future<void> readFile() async {
    File file = File(filePath);
    String contents = await file.readAsString();
    var jsonResponse = jsonDecode(contents);

    for (var p in jsonResponse) {
      DragQuestion question = DragQuestion(
          p['files'], p['values'], p['valuesRight'], p['question']);
      dragQuestions.add(question);
    }
  }

  // readFile() {
  //   List<String> lines = File(filePath).readAsLinesSync();
  //   for (var line in lines) {
  //     AssociationList association = AssociationList(line);
  //     associationList.add(association);
  //   }
  // }
}
