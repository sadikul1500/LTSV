import 'dart:io';

import 'package:student/Lesson/Noun/noun_list.dart';

class NounFileReader {
  String filePath;
  List<NounList> nounList = [];

  NounFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      NounList noun = NounList(line);
      nounList.add(noun);
      // print('read file');
      // print(line);
    }
  }
}
