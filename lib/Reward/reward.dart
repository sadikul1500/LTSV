//https://pastebin.com/ZSgj4LU3

import 'package:student/Reward/readFile.dart';
import 'package:student/Reward/reward_list.dart';
import 'package:student/globals.dart' as globals;

class Reward {
  RewardFileReader fileReader =
      RewardFileReader('${globals.folderPath}/Reward/reward.txt');
  List<RewardList> rewards = [];

  Reward() {
    rewards = fileReader.rewardList;
    // print('reward class ${rewards.length}');
  }
}
