import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../router.dart';
import '../../../domain/entities/anime.dart';
import '../bloc/search_bloc.dart';
import '../widget/search_result_list_item.dart';
import '../widget/search_suggestion_item.dart';

typedef GetSearchSuggestions = Future<List<String>> Function();

class Search extends SearchDelegate<String> {
  final SearchBloc searchBloc;
  bool _doNextSearchImmediately = false;

  Search(this.searchBloc);

  void searchTextImmediately(String text) {
    _doNextSearchImmediately = true;
    query = text;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final _appBarTheme = Theme.of(context).appBarTheme;
    return Theme.of(context).copyWith(
      primaryColor: _appBarTheme.color,
      primaryIconTheme: _appBarTheme.iconTheme,
      primaryColorBrightness: _appBarTheme.brightness,
      primaryTextTheme: _appBarTheme.textTheme,
    );
  }

  @override
  void showResults(BuildContext context) {
    //
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          searchTextImmediately('');
          FocusScope.of(context).requestFocus();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_doNextSearchImmediately) {
      _doNextSearchImmediately = false;
      searchBloc.add(QueryChanged(query));
    } else {
      searchBloc.add(QueryChangedTyping(query));
    }
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      cubit: searchBloc,
      builder: (context, state) {
        if (state is SearchError) {
          return const Center(child: Text('Something went wrong...'));
        }

        if (state is SearchHistoryLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) => SearchSuggestionItem(
              query: state.result[index],
              onTap: (value) {
                searchTextImmediately(value);
                FocusScope.of(context).unfocus();
              },
            ),
            itemCount: state.result.length,
          );
        }

        if (state is SearchLoaded) {
          return Stack(
            children: <Widget>[
              state.isLoading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
              ListView.builder(
                itemCount: state.result.length,
                itemBuilder: (context, index) => SearchResultListItem(
                  item: state.result[index],
                  onTap: (item) {
                    // Close "showSearch" and "SearchPage",
                    // then push new destination page on top.
                    // So that when the destination page closes, user
                    // returns to the page below "SearchPage"
                    close(context, query);
                    Navigator.of(context).pop();

                    final anime = Anime(
                      id: item.id,
                      coverImage: item.image,
                      name: item.name,
                      type: item.type.toLowerCase() == 'movie'
                          ? AnimeType.movie
                          : AnimeType.series,
                    );
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      Routes.movieOrSeries,
                      arguments: MediaArguments(
                        anime,
                        isMinimal: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const LinearProgressIndicator();
      },
    );
  }
}
