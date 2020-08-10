import 'package:flutter/material.dart';
import 'package:kayaya_flutter/screens/movie.dart';
import 'package:kayaya_flutter/screens/search.dart';
import 'package:kayaya_flutter/screens/series.dart';
import 'package:kayaya_flutter/screens/settings.dart';

abstract class RouteConstants {
  static const String seriesDetail = '/series';
  static const String movieDetail = '/movie';
  static const String search = '/search';
  static const String settings = '/settings';
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
        return MaterialPageRoute(
            builder: (context) => SearchPage(settings.arguments));
      case RouteConstants.settings:
        return MaterialPageRoute(builder: (context) => SettingsPage());
      default:
        return MaterialPageRoute(builder: (context) => SettingsPage());
    }
  }
}
