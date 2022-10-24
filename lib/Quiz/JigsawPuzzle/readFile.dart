import 'dart:io';

import 'package:student/Quiz/JigsawPuzzle/jigsaw_list.dart';


class JigsawFileReader {
  String filePath;
  List<JigsawList> jigsawList = [];

  JigsawFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      JigsawList jigsaw = JigsawList(line);
      jigsawList.add(jigsaw);
    }
  }
}
