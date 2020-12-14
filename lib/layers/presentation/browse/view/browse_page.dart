import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/layers/presentation/browse/cubit/browse_filter_cubit.dart';

import '../../../../core/widgets/app_bar/custom_sliver_app_bar.dart';
import '../../../../core/widgets/list_bottom_loader.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../../router.dart';
import '../bloc/browse_bloc.dart';
import '../widget/browse_list_item.dart';
import '../widget/filter_button.dart';

class BrowsePage extends StatefulWidget {
  final ScrollController scrollController;

  const BrowsePage({Key key, this.scrollController}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  Completer<void> refreshCompleter;

  // Disable infinite scroll while more data is loading
  bool disableInfiniteScroll = false;

  @override
  void initState() {
    super.initState();
    refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<BrowseFilterCubit>(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<BrowseBloc>(
            param1: context.read<BrowseFilterCubit>(),
          )..add(BrowseFetched()),
        ),
      ],
      child: Scaffold(
        extendBody: true,
        body: NestedScrollView(
          controller: widget.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CustomSliverAppBar(
                title: Text(TR.of(context).tabs_browse),
                actions: [
                  FilterButton(),
                ],
              ),
            ];
          },
          body: BlocConsumer<BrowseBloc, BrowseState>(
            listener: (context, state) {
              // Re-enable scroll fetching after receiving state change
              disableInfiniteScroll = false;
              if (state is BrowseLoaded) {
                refreshCompleter?.complete();
                refreshCompleter = Completer();
              } else if (state is BrowseInitial) {
                widget.scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                );
              }
            },
            builder: (context, state) {
              if (state is BrowseError) {
                return _BrowseError(error: state.exception.toString());
              }

              if (state is BrowseEmpty) {
                return _BrowseEmpty();
              }

              if (state is BrowseLoaded) {
                return buildListWidget(state);
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildListWidget(BrowseLoaded state) {
    return Builder(
      builder: (context) => NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth != 0) return false;
          if (notification.metrics.maxScrollExtent == 0) return false;
          if (disableInfiniteScroll) return false;

          //reach the pixels to load more
          if (notification.metrics.axisDirection == AxisDirection.down &&
              notification.metrics.pixels >
                  notification.metrics.maxScrollExtent - 200) {
            disableInfiniteScroll = true;
            context.read<BrowseBloc>().add(BrowseFetched());
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () {
            context.read<BrowseBloc>().add(BrowseRefreshed());
            return refreshCompleter.future;
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return index >= state.animes.elements.length
                        ? ListLoader(error: state.error != null)
                        : BrowseListItem(
                            anime: state.animes.elements[index],
                            onPressed: () {
                              final anime = state.animes.elements[index];
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(
                                Routes.movieOrSeries,
                                arguments: MediaArguments(anime),
                              );
                            },
                          );
                  },
                  childCount: state.animes.hasMorePages
                      ? state.animes.elements.length + 1
                      : state.animes.elements.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrowseError extends StatelessWidget {
  final String error;

  const _BrowseError({Key key, @required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            error,
            style: TextStyle(
              color: Colors.red.shade400,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<BrowseBloc>().add(BrowseRefreshed());
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _BrowseEmpty extends StatelessWidget {
  const _BrowseEmpty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No items found. Adjust filter and try again.',
          ),
          TextButton(
            onPressed: () {
              context.read<BrowseBloc>().add(BrowseRefreshed());
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
