//read from folder /files and store here
//array of title, meaning, imageList, audio
//start.....
import 'dart:io';

import 'package:student/globals.dart' as globals;

class NounList {
  String title = '';
  String meaning = '';
  Set<String> imagePath = {};
  String audio = '';
  String line;
  List<String> values = [];
  // bool NoImages = false;

  NounList(this.line) {
    assignValues();
  }
  //split by "; "
  void assignValues() async {
    values = line.split("; ");
    title = values[0];
    meaning = values[1];
    //print(values[3]);
    //setAudioPath(values[3].split('/').last);
    audio = '${globals.folderPath}\\Lesson\\Noun\\${values[3].split('/').last}';
    // await setImagePaths(values[2].split('/').last);
    // .then((data) {
    //   imagePath = data;
    // });
    print('noun_list..assignvalues..');
    print(imagePath.length);
  }

  // Future setImagePaths(String folderName) async {
  //   String folderPath = '${globals.folderPath}/Lesson/Noun/$folderName';
  //   //Future listDir(String folderPath) async {
  //   var directory = Directory(folderPath);
  //   //print(directory);

  //   var exists = await directory.exists();
  //   if (exists) {
  //     //print('exists');
  //     // var imageList = directory.list(recursive: false, followLinks: false);
  //     // // if (await directory.list(recursive: false, followLinks: false).isEmpty) {}
  //     // await for (var original in imageList) {
  //     //   if (original is File) {
  //     //     //print(10000);
  //     //     print(original.path);
  //     //     imagePath.add(original.path);
  //     //     // await original
  //     //     //     .copy('${newDir.path}/${original.path.split('\\').last}');
  //     //   }
  //     // }
  //     directory
  //         .list(recursive: true, followLinks: false)
  //         .listen((FileSystemEntity entity) {
  //       String path = entity.path.replaceAll('\\', '/');
  //       imagePath.add(path);
  //     });
  //   }
  //   // await Future.delayed(const Duration(milliseconds: 500));
  //   return imagePath;
  //   //}
  // }

  setImagePaths(String folderName) async {
    String folderPath = '${globals.folderPath}/Lesson/Noun/$folderName';
    //Future listDir(String folderPath) async {
    var directory = Directory(folderPath);
    //print(directory);
    // imagePath.clear();
    var exists = await directory.exists();
    if (exists) {
      //print('exists');
      // var imageList = directory.list(recursive: false, followLinks: false);
      // // if (await directory.list(recursive: false, followLinks: false).isEmpty) {}
      await for (var original
          in directory.list(recursive: false, followLinks: false)) {
        if (original is File) {
          //print(10000);
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
      // });
    }
    // await Future.delayed(const Duration(milliseconds: 500));
    //return imagePath;
    //}
  }

  // void setAudioPath(String file) {
  //   audio = '${globals.folderPath}/Lesson/Noun/$file';
  // }

  Future<Set<String>> getImagePath() async {
    if (imagePath.isEmpty) {
      await setImagePaths(values[2].split('/').last);
    }

    print('get Method');
    print(imagePath.length);
    return imagePath;
  }
}
