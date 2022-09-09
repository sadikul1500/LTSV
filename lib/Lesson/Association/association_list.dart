//read from folder /files and store here
//array of title, meaning, image_path, audio, video
//start.....
import 'dart:io';

import 'package:student/globals.dart' as globals;

class AssociationList {
  String title = '';
  String meaning = '';
  String video = '';
  // String imagePath = '';
  String audio = '';
  String line;

  Set<String> imagePath = {};
  List<String> values = [];

  AssociationList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    values = line.split("; ");
    title = values[0];
    meaning = values[1];
    // imagePath = values[2];
    audio = values[3];
    video = values[4];

    if (values[3] == '') {
      //audioPath = values[3]
      audio =
          '${globals.folderPath}\\Lesson\\Association\\${values[3].split('/').last}';
    } else {
      video =
          '${globals.folderPath}\\Lesson\\Activity\\${values[3].split('/').last}';
    }
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
