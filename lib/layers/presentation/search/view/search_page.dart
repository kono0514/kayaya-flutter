import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/usecases/search/save_search_history_usecase.dart';
import '../bloc/search_bloc.dart';
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
      final result = await showSearch<String>(
        context: context.findRootAncestorStateOfType<NavigatorState>().context,
        delegate: Search<String>(searchBloc) as SearchDelegate<String>,
      );

      if (result == null) {
        // Close "SearchPage" on back button press from "showSearch"
        Navigator.of(context).pop();
      } else {
        searchBloc.saveSearchHistoryUsecase(
            SaveSearchHistoryUsecaseParams(text: result));
      }
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
