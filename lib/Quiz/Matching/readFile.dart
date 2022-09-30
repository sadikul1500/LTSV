import 'dart:io';

import 'package:student/Quiz/Matching/matching_list.dart';

class MatchingFileReader {
  String filePath;
  List<MatchingList> matchingList = [];

  MatchingFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      MatchingList matching = MatchingList(line);
      matchingList.add(matching);
    }
  }
}
