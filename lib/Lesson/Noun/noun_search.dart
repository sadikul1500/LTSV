import 'package:flutter/material.dart';
import 'package:student/Lesson/Noun/noun_list.dart';

//import 'package:kids_learning_tool/Lessons/Nouns/noun.dart';
//thanks Ryan
class CustomDelegate extends SearchDelegate<String> {
  //NameList nameList = NameList();
  List<String> data = [];
  List<NounList> names = [];
  //Noun nouns = Noun();

  CustomDelegate(this.names) {
    //loading();
    // loadData().then((data) {
    //names = data;
    // });
    //names = nouns.names
    // print(names.length);
    for (NounList name in names) {
      data.add(name.title);
    }
    // print(data);
    //print('reached');
  }

  // Future loadData() async {
  //   names = nameList.getList();
  //   await Future.delayed(const Duration(milliseconds: 500));

  //   if (names.isEmpty) {
  //     return [];
  //   }
  //   // print(1223);
  //   // print(names);
  // }

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    // print('building.......');
    List<String> listToShow;
    if (query.isNotEmpty) {
      listToShow = data
          .where((e) =>
              e.toLowerCase().contains(query.toLowerCase()) &&
              e.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    } else {
      listToShow = data;
    }

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var noun = listToShow[i];
        // print('calling listview builder...');
        return ListTile(
          title: Text(noun),
          onTap: () => close(context, noun),
        );
      },
    );
  }
}
