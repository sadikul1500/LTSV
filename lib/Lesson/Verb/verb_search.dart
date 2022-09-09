import 'package:flutter/material.dart';
import 'package:student/Lesson/Verb/verb_list.dart';

//import 'package:kids_learning_tool/Lessons/Nouns/noun.dart';
//thanks Ryan
class CustomDelegate extends SearchDelegate<String> {
  List<String> data = [];
  List<VerbList> verbs = [];

  CustomDelegate(this.verbs) {
    for (VerbList verb in verbs) {
      data.add(verb.title);
    }
  }

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
        var verb = listToShow[i];

        return ListTile(
          title: Text(verb),
          onTap: () => close(context, verb),
        );
      },
    );
  }
}
