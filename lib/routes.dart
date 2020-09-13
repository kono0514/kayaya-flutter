import 'package:flutter/material.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/screens/movie.dart';
import 'package:kayaya_flutter/screens/search.dart';
import 'package:kayaya_flutter/screens/series.dart';
import 'package:kayaya_flutter/screens/settings.dart';
import 'package:kayaya_flutter/screens/tabs/library.dart';

abstract class RouteConstants {
  static const String seriesDetail = '/series';
  static const String movieDetail = '/movie';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String library = '/library';
}

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.seriesDetail:
        return MaterialPageRoute(
            builder: (_) => SeriesPage(settings.arguments));
      case RouteConstants.movieDetail:
        return MaterialPageRoute(
            builder: (context) => MoviePage(settings.arguments));
      case RouteConstants.search:
        return MaterialPageRoute(builder: (context) => SearchPage());
      case RouteConstants.settings:
        return MaterialPageRoute(builder: (context) => SettingsPage());
      case RouteConstants.library:
        return MaterialPageRoute(builder: (context) => LibraryPage());
      default:
        return MaterialPageRoute(builder: (context) => LibraryPage());
    }
  }
}

class MediaArguments {
  final ListItemAnimeMixin anime;
  final bool isMinimal;

  MediaArguments(this.anime, {this.isMinimal = false});
}
