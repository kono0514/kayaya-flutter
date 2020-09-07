import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final ScrollController scrollController;

  const SearchPage({Key key, this.scrollController}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('This is search page'),
          ],
        ),
      ),
    );
  }
}