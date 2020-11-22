import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/bloc/search_bloc.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/utils/hex_color.dart';
import 'package:kayaya_flutter/router.dart';
import 'package:kayaya_flutter/services/shared_preferences_service.dart';

typedef GetSearchSuggestions = Future<List<String>> Function();

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

    if (query.trim() == '') {
      return FutureBuilder(
        future: getSuggestions(),
        builder: (context, snapshot) {
          List<String> items = [];
          if (snapshot.hasData) {
            items.addAll(snapshot.data);
          }

          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = items[index];
              },
              title: Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 24),
                  Text(items[index]),
                ],
              ),
            ),
            itemCount: items.length,
          );
        },
      );
    }

    String currentLanguage = Localizations.localeOf(context).languageCode;

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
                itemBuilder: (context, index) {
                  final item = state.result.hits[index];
                  String itemName =
                      currentLanguage == 'mn' ? item.nameMn : item.nameEn;
                  return InkWell(
                    onTap: () {
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
                              'name': itemName,
                              'animeType':
                                  item.animeType.toString().toUpperCase(),
                            },
                          ),
                          isMinimal: true,
                        ),
                      );
                    },
                    child: Container(
                      height: 112,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            width: 64,
                            height: 96,
                            imageUrl: item.coverImageLarge,
                            placeholder: (context, url) => Container(
                              color: HexColor(item.coverColor ?? '#000000'),
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  itemName,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    if (item.startYear != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          '(${item.startYear})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(fontSize: 13),
                                        ),
                                      ),
                                    Text(
                                      item.animeType == 'series'
                                          ? S.of(context).series
                                          : S.of(context).movie,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }

        return LinearProgressIndicator();
      },
    );
  }
}
