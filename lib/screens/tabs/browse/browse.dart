import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/bloc/anime_list_bloc.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/locale/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/router.dart';
import 'package:kayaya_flutter/screens/tabs/browse/browse_anime_list_tile.dart';
import 'package:kayaya_flutter/shared/widgets/app_bar/custom_sliver_app_bar.dart';
import 'package:kayaya_flutter/screens/tabs/browse/sliver_filter_button.dart';
import 'package:kayaya_flutter/shared/widgets/list_bottom_loader.dart';

class BrowsePage extends StatefulWidget {
  final ScrollController scrollController;

  const BrowsePage({Key key, this.scrollController}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  AnimeListBloc animeListBloc;
  BrowseFilterCubit browseFilterCubit;
  Completer<void> refreshCompleter;

  // Disable infinite scroll while more data is loading
  bool disableInfiniteScroll = false;

  @override
  void initState() {
    super.initState();
    refreshCompleter = Completer<void>();
    browseFilterCubit = BrowseFilterCubit();
    animeListBloc = AnimeListBloc(
      context.read<AniimRepository>(),
      browseFilterCubit,
    )..add(AnimeListFetched());
  }

  @override
  void dispose() {
    animeListBloc.close();
    browseFilterCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: browseFilterCubit),
        BlocProvider.value(value: animeListBloc),
      ],
      child: Scaffold(
        extendBody: true,
        body: NestedScrollView(
          controller: widget.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CustomSliverAppBar(
                title: Text(TR.of(context).tabs_browse),
                actions: [
                  SliverFilterButton(),
                ],
              ),
            ];
          },
          body: BlocConsumer<AnimeListBloc, AnimeListState>(
            cubit: animeListBloc,
            listener: (context, state) {
              // Re-enable scroll fetching after receiving state change
              disableInfiniteScroll = false;
              if (state is AnimeListLoadedState) {
                refreshCompleter?.complete();
                refreshCompleter = Completer();
              } else if (state is AnimeListInitialState) {
                widget.scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                );
              }
            },
            builder: (context, state) {
              if (state is AnimeListErrorState) {
                return buildErrorWidget(state);
              }

              if (state is AnimeListEmptyState) {
                return buildEmptyWidget();
              }

              if (state is AnimeListLoadedState) {
                return buildListWidget(state);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildListWidget(AnimeListLoadedState state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth != 0) return false;
        if (notification.metrics.maxScrollExtent == 0) return false;
        if (disableInfiniteScroll) return false;

        //reach the pixels to load more
        if (notification.metrics.axisDirection == AxisDirection.down &&
            notification.metrics.pixels >
                notification.metrics.maxScrollExtent - 200) {
          disableInfiniteScroll = true;
          animeListBloc.add(AnimeListFetched());
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () {
          animeListBloc.add(AnimeListRefreshed());
          return refreshCompleter.future;
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return index >= state.animes.length
                      ? ListBottomLoader(error: state.error != null)
                      : BrowseAnimeListTile(
                          anime: state.animes[index],
                          onPressed: () {
                            final anime = state.animes[index];
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              Routes.movieOrSeries,
                              arguments: MediaArguments(anime),
                            );
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
      ),
    );
  }

  Widget buildErrorWidget(AnimeListErrorState state) {
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
          TextButton(
            onPressed: () => animeListBloc.add(AnimeListRefreshed()),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No items found. Adjust filter and try again.',
          ),
          TextButton(
            onPressed: () => animeListBloc.add(AnimeListRefreshed()),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
