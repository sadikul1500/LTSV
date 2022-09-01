import 'dart:io';

import 'package:student/Lesson/Activity/activity_list.dart';

class ActivityFileReader {
  String filePath;
  List<ActivityList> activityList = [];

  ActivityFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      ActivityList activity = ActivityList(line);
      activityList.add(activity);
    }
  }
}
