//read from folder /files and store here
//array of title, meaning, video
//start.....
// import 'dart:io';

import 'package:student/globals.dart' as globals;

class ActivityList {
  String title = '';
  String meaning = '';
  String video = '';
  String line;

  ActivityList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    List<String> values = line.split("; ");
    title = values[0];
    meaning = values[1];

    video =
        '${globals.folderPath}\\Lesson\\Activity\\${values[3].split('/').last}';
  }
}
