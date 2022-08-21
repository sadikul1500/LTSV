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
    print(values[3]);
    setAudioPath(values[3].split('/').last);

    setImagePaths(values[2].split('/').last).then((data) {
      imagePath = data;
    });
    print('noun_list..assignvalues..');
    print(imagePath.length);
  }

  Future setImagePaths(String folderName) async {
    String folderPath = '${globals.folderPath}/Lesson/Noun/$folderName';
    //Future listDir(String folderPath) async {
    var directory = Directory(folderPath);
    //print(directory);

    var exists = await directory.exists();
    if (exists) {
      print('exists');
      await for (var original in directory.list(recursive: false)) {
        if (original is File) {
          print(10000);
          print(original.path);
          imagePath.add(original.path);
          // await original
          //     .copy('${newDir.path}/${original.path.split('\\').last}');
        }
      }
      // directory
      //     .list(recursive: true, followLinks: false)
      //     .listen((FileSystemEntity entity) {
      //   String path = entity.path.replaceAll('\\', '/');
      //   imagePath.add(path);
      //});
    }

    return imagePath;
    //}
  }

  void setAudioPath(String file) {
    audio = '${globals.folderPath}/Lesson/Noun/$file';
  }

  List<String> getImagePath() {
    return imagePath;
  }
}
