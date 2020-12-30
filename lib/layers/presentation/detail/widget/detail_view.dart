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
                    leading: _AppBarIconButton(
                      icon: Icons.arrow_back,
                      tooltip: TR.of(context).share,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    iconTheme: const IconThemeData(),
                    actionsIconTheme: const IconThemeData(),
                    actions: <Widget>[
                      _AppBarIconButton(
                        icon: Icons.ios_share,
                        tooltip: TR.of(context).share,
                        onPressed: () => {},
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Positioned.fill(
                            child: _buildBackgroundWidget(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimeInfo(anime: widget.anime),
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
              child: _ActionButtons(
                anime: widget.anime,
                tabController: tabController,
                actions: widget.actions,
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

    return RepaintBoundary(
      child: Container(
        foregroundDecoration: decoration,
        child: widget.anime.bannerImage == null
            ? null
            : CachedNetworkImage(
                imageUrl: widget.anime.bannerImage,
                fit: BoxFit.cover,
              ),
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

class _ActionButtons extends StatefulWidget {
  final Anime anime;
  final TabController tabController;
  final List<Widget> actions;

  const _ActionButtons({
    Key key,
    @required this.anime,
    @required this.tabController,
    this.actions = const [],
  }) : super(key: key);

  @override
  __ActionButtonsState createState() => __ActionButtonsState();
}

class __ActionButtonsState extends State<_ActionButtons>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _slideInAnimation;
  Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideInAnimation,
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: AnimatedBuilder(
          animation: widget.tabController.animation,
          builder: (context, child) {
            var opacity = 1.0;

            // Hide buttons in 2nd tab (Series page - Episodes tab)
            if (widget.anime.isSeries) {
              final aniVal = widget.tabController.animation.value;

              if (widget.tabController.indexIsChanging) {
                // Do no animation when change was triggered by clicking on a TabBar tab
                opacity = widget.tabController.index == 1 ? 0.0 : 1.0;
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: widget.actions ?? [],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _AppBarIconButton({
    Key key,
    @required this.icon,
    this.onPressed,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDark = Theme.of(context).brightness == Brightness.dark;

    return UnconstrainedBox(
      child: IconButton(
        icon: Container(
          decoration: ShapeDecoration(
            color: _isDark ? Colors.black54 : Colors.white70,
            shape: const CircleBorder(),
          ),
          child: Center(
            child: Icon(icon),
          ),
        ),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
