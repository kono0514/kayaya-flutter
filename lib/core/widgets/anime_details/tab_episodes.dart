import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/bloc/anime_episodes_bloc.dart';
import 'package:kayaya_flutter/locale/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/core/widgets/icon_popup_menu.dart';
import 'package:kayaya_flutter/utils/launchers.dart';
import 'package:kayaya_flutter/core/widgets/list_bottom_loader.dart';
import 'package:kayaya_flutter/core/widgets/player/source_chooser_dialog.dart';

class EpisodesTabViewItem extends StatefulWidget {
  final String id;
  final AnimeItemFieldsMixin anime;
  final Key tabKey;

  const EpisodesTabViewItem({
    Key key,
    this.tabKey,
    @required this.id,
    @required this.anime,
  }) : super(key: key);

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
              padding:
                  const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 6.0),
              sliver: SliverToBoxAdapter(
                child: UnconstrainedBox(
                  alignment: Alignment.centerLeft,
                  child: IconPopupMenu(
                    items: [
                      PopupMenuItem(
                        child: Text(TR.of(context).sort_asc),
                        value: SortOrder.asc,
                      ),
                      PopupMenuItem(
                        child: Text(TR.of(context).sort_desc),
                        value: SortOrder.desc,
                      ),
                    ],
                    title: TR.of(context).sort,
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
                      : _EpisodeListItem(
                          anime: widget.anime,
                          episode: state.episodes[index],
                        );
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
              Text(TR.of(context).no_episodes),
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

class _EpisodeListItem extends StatelessWidget {
  final AnimeItemFieldsMixin anime;
  final GetAnimeEpisodes$Query$Episodes$Data episode;

  const _EpisodeListItem({
    Key key,
    @required this.anime,
    @required this.episode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    final _subtitleColor = _textTheme.bodyText2.copyWith(
      color: _textTheme.caption.color,
    );

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
          launchPlayRelease(
            context,
            anime,
            episode,
            chosenRelease,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            episode.thumbnail != null
                ? CachedNetworkImage(
                    imageUrl: episode.thumbnail,
                    width: 120,
                    height: 120 / 16 * 9,
                  )
                : Container(
                    width: 120,
                    height: 120 / 16 * 9,
                    color: Colors.black,
                  ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TR.of(context).episode_item(episode.number),
                    style: _textTheme.subtitle1,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    episode.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _subtitleColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
