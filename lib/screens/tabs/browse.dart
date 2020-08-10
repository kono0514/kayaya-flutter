import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/gql/types.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_sliver_app_bar.dart';

class BrowsePage extends StatelessWidget {
  final ScrollController scrollController;

  const BrowsePage({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Brwose build!');

    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    IconThemeData actionsIconTheme = appBarTheme.actionsIconTheme ??
        appBarTheme.iconTheme ??
        theme.primaryIconTheme;

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomSliverAppBar(
              title: Text(
                "Анийм",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                OutlineButton.icon(
                  icon: Icon(Icons.tune),
                  label: Text('FILTER'),
                  onPressed: () => {},
                  highlightedBorderColor: Colors.transparent,
                ),
              ],
            ),
          ];
        },
        body: Query(
          options: QueryOptions(
            documentNode: Queries.browseAnimes,
            fetchPolicy: FetchPolicy.cacheAndNetwork,
          ),
          builder: (result, {fetchMore, refetch}) {
            print(result);
            print(result.loading);
            print(result.source);
            print(result.hasException);
            print(result.optimistic);

            if (result.hasException) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverFillRemaining(
                    child: Center(
                        child: Text(
                      result.exception.toString(),
                      style: TextStyle(
                        color: Colors.red[400],
                      ),
                    )),
                  ),
                ],
              );
            }

            if (result.loading) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }

            List animes = result.data['animes']['data'];

            return RefreshIndicator(
              displacement: 20.0,
              onRefresh: refetch,
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final anime = animes[index];

                        return ListTile(
                          title: Text(anime['name']['mn']),
                          subtitle: Text(anime['name']['mn']),
                          isThreeLine: true,
                          onTap: () => {},
                        );
                      },
                      childCount: animes.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
