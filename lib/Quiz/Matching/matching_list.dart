//read from folder /files and store here
//array of title, meaning, video
//start.....
// import 'dart:io';

import 'package:student/globals.dart' as globals;

class MatchingList {
  String category = '';
  String image = '';
  String question = '';
  List<String> options = [];
  String answer = '';
  String line;

  MatchingList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    List<String> values = line.split("; ");
    category = values[0];
    image =
        '${globals.folderPath}\\Quiz\\Matching\\${values[1].split('/').last}';
    question = values[2];
    for (int i = 3; i < 3 + 4; i++) {
      options.add(values[i]);
    }
    answer = values[7];
    // video =
    //     '${globals.folderPath}\\Lesson\\Activity\\${values[2].split('/').last}';
  }
}
