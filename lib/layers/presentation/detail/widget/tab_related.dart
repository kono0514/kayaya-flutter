import 'dart:math';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';

import '../../../../locale/generated/l10n.dart';
import '../../../../router.dart';
import '../cubit/relations_cubit.dart';
import 'anime_horiz_tile.dart';

// TODO: Create view dedicated for empty related/recommended

class RelatedTabViewItem extends StatelessWidget {
  final String id;
  final Key tabKey;

  const RelatedTabViewItem({Key key, this.tabKey, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollViewInnerScrollPositionKeyWidget(
      tabKey,
      BlocProvider(
        create: (context) => GetIt.I<RelationsCubit>()..loadRelations(id),
        child: BlocBuilder<RelationsCubit, RelationsState>(
          builder: (context, state) {
            if (state is RelationsError) {
              return buildErrorWidget(state);
            }

            if (state is RelationsLoaded) {
              if (state.relations.isEmpty && state.recommendations.isEmpty) {
                return buildEmptyWidget();
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    if (state.relations.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              TR.of(context).related,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 163,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              itemBuilder: (context, index) {
                                final child = Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: AnimeHorizTile(
                                    anime: state.relations[index].anime,
                                    height: 163,
                                    onPressed: () {
                                      final anime =
                                          state.relations[index].anime;

                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(
                                        Routes.movieOrSeries,
                                        arguments: MediaArguments(anime),
                                      );
                                    },
                                  ),
                                );

                                // Animate the first 10 item,
                                // but stagger only the first 5 item
                                if (index < 10) {
                                  final slideDurationMs =
                                      250 + (15 * min(4, index).toInt());
                                  final fadeDurationMs =
                                      300 + (15 * min(4, index).toInt());
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: SlideAnimation(
                                      horizontalOffset: 200.0,
                                      duration: Duration(
                                          milliseconds: slideDurationMs),
                                      child: FadeInAnimation(
                                        duration: Duration(
                                            milliseconds: fadeDurationMs),
                                        child: child,
                                      ),
                                    ),
                                  );
                                }

                                return child;
                              },
                              itemCount: state.relations.length,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    if (state.recommendations.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              TR.of(context).recommended,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 163,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              itemBuilder: (context, index) {
                                final child = Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: AnimeHorizTile(
                                    anime: state.recommendations[index].anime,
                                    height: 163,
                                    onPressed: () {
                                      final anime =
                                          state.recommendations[index].anime;

                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(
                                        Routes.movieOrSeries,
                                        arguments: MediaArguments(anime),
                                      );
                                    },
                                  ),
                                );

                                // Animate the first 10 item,
                                // but stagger only the first 5 item
                                if (index < 10) {
                                  final slideDurationMs =
                                      250 + (15 * min(4, index).toInt());
                                  final fadeDurationMs =
                                      300 + (15 * min(4, index).toInt());
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: SlideAnimation(
                                      horizontalOffset: 200.0,
                                      duration: Duration(
                                          milliseconds: slideDurationMs),
                                      child: FadeInAnimation(
                                        duration: Duration(
                                            milliseconds: fadeDurationMs),
                                        child: child,
                                      ),
                                    ),
                                  );
                                }

                                return child;
                              },
                              itemCount: state.recommendations.length,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget buildEmptyWidget() {
    return const CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text('No relations found'),
          ),
        ),
      ],
    );
  }

  Widget buildErrorWidget(RelationsError state) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              state.error,
              style: TextStyle(
                color: Colors.red.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
