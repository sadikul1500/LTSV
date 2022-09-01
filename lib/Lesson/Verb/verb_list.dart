//read from folder /files and store here
//array of title, meaning, imageList, audio
//start.....
import 'dart:io';

import 'package:student/globals.dart' as globals;

class VerbList {
  String title = '';
  String meaning = '';
  Set<String> imagePath = {};
  String audio = '';
  String line;
  List<String> values = [];

  VerbList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    values = line.split("; ");
    title = values[0];
    meaning = values[1];

    audio = '${globals.folderPath}\\Lesson\\Verb\\${values[3].split('/').last}';
  }

  setImagePaths(String folderName) async {
    String folderPath = '${globals.folderPath}/Lesson/Verb/$folderName';

    var directory = Directory(folderPath);

    var exists = await directory.exists();
    if (exists) {
      await for (var original
          in directory.list(recursive: false, followLinks: false)) {
        if (original is File) {
          imagePath.add(original.path);
        }
      }
    }
  }

  Future<Set<String>> getImagePath() async {
    if (imagePath.isEmpty) {
      await setImagePaths(values[2].split('/').last);
    }
    return imagePath;
  }
}
