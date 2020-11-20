import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/bloc/subscription_list_bloc.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/router.dart';
import 'package:kayaya_flutter/repositories/user_data_repository.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_sliver_app_bar.dart';
import 'package:kayaya_flutter/widgets/app_bar/sliver_button.dart';
import 'package:kayaya_flutter/screens/tabs/library/settings_dialog.dart';

class LibraryPage extends StatefulWidget {
  final ScrollController scrollController;

  const LibraryPage({Key key, this.scrollController}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Completer<void> refreshCompleter;
  SubscriptionListBloc subListBloc;

  @override
  void initState() {
    super.initState();
    refreshCompleter = Completer<void>();
    subListBloc = SubscriptionListBloc(UserDataRepositry())
      ..add(SubscriptionListFetched());
  }

  @override
  void dispose() {
    subListBloc.close();
    super.dispose();
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
              title: Text(S.of(context).tabs_library),
              actions: [
                SliverButton(
                  text: Text(
                    S.of(context).settings.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    BuildContext mainContext = context;
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          SettingsDialog(mainContext: mainContext),
                    );
                  },
                  collapsible: false,
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ];
        },
        body: BlocBuilder<SubscriptionListBloc, SubscriptionListState>(
          cubit: subListBloc,
          builder: (context, state) {
            if (state is SubscriptionListError) {
              return buildErrorWidget(state);
            }

            if (state is SubscriptionListEmpty) {
              return buildEmptyWidget();
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

  Widget buildErrorWidget(SubscriptionListError state) {
    return Center(
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
            onPressed: () => subListBloc.add(SubscriptionListFetched()),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).no_subscriptions,
            ),
            TextButton(
              onPressed: () => subListBloc.add(SubscriptionListFetched()),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListWidget(SubscriptionListLoaded state) {
    return RefreshIndicator(
      onRefresh: () {
        subListBloc.add(SubscriptionListFetched());
        return refreshCompleter.future;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.only(left: 16, top: 30, bottom: 14),
            sliver: SliverToBoxAdapter(
              child: Text(
                S.of(context).subscriptions,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final anime = state.subscriptions[index];
                return ListTile(
                  leading: CachedNetworkImage(imageUrl: anime.coverImage.large),
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
              childCount: state.subscriptions.length,
            ),
          ),
        ],
      ),
    );
  }
}
