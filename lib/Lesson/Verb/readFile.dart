import 'dart:io';

import 'package:student/Lesson/Verb/verb_list.dart';

class VerbFileReader {
  String filePath;
  List<VerbList> verbList = [];

  VerbFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      VerbList verb = VerbList(line);
      verbList.add(verb);
    }
  }
}
