//read from folder /files and store here
//array of imageFile_name, level
//start.....
// import 'dart:io';

import 'package:student/globals.dart' as globals;

class JigsawList {
  String image = '';
  String level = '';
  String line;
  String topic = '';

  JigsawList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    List<String> values = line.split("; ");
    // category = values[0];
    image = '${globals.folderPath}\\Quiz\\jigsaw\\${values[0].split('/').last}';
    // print('jigsaw list.... $image');
    // question = values[2];
    // for (int i = 3; i < 3 + 4; i++) {
    //   options.add(values[i]);
    // }
    level = values[1]; //2 or 3
    topic = values[2];
    // video =
    //     '${globals.folderPath}\\Lesson\\Activity\\${values[2].split('/').last}';
  }
}
