import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../layers/presentation/browse/view/browse_page.dart';
import '../../../layers/presentation/featured/view/featured_page.dart';
import '../../../layers/presentation/library/view/library.dart';
import '../../../layers/presentation/search/view/search_page.dart';
import '../../../locale/generated/l10n.dart';
import '../../../router.dart';
import 'material_tab_scaffold.dart';

class NavigationTabScaffold extends StatefulWidget {
  @override
  _NavigationTabScaffoldState createState() => _NavigationTabScaffoldState();
}

class _NavigationTabScaffoldState extends State<NavigationTabScaffold> {
  int _previousTabIndex = 0;
  CupertinoTabController _tabController;

  final List<TabNavigatorItem> items = [
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: const Icon(Icons.donut_small),
        label: TR.current.tabs_discover,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      scrollController: ScrollController(),
      pageBuilder: (scrollController) =>
          FeaturedPage(scrollController: scrollController),
    ),
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: const Icon(Icons.local_movies),
        label: TR.current.tabs_browse,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      scrollController: ScrollController(),
      pageBuilder: (scrollController) =>
          BrowsePage(scrollController: scrollController),
    ),
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: const Icon(Icons.library_add),
        label: TR.current.tabs_library,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      scrollController: ScrollController(),
      pageBuilder: (scrollController) =>
          LibraryPage(scrollController: scrollController),
    ),
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: const Icon(Icons.search),
        label: TR.current.tabs_search,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      scrollController: ScrollController(),
      pageBuilder: (_) => const SearchPage(),
    ),
  ];
  // final ValueNotifier<double> heightNotifier = ValueNotifier<double>(1.0);
  // final ValueNotifier<double> snapNotifier = ValueNotifier<double>(0.0);
  DateTime _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () async {
            // Pop from the current tab's route stack, if possible.
            final tabNavigatorPopped = await _currentTabNavigatorItem
                .navigatorKey.currentState
                .maybePop();

            // Nothing was popped. This means we're on a tab's root route and user pressed back button.
            if (!tabNavigatorPopped) {
              if (_tabController.index == 0) return shouldPopAppRoot();

              _tabController.index = 0;
              _previousTabIndex = 0;
              return false;
            }

            return false;
          },
          child: CupertinoTabScaffold(
            controller: _tabController,
            tabBar: CupertinoTabBar(
              backgroundColor: CupertinoTheme.of(context)
                  .barBackgroundColor
                  .withOpacity(1.0),
              onTap: (index) {
                // Same tab clicked. Pop or scroll to top
                if (_previousTabIndex == index) {
                  final canPop = _currentTabNavigatorItem
                      .navigatorKey.currentState
                      ?.canPop();

                  if (canPop == null) return;

                  if (canPop) {
                    _currentTabNavigatorItem.navigatorKey.currentState
                        ?.popUntil((route) => route.isFirst);
                    return;
                  }
                  _currentTabNavigatorItem.scrollController.animateTo(0.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear);
                }

                _previousTabIndex = index;
              },
              items: items.map((e) => e.navbarItem()).toList(),
            ),
            tabBuilder: (context, index) {
              final TabNavigatorItem item = items[index];

              return CupertinoTabView(
                navigatorKey: item.navigatorKey,
                onGenerateRoute: MyRouter(),
                builder: (context) {
                  return item.pageBuilder(item.scrollController);
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
          //               _currentTabNavigatorItem().navigatorKey.currentState?.canPop();

          //           if (canPop == null) return;

          //           if (canPop) {
          //             _currentTabNavigatorItem()
          //                 .navigatorKey
          //                 .currentState
          //                 ?.popUntil((route) => route.isFirst);
          //           }
          //           _currentTabNavigatorItem().scrollController.animateTo(0.0,
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
        ),
      ),
    );
  }

  TabNavigatorItem get _currentTabNavigatorItem => items[_tabController.index];

  Future<bool> shouldPopAppRoot() async {
    const snackbarVisibleDuration = Duration(seconds: 2);
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
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: snackbarVisibleDuration,
          ),
        );
    }
    return false;
  }
}
