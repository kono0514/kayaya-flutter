import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;

import '../../../../core/widgets/colored_tab_bar.dart';
import '../../../../core/widgets/keep_alive_widget.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/anime.dart';
import 'anime_info.dart';

class DetailView extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> tabViews;
  final List<Widget> actions;
  final Anime anime;

  const DetailView({
    Key key,
    @required this.tabs,
    @required this.tabViews,
    @required this.anime,
    this.actions,
  })  : assert(tabs.length == tabViews.length),
        super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<NestedScrollViewState> _key =
      GlobalKey<NestedScrollViewState>();

  TabController tabController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            NestedScrollView(
              key: _key,
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    expandedHeight: 310,
                    titleSpacing: 0,
                    title: _SliverAppBarTitle(
                      title: Text(widget.anime.name),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () => {},
                        tooltip: TR.of(context).share,
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        children: [
                          Positioned.fill(
                            child: _buildBackgroundWidget(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimeInfo(
                              anime: widget.anime,
                              actions: widget.actions ?? [],
                            ),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: _isDark ? Colors.black : Colors.white,
                    elevation: 0.0,
                  ),
                ];
              },
              pinnedHeaderSliverHeightBuilder: () =>
                  MediaQuery.of(context).padding.top + kToolbarHeight,
              innerScrollPositionKeyBuilder: () =>
                  Key('Tab${tabController.index}'),
              body: Column(
                children: [
                  ColoredTabBar(
                    color: _isDark ? Colors.black : Colors.white,
                    tabBar: TabBar(
                      tabs: widget.tabs
                          .map((e) => Tab(text: e.toUpperCase()))
                          .toList(),
                      controller: tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      labelColor: Theme.of(context).textTheme.bodyText1.color,
                      onTap: (index) {
                        // Active tab clicked
                        if (!tabController.indexIsChanging) {
                          // Scroll to top without triggering any RefreshIndicator
                          scrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: widget.tabViews
                          .map((e) => KeepAliveWidget(child: e))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: tabController.animation,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: widget.actions ?? [],
                  ),
                ),
                builder: (context, child) {
                  var opacity = 1.0;

                  // Hide buttons in 2nd tab (Series page - Episodes tab)
                  if (widget.anime.isSeries) {
                    final aniVal = tabController.animation.value;

                    if (tabController.indexIsChanging) {
                      // Do no animation when change was triggered by clicking on a TabBar tab
                      opacity = tabController.index == 1 ? 0.0 : 1.0;
                    } else {
                      // Animate opacity otherwise (user is dragging across tabs)
                      if (aniVal > 0 && aniVal < 2) {
                        opacity = (1 - aniVal).abs();
                      }
                    }
                  }

                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundWidget() {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    final decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: _isDark
            ? [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(1),
              ]
            : [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(1),
              ],
        stops: _isDark ? [0.42, 0.9] : [0.3, 0.5, 0.9],
      ),
      border:
          Border.all(width: 0, color: _isDark ? Colors.black : Colors.white),
    );

    return Container(
      foregroundDecoration: decoration,
      child: widget.anime.bannerImage == null
          ? null
          : CachedNetworkImage(
              imageUrl: widget.anime.bannerImage,
              fit: BoxFit.cover,
            ),
    );
  }
}

class _SliverAppBarTitle extends StatelessWidget {
  final Widget title;

  const _SliverAppBarTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    assert(
      settings != null,
      'A SliverButton must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().',
    );
    final double deltaExtent = settings.maxExtent - settings.minExtent;

    // 0.0 -> Expanded
    // 1.0 -> Collapsed to toolbar
    final double t =
        (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
            .clamp(0.0, 1.0) as double;

    var _opacity = 0.0;
    if (t >= 0.9) {
      _opacity = 1.0;
    }

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 200),
      child: title,
    );
  }
}
