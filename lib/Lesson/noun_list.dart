//read from folder /files and store here
//array of title, meaning, imageList, audio
//start.....
import 'dart:io';

import 'package:student/globals.dart' as globals;

class NounList {
  String title = '';
  String meaning = '';
  List<String> imagePath = [];
  String audio = '';
  String line;

  NounList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() {
    List<String> values = line.split("; ");
    title = values[0];
    meaning = values[1];

    getAudioPath(values[3].split('/').last);

    getImagePaths(values[2].split('/').last).then((data) {
      imagePath = data;
    });
  }

  Future getImagePaths(String folderName) async {
    String folderPath = '${globals.folderPath}/Lesson/Noun/$folderName';
    //Future listDir(String folderPath) async {
    var directory = Directory(folderPath);
    //print(directory);

    var exists = await directory.exists();
    if (exists) {
      directory
          .list(recursive: true, followLinks: false)
          .listen((FileSystemEntity entity) {
        String path = entity.path.replaceAll('\\', '/');
        imagePath.add(path);
      });
    }

    return imagePath;
    //}
  }

  void getAudioPath(String file) {
    audio = '${globals.folderPath}/Lesson/Noun/$file';
  }
}
