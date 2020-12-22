import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../layers/presentation/browse/view/browse_page.dart';
import '../../../layers/presentation/featured/view/featured_page.dart';
import '../../../layers/presentation/library/view/library.dart';
import '../../../locale/generated/l10n.dart';
import '../../../router.dart';
import '../keep_alive_widget.dart';

class CurrentNavigationTabModel extends ChangeNotifier {
  int _index;

  int get index => _index;

  CurrentNavigationTabModel({int defaultIndex = 0}) : _index = defaultIndex;

  void changeIndex(int index) {
    this._index = index;
    notifyListeners();
  }
}

typedef TabNavigatorPageBuilder = Widget Function(
    ScrollController scrollController);

class TabNavigatorItem {
  final BottomNavigationBarItem Function() navbarItem;
  final String route;
  final GlobalKey<NavigatorState> navigatorKey;
  final TabNavigatorPageBuilder pageBuilder;
  final ScrollController scrollController;

  TabNavigatorItem({
    @required this.navbarItem,
    this.route,
    this.navigatorKey,
    this.pageBuilder,
    this.scrollController,
  }) : assert(route != null || pageBuilder != null);
}

class MaterialTabScaffold extends StatefulWidget {
  @override
  _MaterialTabScaffoldState createState() => _MaterialTabScaffoldState();
}

class _MaterialTabScaffoldState extends State<MaterialTabScaffold> {
  final int _defaultTabIndex = 0;
  PageController _pageController;

