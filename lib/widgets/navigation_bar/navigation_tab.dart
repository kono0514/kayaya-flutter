import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/logger.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/screens/tabs/browse.dart';
import 'package:kayaya_flutter/screens/tabs/featured.dart';
import 'package:kayaya_flutter/screens/tabs/library.dart';
import 'package:kayaya_flutter/screens/tabs/search.dart';

class TabViewItem {
  final GlobalKey<NavigatorState> navigatorKey;
  final Function pageWidget;
  final BottomNavigationBarItem navbarItem;
  final ScrollController scrollController;

  TabViewItem(
      {@required this.navigatorKey,
      @required this.pageWidget,
      @required this.navbarItem,
      @required this.scrollController});
}

class NavigationTab extends StatefulWidget {
  @override
  _NavigationTabState createState() => _NavigationTabState();
}

class _NavigationTabState extends State<NavigationTab> {
  int previousTabIndex = 1;
  final CupertinoTabController _tabController =
      CupertinoTabController(initialIndex: 0);

  final List<TabViewItem> items = [
    TabViewItem(
      navbarItem: BottomNavigationBarItem(
        icon: Icon(Icons.donut_small),
        title: Text(S.current.tabs_discover),
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      pageWidget: (scrollController) =>
          FeaturedPage(scrollController: scrollController),
      scrollController: ScrollController(),
    ),
    TabViewItem(
      navbarItem: BottomNavigationBarItem(
        icon: Icon(Icons.local_movies),
        title: Text(S.current.tabs_browse),
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      pageWidget: (scrollController) =>
          BrowsePage(scrollController: scrollController),
      scrollController: ScrollController(),
    ),
    TabViewItem(
      navbarItem: BottomNavigationBarItem(
        icon: Icon(Icons.library_add),
        title: Text(S.current.tabs_library),
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      pageWidget: (scrollController) =>
          LibraryPage(scrollController: scrollController),
      scrollController: ScrollController(),
    ),
    TabViewItem(
      navbarItem: BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text(S.current.tabs_search),
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      pageWidget: (scrollController) =>
          SearchPage(scrollController: scrollController),
      scrollController: ScrollController(),
    )
  ];
  // final ValueNotifier<double> heightNotifier = ValueNotifier<double>(1.0);
  // final ValueNotifier<double> snapNotifier = ValueNotifier<double>(0.0);
  DateTime _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Pop from the current tab's route stack, if possible.
        var tabNavigatorPopped =
            await _currentTabViewItem().navigatorKey.currentState.maybePop();

        // Nothing was popped. This means we're on a tab's root route and user pressed back button.
        if (!tabNavigatorPopped) {
          if (_tabController.index == 0) return await shouldPopAppRoot();

          _tabController.index = 0;
          previousTabIndex = 0;
          return false;
        }

        return false;
      },
      child: CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          backgroundColor:
              CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
          onTap: (value) {
            // Same tab clicked. Pop or scroll to top
            if (previousTabIndex == value) {
              var canPop =
                  _currentTabViewItem().navigatorKey.currentState?.canPop();

              if (canPop == null) return;

              if (canPop) {
                _currentTabViewItem()
                    .navigatorKey
                    .currentState
                    ?.popUntil((route) => route.isFirst);
              }
              _currentTabViewItem().scrollController.animateTo(0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linear);
            }

            previousTabIndex = value;
          },
          items: items.map((e) => e.navbarItem).toList(),
        ),
        tabBuilder: (context, index) {
          var item = items[index];

          return CupertinoTabView(
            navigatorKey: item.navigatorKey,
            onGenerateRoute: Routes.materialRoutes,
            builder: (context) {
              return item.pageWidget(item.scrollController);
            },
          );
        },
      ),
      /*
        TODO: Snap behaviour not implemented
      */
      // child: ScrollBottomNavigationBar(
      //   heightNotifier: heightNotifier,
      //   snapNotifier: snapNotifier,
      //   child: CupertinoTabScaffold(
      //     controller: _tabController,
      //     tabBar: CustomCupertinoTabBar(
      //       valueListenable: heightNotifier,
      //       backgroundColor:
      //           CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
      //       onTap: (value) {
      //         // Same tab clicked. Pop or scroll to top
      //         if (previousTabIndex == value) {
      //           var canPop =
      //               _currentTabViewItem().navigatorKey.currentState?.canPop();

      //           if (canPop == null) return;

      //           if (canPop) {
      //             _currentTabViewItem()
      //                 .navigatorKey
      //                 .currentState
      //                 ?.popUntil((route) => route.isFirst);
      //           }
      //           _currentTabViewItem().scrollController.animateTo(0.0,
      //               duration: const Duration(milliseconds: 300),
      //               curve: Curves.linear);
      //         }

      //         previousTabIndex = value;
      //       },
      //       items: items.map((e) => e.navbarItem).toList(),
      //     ),
      //     tabBuilder: (context, index) {
      //       var item = items[index];

      //       return CupertinoTabView(
      //         navigatorKey: item.navigatorKey,
      //         onGenerateRoute: Routes.materialRoutes,
      //         builder: (context) {
      //           return item.pageWidget(item.scrollController);
      //         },
      //       );
      //     },
      //   ),
      // ),
    );
  }

  TabViewItem _currentTabViewItem() {
    return items[_tabController.index];
  }

  Future<bool> shouldPopAppRoot() async {
    final snackbarVisibleDuration = Duration(seconds: 2);
    final now = DateTime.now();
    final difference = now.difference(_lastBackPressTime ?? now);

    /// Can only exit while snackbar is visible
    /// Ignore quick succession taps
    if (difference.inMilliseconds > 200 &&
        difference < snackbarVisibleDuration) {
      return true;
    }

    _lastBackPressTime = now;
    // Prevent duplicate snackbar
    if (difference >= snackbarVisibleDuration) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: snackbarVisibleDuration,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return false;
  }
}
