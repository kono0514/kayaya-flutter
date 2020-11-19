import 'package:flutter/material.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/screens/movie.dart';
import 'package:kayaya_flutter/screens/search.dart';
import 'package:kayaya_flutter/screens/series.dart';
import 'package:kayaya_flutter/screens/tabs/library/library.dart';

abstract class RouteConstants {
  static const seriesDetail = 'series';
  static const movieDetail = 'movie';
  static const movieOrSeriesDetail = 'movieOrSeries';
  static const search = 'search';
  static const library = 'library';

  static List<String> get values =>
      [seriesDetail, movieDetail, movieOrSeriesDetail, search, library];
}

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.seriesDetail:
        final MediaArguments args = settings.arguments;
        return MaterialPageRoute(builder: (_) => SeriesPage(args));
      case RouteConstants.movieDetail:
        final MediaArguments args = settings.arguments;
        return MaterialPageRoute(builder: (_) => MoviePage(args));
      case RouteConstants.movieOrSeriesDetail:
        final MediaArguments args = settings.arguments;
        if (args.anime.animeType == AnimeType.movie) {
          return materialRoutes(
              settings.copyWith(name: RouteConstants.movieDetail));
        }
        return materialRoutes(
            settings.copyWith(name: RouteConstants.seriesDetail));
      case RouteConstants.search:
        return MaterialPageRoute(builder: (context) => SearchPage());
      case RouteConstants.library:
        return MaterialPageRoute(builder: (context) => LibraryPage());
      default:
        return MaterialPageRoute(builder: (context) => LibraryPage());
    }
  }

  @visibleForTesting
  static RouteSettings parseRouteFromUri(Uri uri) {
    if (uri.scheme != 'route') return null;

    final routeName = RouteConstants.values
        .firstWhere((val) => val == uri.host, orElse: () => null);
    if (routeName == null) return null;

    if (routeName == RouteConstants.movieDetail ||
        routeName == RouteConstants.seriesDetail) {
      // At minimum, id is needed
      if (!uri.queryParameters.containsKey('id')) return null;

      var data = Map<String, dynamic>.from({
        'id': uri.queryParameters['id'],
      });
      if (uri.queryParameters['image'] != null) {
        data['coverImage'] = {
          'large': uri.queryParameters['image'],
        };
      }
      if (uri.queryParameters['name'] != null) {
        data['name'] = uri.queryParameters['name'];
      }

      final args = MediaArguments(
        AnimeItemModelGenerator$Query$Anime.fromJson(data),
        isMinimal: true,
      );
      return RouteSettings(name: routeName, arguments: args);
    }

    return RouteSettings(name: routeName);
  }

  static MaterialPageRoute fromURI(Uri uri) {
    return Routes.materialRoutes(parseRouteFromUri(uri));
  }
}

class MediaArguments {
  final AnimeItemFieldsMixin anime;
  final bool isMinimal;

  MediaArguments(this.anime, {this.isMinimal = false});
}
