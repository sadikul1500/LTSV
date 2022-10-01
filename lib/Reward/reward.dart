//https://pastebin.com/ZSgj4LU3

import 'package:student/Reward/readFile.dart';
import 'package:student/Reward/reward_list.dart';
import 'package:student/globals.dart' as globals;

class Reward {
  RewardFileReader fileReader = RewardFileReader(
      '${globals.folderPath}/Lesson/Association/association.txt');
  List<RewardList> rewards = [];

  Reward() {
    rewards = fileReader.rewardList;
  }
}
