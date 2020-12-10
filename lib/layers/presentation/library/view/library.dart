import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bar/custom_sliver_app_bar.dart';
import '../../../../core/widgets/app_bar/sliver_button.dart';
import '../../../../core/widgets/list_bottom_loader.dart';
import '../../../../core/widgets/material_dialog.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../../router.dart';
import '../../settings/view/settings_dialog.dart';
import '../cubit/subscription_list_cubit.dart';

class LibraryPage extends StatefulWidget {
  final ScrollController scrollController;

  const LibraryPage({Key key, this.scrollController}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Completer<void> refreshCompleter;

  // Disable infinite scroll while more data is loading
  bool disableInfiniteScroll = false;

  @override
  void initState() {
    super.initState();
    refreshCompleter = Completer<void>();
    context.read<SubscriptionListCubit>().loadSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        controller: widget.scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CustomSliverAppBar(
              title: Text(TR.of(context).tabs_library),
              actions: [
                SliverButton(
                  text: Text(
                    TR.of(context).settings.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    showCustomMaterialSheet(
                      context: context,
                      useRootNavigator: true,
                      isDismissible: true,
                      enableDrag: true,
                      height: 1.0,
                      labelBuilder: (context) => Text(TR.of(context).settings),
                      builder: (context) => SettingsDialog(),
                    );
                  },
                  collapsible: false,
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ];
        },
        body: BlocConsumer<SubscriptionListCubit, SubscriptionListState>(
          listener: (context, state) {
            // Re-enable scroll fetching after receiving state change
            disableInfiniteScroll = false;
            if (state is SubscriptionListLoaded) {
              refreshCompleter?.complete();
              refreshCompleter = Completer();
            } else if (state is SubscriptionListInitial) {
              widget.scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
              );
            }
          },
          builder: (context, state) {
            if (state is SubscriptionListError) {
              return _LibraryError(error: state.exception.toString());
            }

            if (state is SubscriptionListEmpty) {
              return _LibraryEmpty();
            }

            if (state is SubscriptionListLoaded) {
              return buildListWidget(state);
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget buildListWidget(SubscriptionListLoaded state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth != 0) return false;
        if (notification.metrics.maxScrollExtent == 0) return false;
        if (disableInfiniteScroll) return false;

        //reach the pixels to load more
        if (notification.metrics.axisDirection == AxisDirection.down &&
            notification.metrics.pixels >
                notification.metrics.maxScrollExtent - 200) {
          disableInfiniteScroll = true;
          context.read<SubscriptionListCubit>().loadSubscriptions();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () {
          context.read<SubscriptionListCubit>().refreshSubscriptions();
          return refreshCompleter.future;
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(left: 16, top: 30, bottom: 14),
              sliver: SliverToBoxAdapter(
                child: Text(
                  TR.of(context).subscriptions,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index >= state.subscriptions.elements.length) {
                    return ListLoader(error: state.error != null);
                  }

                  final anime = state.subscriptions.elements[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: anime.coverImage,
                      width: 40,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    title: Text(anime.name),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        Routes.seriesPage,
                        arguments: MediaArguments(anime),
                      );
                    },
                  );
                },
                childCount: state.subscriptions.hasMorePages
                    ? state.subscriptions.elements.length + 1
                    : state.subscriptions.elements.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryError extends StatelessWidget {
  final String error;

  const _LibraryError({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
              context.read<SubscriptionListCubit>().refreshSubscriptions();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _LibraryEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              TR.of(context).no_subscriptions,
            ),
            TextButton(
              onPressed: () {
                context.read<SubscriptionListCubit>().refreshSubscriptions();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
