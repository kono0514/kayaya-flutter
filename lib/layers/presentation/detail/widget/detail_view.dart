import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;

import '../../../../core/widgets/colored_tab_bar.dart';
import '../../../../core/widgets/easing_linear_gradient.dart';
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
        child: NestedScrollView(
          key: _key,
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 335.0,
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
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: _buildBackgroundWidget(),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 53,
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
          innerScrollPositionKeyBuilder: () => Key('Tab${tabController.index}'),
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
      child: widget.anime.bannerImage == null
          ? null
          : CachedNetworkImage(
              imageUrl: widget.anime.bannerImage,
              fit: BoxFit.cover,
            ),
    );
  }
}
