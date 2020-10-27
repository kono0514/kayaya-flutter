import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/cubit/anime_relations_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/anime_horiz_tile.dart';

// TODO: Create view dedicated for empty related/recommended

class RelatedTabViewItem extends StatefulWidget {
  final String id;
  final Key tabKey;

  const RelatedTabViewItem({Key key, this.tabKey, this.id}) : super(key: key);

  @override
  _RelatedTabViewItemState createState() => _RelatedTabViewItemState();
}

class _RelatedTabViewItemState extends State<RelatedTabViewItem> {
  AnimeRelationsCubit animeRelationsCubit;

  @override
  void initState() {
    super.initState();
    animeRelationsCubit =
        AnimeRelationsCubit(context.repository<AniimRepository>())
          ..loadRelations(widget.id);
  }

  @override
  void dispose() {
    animeRelationsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollViewInnerScrollPositionKeyWidget(
      widget.tabKey,
      BlocBuilder<AnimeRelationsCubit, AnimeRelationsState>(
        cubit: animeRelationsCubit,
        builder: (context, state) {
          if (state is AnimeRelationsError) {
            return Center(
              child: Text(state.exception.toString()),
            );
          }

          if (state is AnimeRelationsLoaded) {
            if (state.relations.data.length == 0 &&
                state.recommendations.data.length == 0) {
              return buildEmptyWidget();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  if (state.relations.data.length > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            S.of(context).related,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 163,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AnimeHorizTile(
                                anime: state.relations.data[index],
                                height: 163,
                                onPressed: () {
                                  final anime = state.relations.data[index];

                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    RouteConstants.movieOrSeriesDetail,
                                    arguments: MediaArguments(anime),
                                  );
                                },
                              ),
                            ),
                            itemCount: state.relations.data.length,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  if (state.recommendations.data.length > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            S.of(context).recommended,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 163,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AnimeHorizTile(
                                anime: state.recommendations.data[index],
                                height: 163,
                                onPressed: () {
                                  final anime =
                                      state.recommendations.data[index];

                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(
                                    RouteConstants.movieOrSeriesDetail,
                                    arguments: MediaArguments(anime),
                                  );
                                },
                              ),
                            ),
                            itemCount: state.recommendations.data.length,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildEmptyWidget() {
    return Center(
      child: Text('No relations found'),
    );
  }
}
