import 'dart:io';

import 'package:student/Quiz/Matching/matching_list.dart';

class MatchingFileReader {
  String filePath;
  List<MatchingList> activityList = [];

  MatchingFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      MatchingList activity = MatchingList(line);
      activityList.add(activity);
    }
  }
}
