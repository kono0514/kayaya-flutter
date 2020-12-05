import 'package:flutter/material.dart';

class SearchSuggestionItem extends StatelessWidget {
  final String query;
  final Function(String) onTap;

  const SearchSuggestionItem({
    Key key,
    @required this.query,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap(query);
      },
      title: Row(
        children: [
          Icon(Icons.history),
          SizedBox(width: 24),
          Text(query),
        ],
      ),
    );
  }
}
