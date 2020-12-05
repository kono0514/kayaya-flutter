import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../router.dart';
import '../../../domain/entities/anime.dart';
import '../bloc/search_bloc.dart';
import '../widget/search_result_list_item.dart';
import '../widget/search_suggestion_item.dart';

typedef GetSearchSuggestions = Future<List<String>> Function();

class Search extends SearchDelegate {
  final SearchBloc searchBloc;

  Search(this.searchBloc);

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
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchBloc.add(QueryChanged(query));
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      cubit: searchBloc,
      builder: (context, state) {
        if (state is SearchError) {
          return Center(child: Text('Something went wrong...'));
        }

        if (state is SearchHistoryLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) => SearchSuggestionItem(
              query: state.result[index],
              onTap: (value) {
                query = value;
              },
            ),
            itemCount: state.result.length,
          );
        }

        if (state is SearchLoaded) {
          return Stack(
            children: <Widget>[
              state.isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
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

                    var anime = Anime(
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

        return LinearProgressIndicator();
      },
    );
  }
}
