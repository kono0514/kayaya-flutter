import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/anime_details/anime_details_cubit.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/anime_related_tile.dart';

class RelatedTabViewItem extends StatefulWidget {
  final Key tabKey;

  const RelatedTabViewItem({Key key, this.tabKey}) : super(key: key);

  @override
  _RelatedTabViewItemState createState() => _RelatedTabViewItemState();
}

class _RelatedTabViewItemState extends State<RelatedTabViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollViewInnerScrollPositionKeyWidget(
      widget.tabKey,
      BlocBuilder<AnimeDetailsCubit, AnimeDetailsState>(
        builder: (context, state) {
          if (state is AnimeDetailsError) {
            return Center(
              child: Text(state.exception.toString()),
            );
          }

          if (state is AnimeDetailsLoaded) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverPadding(padding: const EdgeInsets.only(top: 30)),
                if (state.details.relations.length > 0)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Related:',
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
                              child: AnimeRelatedTile(
                                anime: state.details.relations[index],
                                height: 163,
                                onPressed: () {
                                  final anime = state.details.relations[index];

                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(
                                      anime.animeType == AnimeType.movie
                                          ? RouteConstants.movieDetail
                                          : RouteConstants.seriesDetail,
                                      arguments: anime);
                                },
                              ),
                            ),
                            itemCount: state.details.relations.length,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                if (state.details.recommendations.length > 0)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Recommendation:',
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
                              child: AnimeRelatedTile(
                                anime: state.details.recommendations[index],
                                height: 163,
                                onPressed: () {
                                  final anime =
                                      state.details.recommendations[index];

                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(
                                      anime.animeType == AnimeType.movie
                                          ? RouteConstants.movieDetail
                                          : RouteConstants.seriesDetail,
                                      arguments: anime);
                                },
                              ),
                            ),
                            itemCount: state.details.recommendations.length,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
