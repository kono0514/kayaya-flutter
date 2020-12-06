import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/icon_popup_menu.dart';
import '../../../../core/widgets/list_bottom_loader.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../../router.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/entities/episode.dart';
import '../../../domain/entities/release.dart';
import '../../player/widget/source_chooser_dialog.dart';
import '../bloc/episodes_bloc.dart';

class EpisodesTabViewItem extends StatefulWidget {
  final Anime anime;
  final Key tabKey;

  const EpisodesTabViewItem({
    Key key,
    this.tabKey,
    @required this.anime,
  }) : super(key: key);

  @override
  _EpisodesTabViewItemState createState() => _EpisodesTabViewItemState();
}

class _EpisodesTabViewItemState extends State<EpisodesTabViewItem> {
  Completer<void> _refreshCompleter;

  // Disable infinite scroll while more data is loading
  bool disableInfiniteScroll = false;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollViewInnerScrollPositionKeyWidget(
      widget.tabKey,
      BlocProvider(
        create: (context) => GetIt.I<EpisodesBloc>()
          ..add(EpisodesFetched(widget.anime.id, sortOrder: 'asc')),
        child: BlocConsumer<EpisodesBloc, EpisodesState>(
          listener: (context, state) {
            if (state is EpisodesLoaded) {
              if (state.episodes.hasMorePages) {
                disableInfiniteScroll = false;
              }
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            if (state is EpisodesError) {
              return _EpisodesError(
                animeId: widget.anime.id,
                error: state.exception.toString(),
              );
            }

            if (state is EpisodesEmpty) {
              return _EpisodesEmpty(animeId: widget.anime.id);
            }

            if (state is EpisodesLoaded) {
              return buildListWidget(state);
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget buildListWidget(EpisodesLoaded state) {
    return Builder(
      builder: (context) => NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth != 0) return false;
          if (notification.metrics.maxScrollExtent == 0) return false;
          if (disableInfiniteScroll) return false;

          //reach the pixels to loading more
          if (notification.metrics.axisDirection == AxisDirection.down &&
              notification.metrics.pixels >
                  notification.metrics.maxScrollExtent - 200) {
            disableInfiniteScroll = true;
            context.read<EpisodesBloc>().add(EpisodesFetched(widget.anime.id));
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () {
            context
                .read<EpisodesBloc>()
                .add(EpisodesRefreshed(widget.anime.id));
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
                          value: 'asc',
                        ),
                        PopupMenuItem(
                          child: Text(TR.of(context).sort_desc),
                          value: 'desc',
                        ),
                      ],
                      title: TR.of(context).sort,
                      icon: Icon(Icons.sort),
                      initialValue: state.sortOrder,
                      onSelected: (value) {
                        context.read<EpisodesBloc>().add(EpisodesRefreshed(
                              widget.anime.id,
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
                    return index >= state.episodes.elements.length
                        ? ListBottomLoader(error: state.error != null)
                        : _EpisodeListItem(
                            anime: widget.anime,
                            episode: state.episodes.elements[index],
                          );
                  },
                  childCount: state.episodes.hasMorePages
                      ? state.episodes.elements.length + 1
                      : state.episodes.elements.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EpisodeListItem extends StatelessWidget {
  final Anime anime;
  final Episode episode;

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
        final chosenRelease = await showDialog<Release>(
          context: context,
          builder: (context) => SourceChooserDialog(
            releases: episode.releases,
          ),
        );

        if (chosenRelease != null) {
          Navigator.of(context, rootNavigator: true).pushNamed(
            Routes.seriesPlayer,
            arguments: SeriesPlayerArguments(
              anime: anime,
              episode: episode,
              release: chosenRelease,
            ),
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

class _EpisodesError extends StatelessWidget {
  final String animeId;
  final String error;

  const _EpisodesError({Key key, @required this.error, @required this.animeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                error,
                style: TextStyle(
                  color: Colors.red[400],
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<EpisodesBloc>().add(EpisodesRefreshed(animeId));
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EpisodesEmpty extends StatelessWidget {
  final String animeId;

  const _EpisodesEmpty({Key key, @required this.animeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(TR.of(context).no_episodes),
              TextButton(
                onPressed: () {
                  context.read<EpisodesBloc>().add(EpisodesRefreshed(animeId));
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
