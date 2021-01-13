import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../router.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/usecases/search/save_search_history_usecase.dart';
import '../bloc/search_bloc.dart';
import '../widget/search_result_list_item.dart';
import '../widget/search_suggestion_item.dart';
import 'search.dart';

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
        Navigator.of(context).pop();
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
            itemCount: state.result.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const _SearchHeading(text: 'RECENT');
              }

              return SearchSuggestionItem(
                query: state.result[index - 1],
                onTap: (value) {
                  searchTextImmediately(value);
                  FocusScope.of(context).unfocus();
                },
              );
            },
          );
        }

        if (state is SearchLoaded) {
          return Stack(
            children: <Widget>[
              state.isLoading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
              ListView.builder(
                itemCount: state.result.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    if (state.result.isEmpty) {
                      return const _SearchHeading(text: 'NO RESULTS FOUND');
                    }
                    return const _SearchHeading(text: 'RESULT');
                  }

                  return SearchResultListItem(
                    item: state.result[index - 1],
                    onTap: (item) async {
                      searchBloc.saveSearchHistoryUsecase(
                          SaveSearchHistoryUsecaseParams(text: query));

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
                  );
                },
              ),
            ],
          );
        }

        return const LinearProgressIndicator();
      },
    );
  }
}

class _SearchHeading extends StatelessWidget {
  final String text;

  const _SearchHeading({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 18.0,
        bottom: 6.0,
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
