import 'package:flutter/material.dart' hide showSearch;
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';

import '../bloc/search_bloc.dart';
import 'search.dart';
import 'search_delegate.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();

    searchBloc = GetIt.I<SearchBloc>();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await showSearch<String>(
        context: context.findRootAncestorStateOfType<NavigatorState>().context,
        delegate: Search(searchBloc),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
