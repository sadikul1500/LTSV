import 'package:flutter/material.dart';
import 'package:student/Lesson/Activity/activity_list.dart';

class CustomDelegate extends SearchDelegate<String> {
  
  List<String> data = [];
  List<ActivityList> activities = [];
 
  CustomDelegate(this.activities) {    
    for (ActivityList activity in activities) {
      data.add(activity.title);
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
        var activity = listToShow[i];
        return ListTile(
          title: Text(activity),
          onTap: () => close(context, activity),
        );
      },
    );
  }
}
