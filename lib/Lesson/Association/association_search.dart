import 'package:flutter/material.dart';
import 'package:student/Lesson/Association/association_list.dart';

class CustomDelegate extends SearchDelegate<String> {
  
  List<String> data = [];
  List<AssociationList> associations = [];
 
  CustomDelegate(this.associations) {    
    for (AssociationList association in associations) {
      data.add(association.title);
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
        var association = listToShow[i];
        return ListTile(
          title: Text(association),
          onTap: () => close(context, association),
        );
      },
    );
  }
}
