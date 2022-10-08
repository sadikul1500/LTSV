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
    final jsonResponse = jsonDecode(jsonEncode(contents));
    print(jsonResponse);

    for (var x in jsonResponse) {
      var p = DragQuestion.fromJson(x);
      DragQuestion question =
          DragQuestion(p.files, p.values, p.valuesRight, p.question);
      dragQuestions.add(question);
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
