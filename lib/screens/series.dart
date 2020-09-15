import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/anime_details/anime_details_cubit.dart';
import 'package:kayaya_flutter/cubit/anime_subscription_cubit.dart';
import 'package:kayaya_flutter/widgets/easing_linear_gradient.dart';
import 'package:kayaya_flutter/hex_color.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/anime_details/anime_detail.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_episodes.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_info.dart';
import 'package:kayaya_flutter/widgets/anime_details/tab_related.dart';
import 'package:kayaya_flutter/widgets/colored_tab_bar.dart';
import 'package:kayaya_flutter/widgets/keep_alive_widget.dart';
import 'package:kayaya_flutter/widgets/rating_bar.dart';
import 'package:kayaya_flutter/widgets/rounded_cached_network_image.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';
import 'package:shimmer/shimmer.dart';

// (Implemented workaround with extended_nested_scroll_view) TODO: https://github.com/flutter/flutter/issues/40740

class SeriesPage extends StatefulWidget {
  final MediaArguments argument;

  SeriesPage(this.argument);

  @override
  _SeriesPageState createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage>
    with SingleTickerProviderStateMixin {
  ListItemAnimeMixin anime;
  AnimeDetailsCubit animeDetailsCubit;
  TabController tabController;
  final List<String> _tabs = ['INFO', 'EPISODES', 'RELATED'];

  final GlobalKey<NestedScrollViewState> _key =
      GlobalKey<NestedScrollViewState>();

  @override
  void initState() {
    super.initState();
    anime = widget.argument.anime;
    animeDetailsCubit =
        AnimeDetailsCubit(context.repository<AniimRepository>());

    /// Only minimal amount of data was passed (id, poster, name)
    /// as opposed to the full listing item data (id, poster, name, banner, genres, etc...)
    /// So we should fetch other missing informations along with the details.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animeDetailsCubit.listen((state) {
        if (state is AnimeDetailsLoaded) {
          if (widget.argument.isMinimal) {
            setState(() {
              anime = state.listData;
            });
          }
        } else if (state is AnimeDetailsError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Failed to fetch'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Return'),
                ),
              ],
            ),
          ).then((value) => Navigator.of(context).pop());
        }
      });
      if (widget.argument.isMinimal) {
        animeDetailsCubit.loadDetailsFull(anime.id);
      } else {
        animeDetailsCubit.loadDetails(anime.id);
      }
    });

    tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    animeDetailsCubit.close();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _tabBar = TabBar(
      tabs: _tabs.map((e) => Tab(text: e)).toList(),
      controller: tabController,
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,
      labelColor: Theme.of(context).textTheme.bodyText1.color,
    );
    final double _appBarHeight = 335.0 + _tabBar.preferredSize.height;
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: animeDetailsCubit),
        BlocProvider(
          create: (context) => AnimeSubscriptionCubit(
            context.repository<AniimRepository>(),
          ),
        ),
      ],
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
                                SeriesSubscribeButton(id: anime.id),
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
            innerScrollPositionKeyBuilder: () =>
                Key('Tab${tabController.index}'),
            body: TabBarView(
              controller: tabController,
              children: [
                KeepAliveWidget(
                  child: InfoTabViewItem(tabKey: Key('Tab0'), anime: anime),
                ),
                KeepAliveWidget(
                  child: EpisodesTabViewItem(tabKey: Key('Tab1'), id: anime.id),
                ),
                KeepAliveWidget(
                  child: RelatedTabViewItem(tabKey: Key('Tab2')),
                ),
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

class SeriesSubscribeButton extends StatelessWidget {
  final String id;

  const SeriesSubscribeButton({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeDetailsCubit, AnimeDetailsState>(
      listener: (context, state) {
        if (state is AnimeDetailsLoaded) {
          context
              .bloc<AnimeSubscriptionCubit>()
              .assignData(id, state.details.subscribed);
        }
      },
      child: BlocBuilder<AnimeSubscriptionCubit, AnimeSubscriptionState>(
        builder: (context, state) {
          Text label;
          Icon icon;
          Function onPressed = () {};
          bool loading = true;

          if (state is AnimeSubscriptionLoaded) {
            loading = false;
            label = Text(
                (state.subscribed ? 'Subscribed' : 'Subscribe').toUpperCase());
            icon = Icon(state.subscribed
                ? Icons.notifications_active
                : Icons.notifications_none);
            onPressed = () {
              final bloc = context.bloc<AnimeSubscriptionCubit>();
              if (state.subscribed) {
                bloc.unsubscribe();
              } else {
                bloc.subscribe();
              }
            };
          }

          return SpinnerButton(
            label: label,
            icon: icon,
            loading: loading,
            fixedWidth: 165,
            onPressed: onPressed,
          );
        },
      ),
    );
  }
}
