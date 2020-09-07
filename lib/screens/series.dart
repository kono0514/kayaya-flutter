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
import 'package:kayaya_flutter/widgets/anime_details/anime_detail.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_episodes.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_info.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_related.dart';
import 'package:kayaya_flutter/widgets/colored_tab_bar.dart';
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
  final List<String> _tabs = ['INFO', 'EPISODES', 'RELATED'];

  final GlobalKey<NestedScrollViewState> _key =
      GlobalKey<NestedScrollViewState>();

  @override
  void initState() {
    anime = widget.argument;
    _controller = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _tabBar = TabBar(
      tabs: _tabs.map((e) => Tab(text: e)).toList(),
      controller: _controller,
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,
      labelColor: Theme.of(context).textTheme.bodyText1.color,
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
                            right: 20,
                            bottom: 53 + _tabBar.preferredSize.height,
                            child: AnimeDetail(
                              anime: anime,
                              actions: [
                                FlatButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.notifications),
                                  label: Text('SUBSCRIBE'),
                                  color: Theme.of(context).primaryColor,
                                  textTheme: ButtonTextTheme.primary,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: _isDark ? Colors.black : Colors.white,
                    bottom: ColoredTabBar(
                      color: _isDark ? Colors.black : Colors.white,
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