  final List<TabNavigatorItem> items = [
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: Icon(Icons.donut_small),
        label: TR.current.tabs_discover,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      scrollController: ScrollController(),
      pageBuilder: (scrollController) =>
          FeaturedPage(scrollController: scrollController),
    ),
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: Icon(Icons.local_movies),
        label: TR.current.tabs_browse,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      scrollController: ScrollController(),
      pageBuilder: (scrollController) =>
          BrowsePage(scrollController: scrollController),
    ),
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        label: TR.current.tabs_library,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      scrollController: ScrollController(),
      pageBuilder: (scrollController) =>
          LibraryPage(scrollController: scrollController),
    ),
    TabNavigatorItem(
      navbarItem: () => BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: TR.current.tabs_search,
      ),
      route: Routes.searchPage,
    ),
  ];
  DateTime _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _defaultTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentNavigationTabModel>(
      create: (context) =>
          CurrentNavigationTabModel(defaultIndex: _defaultTabIndex),
      child: Scaffold(
        body: Builder(
          builder: (context) => WillPopScope(
            onWillPop: () async {
              final _currentTabNavigatorItem =
                  items[context.read<CurrentNavigationTabModel>().index];

              // Pop from the current tab's route stack, if possible.
              var tabNavigatorPopped = await _currentTabNavigatorItem
                  .navigatorKey.currentState
                  .maybePop();

              // Nothing was popped. This means we're on a tab's root route and user pressed back button.
              if (!tabNavigatorPopped) {
                if (context.read<CurrentNavigationTabModel>().index == 0)
                  return await shouldPopAppRoot(context);

                _changeTab(0);
                return false;
              }

              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                context.read<CurrentNavigationTabModel>().changeIndex(index);
              },
              itemBuilder: (context, index) {
                final TabNavigatorItem item = items[index];

                return CustomMaterialTabView(
                  navigatorKey: item.navigatorKey,
                  onGenerateRoute: MyRouter(),
                  builder: (context) {
                    print('CustomMaterialTabView builder');
                    return KeepAliveWidget(
                      child: item.pageBuilder(item.scrollController),
                    );
                  },
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color(0x29000000)
                      : Color(0x4C000000),
                  width: 0.0, // One physical pixel.
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Consumer<CurrentNavigationTabModel>(
              builder: (context, tabModel, child) => BottomNavigationBar(
                elevation: 0.0,
                type: BottomNavigationBarType.fixed,
                unselectedFontSize: 12.0,
                selectedFontSize: 12.0,
                showUnselectedLabels: false,
                items: items.map((e) => e.navbarItem()).toList(),
                currentIndex: tabModel.index,
                onTap: (index) {
                  // Same tab clicked. Pop or scroll to top
                  if (tabModel.index == index) {
                    final _currentTabNavigatorItem = items[tabModel.index];

                    var canPop = _currentTabNavigatorItem
                        .navigatorKey.currentState
                        ?.canPop();

                    if (canPop == null) return;

                    if (canPop) {
                      _currentTabNavigatorItem.navigatorKey.currentState
                          ?.popUntil((route) => route.isFirst);
                      return;
                    }

                    if (_currentTabNavigatorItem.scrollController.hasClients) {
                      _currentTabNavigatorItem.scrollController.animateTo(0.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.linear);
                    }
                  }

                  // "Fake" tab item that opens a new root route on click
                  if (items[index].route != null) {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(items[index].route);
                  } else {
                    _changeTab(index);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changeTab(int index) {
    _pageController.jumpToPage(index);
  }

  Future<bool> shouldPopAppRoot(BuildContext context) async {
    final snackbarVisibleDuration = Duration(seconds: 2);
    final now = DateTime.now();

    var difference;
    if (_lastBackPressTime == null) {
      difference = Duration(seconds: 3);
    } else {
      difference = now.difference(_lastBackPressTime);
    }

    final isSnackbarVisible = difference < snackbarVisibleDuration;

    /// Only exit while snackbar is visible
    /// Ignore quick succession taps
    if (isSnackbarVisible && difference.inMilliseconds > 200) {
      return true;
    }

    _lastBackPressTime = now;
    // Prevent duplicate snackbar
    if (!isSnackbarVisible) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Press back again to exit'),
            duration: snackbarVisibleDuration,
          ),
        );
    }
    return false;
  }
}

/// Modified version of [CupertinoTabView]
class CustomMaterialTabView extends StatefulWidget {
  /// Creates the content area for a tab in a [MaterialTabScaffold].
  const CustomMaterialTabView({
    Key key,
    this.builder,
    this.navigatorKey,
    this.routes,
    this.onGenerateRoute,
    this.onUnknownRoute,
  }) : super(key: key);

  /// The widget builder for the default route of the tab view
  /// ([Navigator.defaultRouteName], which is `/`).
  ///
  /// If a [builder] is specified, then [routes] must not include an entry for `/`,
  /// as [builder] takes its place.
  ///
  /// Rebuilding a [CustomMaterialTabView] with a different [builder] will not clear
  /// its current navigation stack or update its descendant. Instead, trigger a
  /// rebuild from a descendant in its subtree. This can be done via methods such
  /// as:
  ///
  ///  * Calling [State.setState] on a descendant [StatefulWidget]'s [State]
  ///  * Modifying an [InheritedWidget] that a descendant registered itself
  ///    as a dependent to.
  final WidgetBuilder builder;

  /// A key to use when building this widget's [Navigator].
  ///
  /// If a [navigatorKey] is specified, the [Navigator] can be directly
  /// manipulated without first obtaining it from a [BuildContext] via
  /// [Navigator.of]: from the [navigatorKey], use the [GlobalKey.currentState]
  /// getter.
  ///
  /// If this is changed, a new [Navigator] will be created, losing all the
  /// tab's state in the process; in that case, the [navigatorObservers]
  /// must also be changed, since the previous observers will be attached to the
  /// previous navigator.
  final GlobalKey<NavigatorState> navigatorKey;

  /// This tab view's routing table.
  ///
  /// When a named route is pushed with [Navigator.pushNamed] inside this tab view,
  /// the route name is looked up in this map. If the name is present,
  /// the associated [WidgetBuilder] is used to construct a [MaterialPageRoute]
  /// that performs an appropriate transition to the new route.
  ///
  /// If the tab view only has one page, then you can specify it using [builder] instead.
  ///
  /// If [builder] is specified, then it implies an entry in this table for the
  /// [Navigator.defaultRouteName] route (`/`), and it is an error to
  /// redundantly provide such a route in the [routes] table.
  ///
  /// If a route is requested that is not specified in this table (or by
  /// [builder]), then the [onGenerateRoute] callback is called to build the page
  /// instead.
  ///
  /// This routing table is not shared with any routing tables of ancestor or
  /// descendant [Navigator]s.
  final Map<String, WidgetBuilder> routes;

  /// The route generator callback used when the tab view is navigated to a named route.
  ///
  /// This is used if [routes] does not contain the requested route.
  final RouteFactory onGenerateRoute;

  /// Called when [onGenerateRoute] also fails to generate a route.
  ///
  /// This callback is typically used for error handling. For example, this
  /// callback might always generate a "not found" page that describes the route
  /// that wasn't found.
  ///
  /// The default implementation pushes a route that displays an ugly error
  /// message.
  final RouteFactory onUnknownRoute;

  @override
  _CustomMaterialTabViewState createState() {
    return _CustomMaterialTabViewState();
  }
}

class _CustomMaterialTabViewState extends State<CustomMaterialTabView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final String name = settings.name;
    WidgetBuilder routeBuilder;
    if (name == Navigator.defaultRouteName && widget.builder != null) {
      routeBuilder = widget.builder;
    } else if (widget.routes != null) {
      routeBuilder = widget.routes[name];
    }
    if (routeBuilder != null) {
      return MaterialPageRoute<dynamic>(
        builder: routeBuilder,
        settings: settings,
      );
    }
    if (widget.onGenerateRoute != null) return widget.onGenerateRoute(settings);
    return null;
  }

  Route<dynamic> _onUnknownRoute(RouteSettings settings) {
    assert(() {
      if (widget.onUnknownRoute == null) {
        throw FlutterError(
            'Could not find a generator for route $settings in the $runtimeType.\n'
            'Generators for routes are searched for in the following order:\n'
            ' 1. For the "/" route, the "builder" property, if non-null, is used.\n'
            ' 2. Otherwise, the "routes" table is used, if it has an entry for '
            'the route.\n'
            ' 3. Otherwise, onGenerateRoute is called. It should return a '
            'non-null value for any valid route not handled by "builder" and "routes".\n'
            ' 4. Finally if all else fails onUnknownRoute is called.\n'
            'Unfortunately, onUnknownRoute was not set.');
      }
      return true;
    }());
    final Route<dynamic> result = widget.onUnknownRoute(settings);
    assert(() {
      if (result == null) {
        throw FlutterError('The onUnknownRoute callback returned null.\n'
            'When the $runtimeType requested the route $settings from its '
            'onUnknownRoute callback, the callback returned null. Such callbacks '
            'must never return null.');
      }
      return true;
    }());
    return result;
  }
}
