import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/router.dart';

import '../search.dart';

typedef GetSearchSuggestions = Future<List<String>> Function();

class Search extends SearchDelegate {
  final SearchBloc searchBloc;
  final GetSearchSuggestions getSuggestions;

  Search(this.searchBloc, {this.getSuggestions});

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

    // Show search history when search text is empty
    if (query.trim() == '') {
      return _buildSuggestions();
    }

    return _buildResults(context);
  }

  Widget _buildSuggestions() {
    return FutureBuilder<List<String>>(
      future: getSuggestions(),
      builder: (context, snapshot) {
        List<String> items = snapshot.hasData ? snapshot.data : [];

        return ListView.builder(
          itemBuilder: (context, index) => SearchSuggestionItem(
            query: items[index],
            onTap: (value) {
              query = value;
            },
          ),
          itemCount: items.length,
        );
      },
    );
  }

  Widget _buildResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      cubit: searchBloc,
      builder: (context, state) {
        if (state is SearchError) {
          return Center(child: Text('Something went wrong...'));
        }

        if (state is SearchLoaded) {
          return Stack(
            children: <Widget>[
              state.isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
              ListView.builder(
                itemCount: state.result.hits.length,
                itemBuilder: (context, index) => SearchResultListItem(
                  item: state.result.hits[index],
                  onTap: (item) {
                    // Close "showSearch" and "SearchPage",
                    // then push new destination page on top.
                    // So that when the destination page closes, user
                    // returns to the page below "SearchPage"
                    close(context, query);
                    Navigator.of(context).pop();

                    Navigator.of(context, rootNavigator: true).pushNamed(
                      Routes.movieOrSeries,
                      arguments: MediaArguments(
                        AnimeItemModelGenerator$Query$Anime.fromJson(
                          {
                            'id': item.id,
                            'coverImage': {'large': item.coverImageLarge},
                            'name': item.nameEn,
                            'animeType':
                                item.animeType.toString().toUpperCase(),
                          },
                        ),
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
