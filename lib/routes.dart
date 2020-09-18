import 'package:flutter/material.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/screens/movie.dart';
import 'package:kayaya_flutter/screens/search.dart';
import 'package:kayaya_flutter/screens/series.dart';
import 'package:kayaya_flutter/screens/settings.dart';
import 'package:kayaya_flutter/screens/tabs/library.dart';

abstract class RouteConstants {
  static const seriesDetail = 'series';
  static const movieDetail = 'movie';
  static const movieOrSeriesDetail = 'movieOrSeries';
  static const search = 'search';
  static const settings = 'settings';
  static const library = 'library';

  static List<String> get values => [
        seriesDetail,
        movieDetail,
        movieOrSeriesDetail,
        search,
        settings,
        library
      ];
}

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    if (settings.name == RouteConstants.seriesDetail) {
      final MediaArguments args = settings.arguments;
      return MaterialPageRoute(builder: (_) => SeriesPage(args));
    } else if (settings.name == RouteConstants.movieDetail) {
      final MediaArguments args = settings.arguments;
      return MaterialPageRoute(builder: (_) => MoviePage(args));
    } else if (settings.name == RouteConstants.movieOrSeriesDetail) {
      final MediaArguments args = settings.arguments;
      if (args.anime.animeType == AnimeType.movie) {
        return materialRoutes(
            settings.copyWith(name: RouteConstants.movieDetail));
      } else if (args.anime.animeType == AnimeType.series) {
        return materialRoutes(
            settings.copyWith(name: RouteConstants.seriesDetail));
      }
    } else if (settings.name == RouteConstants.search) {
      return MaterialPageRoute(builder: (context) => SearchPage());
    } else if (settings.name == RouteConstants.settings) {
      return MaterialPageRoute(builder: (context) => SettingsPage());
    } else if (settings.name == RouteConstants.library) {
      return MaterialPageRoute(builder: (context) => LibraryPage());
    }

    return MaterialPageRoute(builder: (context) => SettingsPage());
  }

  static MaterialPageRoute fromURI(Uri uri) {
    if (uri.scheme != 'route') return null;

    final routeName = RouteConstants.values
        .firstWhere((val) => val == uri.host, orElse: null);
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
        BrowseAnimes$Query$Animes$Data.fromJson(data),
        isMinimal: true,
      );
      return Routes.materialRoutes(
        RouteSettings(name: routeName, arguments: args),
      );
    }

    return Routes.materialRoutes(RouteSettings(name: routeName));
  }
}

class MediaArguments {
  final ListItemAnimeMixin anime;
  final bool isMinimal;

  MediaArguments(this.anime, {this.isMinimal = false});
}
