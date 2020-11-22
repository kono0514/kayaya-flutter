import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/search/search.dart';
import 'package:kayaya_flutter/shared/services/shared_preferences_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBloc searchBloc;
  final sps = GetIt.I<SharedPreferencesService>();

  @override
  void initState() {
    super.initState();
    searchBloc = SearchBloc();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final result = await showSearch(
        context: context.findRootAncestorStateOfType<NavigatorState>().context,
        delegate: Search(searchBloc, getSuggestions: getSearchHistory),
      );

      // Close "SearchPage" on back button press from "showSearch"
      if (result == null) {
        Navigator.of(context).pop();
      } else {
        sps.addSearchHistory(result);
      }
    });
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }

  Future<List<String>> getSearchHistory() async {
    return sps.searchHistory;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
