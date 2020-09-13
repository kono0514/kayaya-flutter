import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/bloc/anime_list_bloc.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/browse/anime_list_tile.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_sliver_app_bar.dart';
import 'package:kayaya_flutter/widgets/browse/sliver_filter_button.dart';
import 'package:kayaya_flutter/widgets/launchers.dart';

class BrowsePage extends StatefulWidget {
  final ScrollController scrollController;

  const BrowsePage({Key key, this.scrollController}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    print('Brwose build!');
    print(widget.scrollController);

    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        controller: widget.scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomSliverAppBar(
              title: Text(S.current.tabs_browse),
              actions: [
                SliverFilterButton(),
              ],
            ),
          ];
        },
        body: BlocProvider(
          create: (context) => AnimeListBloc(
              context.repository<AniimRepository>(),
              context.bloc<BrowseFilterCubit>())
            ..add(AnimeListFetched()),
          child: Builder(
            builder: (context) {
              final innerScrollController = PrimaryScrollController.of(context);
              bool disableInfiniteScroll = false;
              innerScrollController.addListener(() {
                final direction =
                    innerScrollController.position.userScrollDirection;
                final maxScroll =
                    innerScrollController.position.maxScrollExtent;
                final currentScroll = innerScrollController.position.pixels;

                if (disableInfiniteScroll) return;

                if ((direction == ScrollDirection.reverse &&
                        maxScroll - currentScroll <= 200) ||
                    (direction == ScrollDirection.idle &&
                        maxScroll - currentScroll == 0)) {
                  print(
                      'Trigger AnimeListFetched event disableInfiniteScroll: $disableInfiniteScroll');
                  disableInfiniteScroll = true;
                  context.bloc<AnimeListBloc>().add(AnimeListFetched());
                }
              });

              return BlocConsumer<AnimeListBloc, AnimeListState>(
                listener: (context, state) {
                  print('Listener state is ${state.runtimeType}');
                  // Re-enable scroll fetching after receiving state change
                  disableInfiniteScroll = false;
                  if (state is AnimeListLoadedState) {
                    _refreshCompleter?.complete();
                    _refreshCompleter = Completer();
                  } else if (state is AnimeListInitialState) {
                    widget.scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                    );
                  }
                },
                builder: (context, state) {
                  print('State is ${state.runtimeType}');

                  if (state is AnimeListErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            state.exception.toString(),
                            style: TextStyle(
                              color: Colors.red[400],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () => context
                                .bloc<AnimeListBloc>()
                                .add(AnimeListRefreshed()),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AnimeListEmptyState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'No items found. Adjust filter and try again.',
                          ),
                          RaisedButton(
                            onPressed: () => context
                                .bloc<AnimeListBloc>()
                                .add(AnimeListRefreshed()),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AnimeListLoadedState) {
                    return RefreshIndicator(
                      onRefresh: () {
                        context.bloc<AnimeListBloc>().add(AnimeListRefreshed());
                        return _refreshCompleter.future;
                      },
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return index >= state.animes.length
                                    ? BottomLoader(animeLoadedState: state)
                                    : AnimeListTile(
                                        anime: state.animes[index],
                                        onPressed: () {
                                          final anime = state.animes[index];
                            launchMediaPage(context, MediaArguments(anime));
                                        },
                                      );
                              },
                              childCount: state.paginatorInfo.hasMorePages
                                  ? state.animes.length + 1
                                  : state.animes.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  final AnimeListLoadedState animeLoadedState;

  const BottomLoader({
    Key key,
    this.animeLoadedState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          bottom: 40.0,
        ),
        child: animeLoadedState.error == null ? _buildLoader() : _buildError(),
      ),
    );
  }

  Widget _buildLoader() {
    return CircularProgressIndicator();
  }

  Widget _buildError() {
    return Text(
      'Error',
      style: TextStyle(color: Colors.red),
    );
  }
}
