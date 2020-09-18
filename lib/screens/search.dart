import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/algolia_client_provider.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/bloc/search_bloc.dart';
import 'package:kayaya_flutter/hex_color.dart';
import 'package:kayaya_flutter/logger.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/shared_preferences_service.dart';
import 'package:kayaya_flutter/widgets/launchers.dart';
// import 'package:kayaya_flutter/widgets/custom_search.dart';

typedef GetSearchSuggestions = Future<List<String>> Function();

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Algolia algoliaClient = AlgoliaClientProvider.instance.algolia;
  SearchBloc searchBloc;

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
        SharedPreferencesService.instance.addSearchHistory(result);
      }
    });
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }

  Future<List<String>> getSearchHistory() async {
    return SharedPreferencesService.instance.searchHistory;
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
                itemBuilder: (context, index) {
                  final item = state.hits[index];
                  String itemName = currentLanguage == 'mn'
                      ? item.data['name_mn']
                      : item.data['name_en'];
                  return InkWell(
                    onTap: () {
                      // Close "showSearch" and "SearchPage",
                      // then push new destination page on top.
                      // So that when the destination page closes, user
                      // returns to the page below "SearchPage"
                      close(context, query);
                      Navigator.of(context).pop();

                      Navigator.of(context, rootNavigator: true).pushNamed(
                        RouteConstants.movieOrSeriesDetail,
                        arguments: MediaArguments(
                          BrowseAnimes$Query$Animes$Data.fromJson(
                            {
                              'id': item.objectID.split('::').last,
                              'coverImage': {
                                'large': item.data['cover_image_large'],
                              },
                              'name': itemName,
                              'animeType': item.data['anime_type']
                                  .toString()
                                  .toUpperCase(),
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
                            imageUrl: item.data['cover_image_large'],
                            placeholder: (context, url) => Container(
                              color: HexColor(
                                  item.data['cover_color'] ?? '#000000'),
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
                                    if (item.data['start_year'] != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          '(${item.data['start_year']})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(fontSize: 13),
                                        ),
                                      ),
                                    Text(
                                      item.data['anime_type'] == 'series'
                                          ? 'Цуврал'
                                          : 'Кино',
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
                itemCount: state.hits.length,
              ),
            ],
          );
        }

        return LinearProgressIndicator();
      },
    );
  }
}
