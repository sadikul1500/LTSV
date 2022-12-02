//read from folder /files and store here
//only image name... 1 name per line
//start.....
// import 'dart:io';

import 'package:student/globals.dart' as globals;

class ActivityList {
  // String category = '';
  String image = '';
  String topic = '';
  // String question = '';
  // List<String> options = [];
  // String answer = '';
  String line;

  ActivityList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    List<String> values = line.split('; ');
    image = '${globals.folderPath}/Quiz/Activity_Scheduling/${values[0]}';
    topic = values[1];
  }
}
