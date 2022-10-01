//read from folder /files and store here
//array of title, image, video, category
//start.....
import 'dart:io';

import 'package:student/globals.dart' as globals;

class RewardList {
  String title = '';
  // String meaning = '';
  String video = '';
  String imagePath = '';
  String category = '';
  // String audio = '';
  String line;

  // Set<String> imagePath = {};
  List<String> values = [];

  RewardList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    values = line.split("; ");
    title = values[0];
    category = values[3];
    

    if (values[1] == '') {
      
      video =
          '${globals.folderPath}\\Lesson\\Association\\${values[2].split('/').last}';
    } else {
      imagePath =
          '${globals.folderPath}\\Lesson\\Association\\${values[1].split('/').last}';
    }
  }

  
}
