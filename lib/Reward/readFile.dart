import 'dart:io';

import 'package:student/Reward/reward_list.dart';

class RewardFileReader {
  String filePath;
  List<RewardList> rewardList = [];

  RewardFileReader(this.filePath) {
    readFile();
  }

  readFile() {
    List<String> lines = File(filePath).readAsLinesSync();
    for (var line in lines) {
      RewardList reward = RewardList(line);
      rewardList.add(reward);
    }
  }
}
