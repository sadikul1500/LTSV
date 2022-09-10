import 'dart:io';

import 'package:student/Lesson/Association/association_list.dart';

class AssociationFileReader {
  String filePath;
  List<AssociationList> associationList = [];

  AssociationFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      AssociationList association = AssociationList(line);
      associationList.add(association);
    }
  }
}
