import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/anime_details/anime_details_cubit.dart';
import 'package:kayaya_flutter/easing_linear_gradient.dart';
import 'package:kayaya_flutter/hex_color.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/screens/series/tab_episodes.dart';
import 'package:kayaya_flutter/screens/series/tab_info.dart';
import 'package:kayaya_flutter/screens/series/tab_related.dart';
import 'package:kayaya_flutter/widgets/rating_bar.dart';
import 'package:kayaya_flutter/widgets/rounded_cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

// (Implemented workaround with extended_nested_scroll_view) TODO: https://github.com/flutter/flutter/issues/40740

class SeriesPage extends StatefulWidget {
  final ListItemAnimeMixin argument;

  SeriesPage(this.argument);

  @override
  _SeriesPageState createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage>
    with SingleTickerProviderStateMixin {
  ListItemAnimeMixin anime;
  TabController _controller;
  final GlobalKey<NestedScrollViewState> _key =
      GlobalKey<NestedScrollViewState>();

  @override
  void initState() {
    anime = widget.argument;
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TabBar _tabBar = TabBar(
      tabs: [Tab(text: 'Info'), Tab(text: 'Episodes'), Tab(text: 'Related')],
      controller: _controller,
    );
    final double _appBarHeight = 335.0 + _tabBar.preferredSize.height;
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) =>
          AnimeDetailsCubit(context.repository<AniimRepository>())
            ..loadDetails(anime.id),
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: NestedScrollView(
            key: _key,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    floating: true,
                    pinned: true,
                    expandedHeight: _appBarHeight,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () => {},
                        tooltip: 'Share',
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: _buildBackgroundWidget(),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 53 + _tabBar.preferredSize.height,
                            child: _buildPosterWidget(),
                          ),
                          Positioned(
                            left: 149,
                            right: 20,
                            bottom: 53 + _tabBar.preferredSize.height,
                            child: _buildInfoWidget(),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: _isDark ? Colors.black : Colors.white,
                    bottom: ColoredTabBar(
                      color: Colors.deepPurple,
                      tabBar: _tabBar,
                    ),
                    elevation: 0.0,
                  ),
                ),
              ];
            },
            innerScrollPositionKeyBuilder: () => Key('Tab${_controller.index}'),
            body: TabBarView(
              controller: _controller,
              children: [
                InfoTabViewItem(tabKey: Key('Tab0'), anime: anime),
                EpisodesTabViewItem(tabKey: Key('Tab1'), id: anime.id),
                RelatedTabViewItem(tabKey: Key('Tab2')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoWidget() {
    final separator = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text('•'),
    );
    TextTheme textTheme = Theme.of(context).textTheme;
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          anime.name.mn,
          style: textTheme.headline4
              .apply(color: _isDark ? Colors.white : Colors.black),
          maxLines: 3,
        ),
        SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<AnimeDetailsCubit, AnimeDetailsState>(
              builder: (context, state) {
                if (state is AnimeDetailsInitial) {
                  return Shimmer.fromColors(
                    baseColor: _isDark ? Colors.grey[700] : Colors.grey[300],
                    highlightColor:
                        _isDark ? Colors.grey[500] : Colors.grey[100],
                    child: Row(
                      children: [
                        Container(width: 35, height: 5, color: Colors.white),
                        separator,
                        Container(width: 45, height: 5, color: Colors.white),
                        separator,
                        Container(width: 45, height: 5, color: Colors.white),
                      ],
                    ),
                  );
                }

                if (state is AnimeDetailsLoaded) {
                  final items = <Widget>[];

                  final year =
                      state.details.anilist.startDate?.year?.toString();
                  if (year != null) {
                    items.add(Text(year));
                  }

                  final totalEpisodes =
                      state.details.anilist.episodes?.toString();
                  if (totalEpisodes != null) {
                    items.addAll([separator, Text('$totalEpisodes анги')]);
                  }

                  final duration = state.details.anilist.duration?.toString();
                  if (duration != null) {
                    items.addAll([separator, Text('$duration мин')]);
                  }

                  return Row(children: items);
                }

                return Row();
              },
            ),
          ],
        ),
        SizedBox(height: 12),
        FlatButton(
          onPressed: () {},
          child: Text('SUBSCRIBE'),
          color: Theme.of(context).primaryColor,
          textTheme: ButtonTextTheme.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  Widget _buildPosterWidget() {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: <Widget>[
        RoundedCachedNetworkImage(
          url: anime.coverImage.large,
          width: 109,
          height: 163,
          placeholderColor: HexColor(
            anime.coverColor ?? "#000000",
          ),
          boxShadow: BoxShadow(
            blurRadius: 5.0,
            spreadRadius: 2.0,
            color: _isDark
                ? Colors.white.withOpacity(0.8)
                : Colors.grey[400].withOpacity(0.8),
          ),
        ),
        if (anime.rating != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RatingBar(
              rating: anime.rating,
              size: 16,
              color: _isDark ? Colors.yellow : Colors.yellow[800],
            ),
          ),
      ],
    );
  }

  Widget _buildBackgroundWidget() {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    final decoration = BoxDecoration(
      gradient: EasingLinearGradient.generate(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        fromColor: _isDark
            ? Color.fromRGBO(0, 0, 0, 0.3)
            : Color.fromRGBO(255, 255, 255, 0.4),
        toColor: _isDark
            ? Color.fromRGBO(0, 0, 0, 1)
            : Color.fromRGBO(255, 255, 255, 1),
      ),
      border:
          Border.all(width: 0, color: _isDark ? Colors.black : Colors.white),
    );

    return Container(
      height: 300,
      foregroundDecoration: decoration,
      child: anime.bannerImage == null
          ? null
          : CachedNetworkImage(
              imageUrl: anime.bannerImage,
              fit: BoxFit.cover,
            ),
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({this.color, this.tabBar});

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}
