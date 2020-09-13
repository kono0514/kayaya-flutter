import 'dart:async';

import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/bloc/anime_episodes_bloc.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/widgets/launchers.dart';
import 'package:kayaya_flutter/widgets/player/source_chooser_dialog.dart';

class EpisodesTabViewItem extends StatefulWidget {
  final String id;
  final Key tabKey;

  const EpisodesTabViewItem({Key key, this.tabKey, @required this.id})
      : super(key: key);

  @override
  _EpisodesTabViewItemState createState() => _EpisodesTabViewItemState();
}

class _EpisodesTabViewItemState extends State<EpisodesTabViewItem> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    // Disable infinite scroll while more data is loading
    bool disableInfiniteScroll = false;

    return NestedScrollViewInnerScrollPositionKeyWidget(
      widget.tabKey,
      BlocProvider(
        create: (context) =>
            AnimeEpisodesBloc(context.repository<AniimRepository>())
              ..add(AnimeEpisodesFetched(widget.id, sortOrder: SortOrder.asc)),
        child: BlocConsumer<AnimeEpisodesBloc, AnimeEpisodesState>(
          listener: (context, state) {
            if (state is AnimeEpisodesLoaded) {
              if (state.paginatorInfo.hasMorePages) {
                disableInfiniteScroll = false;
              }
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            if (state is AnimeEpisodesError) {
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
                          .bloc<AnimeEpisodesBloc>()
                          .add(AnimeEpisodesRefreshed(widget.id)),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is AnimeEpisodesEmpty) {
              return Center(child: Text('No episodes yet...'));
            }

            if (state is AnimeEpisodesLoaded) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.depth != 0) return false;
                  if (disableInfiniteScroll) return false;

                  //reach the pixels to loading more
                  if (notification.metrics.axisDirection ==
                          AxisDirection.down &&
                      notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent) {
                    disableInfiniteScroll = true;
                    context
                        .bloc<AnimeEpisodesBloc>()
                        .add(AnimeEpisodesFetched(widget.id));
                  }
                  return false;
                },
                child: RefreshIndicator(
                  displacement: 80.0,
                  onRefresh: () {
                    context
                        .bloc<AnimeEpisodesBloc>()
                        .add(AnimeEpisodesRefreshed(widget.id));
                    return _refreshCompleter.future;
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(left: 16.0, top: 12.0),
                        sliver: SliverToBoxAdapter(
                          child: UnconstrainedBox(
                            alignment: Alignment.centerLeft,
                            child: buildSortPopupMenuButton(
                                context, state.sortOrder),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return index >= state.episodes.length
                                ? BottomLoader(episodesLoadedState: state)
                                : buildEpisodeListItem(
                                    context, state.episodes[index]);
                          },
                          childCount: state.paginatorInfo.hasMorePages
                              ? state.episodes.length + 1
                              : state.episodes.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  PopupMenuButton<SortOrder> buildSortPopupMenuButton(
      BuildContext context, SortOrder initialValue) {
    return PopupMenuButton(
      offset: Offset(32.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
        child: Row(
          children: [
            Icon(
              Icons.sort,
              color: Colors.grey,
            ),
            SizedBox(width: 8.0),
            Text('Sort by'),
            SizedBox(width: 8.0),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.grey.shade700,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Asc'),
          value: SortOrder.asc,
        ),
        PopupMenuItem(
          child: Text('Desc'),
          value: SortOrder.desc,
        ),
      ],
      initialValue: initialValue,
      onSelected: (value) {
        context.bloc<AnimeEpisodesBloc>().add(AnimeEpisodesRefreshed(
              widget.id,
              sortOrder: value,
            ));
      },
    );
  }

  Widget buildEpisodeListItem(
      BuildContext context, GetAnimeEpisodes$Query$Episodes$Data episode) {
    return InkWell(
      onTap: () async {
        final chosenRelease =
            await showDialog<GetAnimeEpisodes$Query$Episodes$Data$Releases>(
          context: context,
          builder: (context) => SourceChooserDialog(
            releases: episode.releases,
          ),
        );

        if (chosenRelease != null) {
          launchPlayRelease(context, chosenRelease);
        }
      },
      child: ListTile(
        title: Text('Episode ${episode.number}'),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  final AnimeEpisodesLoaded episodesLoadedState;

  const BottomLoader({
    Key key,
    this.episodesLoadedState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          bottom: 40.0,
        ),
        child:
            episodesLoadedState.error == null ? _buildLoader() : _buildError(),
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
