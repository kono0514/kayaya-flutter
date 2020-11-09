import 'dart:async';

import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/bloc/anime_episodes_bloc.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/widgets/icon_popup_menu.dart';
import 'package:kayaya_flutter/utils/launchers.dart';
import 'package:kayaya_flutter/widgets/list_bottom_loader.dart';
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
  AnimeEpisodesBloc animeEpisodesBloc;
  Completer<void> _refreshCompleter;

  // Disable infinite scroll while more data is loading
  bool disableInfiniteScroll = false;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    animeEpisodesBloc = AnimeEpisodesBloc(context.read<AniimRepository>())
      ..add(AnimeEpisodesFetched(widget.id, sortOrder: SortOrder.asc));
  }

  @override
  void dispose() {
    animeEpisodesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollViewInnerScrollPositionKeyWidget(
      widget.tabKey,
      BlocConsumer<AnimeEpisodesBloc, AnimeEpisodesState>(
        cubit: animeEpisodesBloc,
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
            return buildErrorWidget(state);
          }

          if (state is AnimeEpisodesEmpty) {
            return buildEmptyWidget();
          }

          if (state is AnimeEpisodesLoaded) {
            return buildListWidget(state);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildListWidget(AnimeEpisodesLoaded state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth != 0) return false;
        if (notification.metrics.maxScrollExtent == 0) return false;
        if (disableInfiniteScroll) return false;

        //reach the pixels to loading more
        if (notification.metrics.axisDirection == AxisDirection.down &&
            notification.metrics.pixels >
                notification.metrics.maxScrollExtent - 200) {
          disableInfiniteScroll = true;
          animeEpisodesBloc.add(AnimeEpisodesFetched(widget.id));
        }
        return false;
      },
      child: RefreshIndicator(
        displacement: 80.0,
        onRefresh: () {
          animeEpisodesBloc.add(AnimeEpisodesRefreshed(widget.id));
          return _refreshCompleter.future;
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(left: 16.0, top: 12.0),
              sliver: SliverToBoxAdapter(
                child: UnconstrainedBox(
                  alignment: Alignment.centerLeft,
                  child: IconPopupMenu(
                    items: [
                      PopupMenuItem(
                        child: Text(S.of(context).sort_asc),
                        value: SortOrder.asc,
                      ),
                      PopupMenuItem(
                        child: Text(S.of(context).sort_desc),
                        value: SortOrder.desc,
                      ),
                    ],
                    title: S.of(context).sort,
                    icon: Icon(Icons.sort),
                    initialValue: state.sortOrder,
                    onSelected: (value) {
                      animeEpisodesBloc.add(AnimeEpisodesRefreshed(
                        widget.id,
                        sortOrder: value,
                      ));
                    },
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return index >= state.episodes.length
                      ? ListBottomLoader(error: state.error != null)
                      : buildEpisodeListItem(context, state.episodes[index]);
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

  Widget buildErrorWidget(AnimeEpisodesError state) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
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
                onPressed: () =>
                    animeEpisodesBloc.add(AnimeEpisodesRefreshed(widget.id)),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildEmptyWidget() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(S.of(context).no_episodes),
              TextButton(
                onPressed: () =>
                    animeEpisodesBloc.add(AnimeEpisodesRefreshed(widget.id)),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
