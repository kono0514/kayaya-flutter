import 'package:flutter/material.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/app.dart';
import 'package:kayaya_flutter/screens/movie.dart';
import 'package:kayaya_flutter/screens/search.dart';
import 'package:kayaya_flutter/screens/series.dart';

class Routes {
  static const homePage = '/';
  static const seriesPage = '/series';
  static const moviePage = '/movie';
  static const movieOrSeries = '/movieOrSeries';
  static const searchPage = '/search';
  static const libraryPage = '/library';

  static List<String> get values =>
      [homePage, seriesPage, moviePage, movieOrSeries, searchPage, libraryPage];
}

typedef RouteResolver = Route<dynamic> Function(RouteSettings settings);

class MyRouter {
  Route<dynamic> call(RouteSettings settings) => onGenerateRoute(settings);

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routePage = _pagesMap[settings.name];
    return routePage.call(settings);
  }

  final _pagesMap = <String, RouteResolver>{
    Routes.homePage: (_) {
      return MaterialPageRoute(
        builder: (context) => AppHome(),
      );
    },
    Routes.seriesPage: (settings) {
      final args = settings.arguments as MediaArguments;
      return MaterialPageRoute(
        builder: (_) => SeriesPage(
          args.anime,
          isMinimal: args.isMinimal,
        ),
      );
    },
    Routes.moviePage: (settings) {
      final args = settings.arguments as MediaArguments;
      return MaterialPageRoute(
        builder: (_) => MoviePage(
          args.anime,
          isMinimal: args.isMinimal,
        ),
      );
    },
    Routes.movieOrSeries: (settings) {
      final args = settings.arguments as MediaArguments;
      if (args.anime.animeType == AnimeType.movie) {
        return MyRouter().onGenerateRoute(
          settings.copyWith(name: Routes.moviePage),
        );
      }
      return MyRouter().onGenerateRoute(
        settings.copyWith(name: Routes.seriesPage),
      );
    },
    Routes.searchPage: (_) {
      return MaterialPageRoute(
        builder: (context) => SearchPage(),
      );
    }
  };

  @visibleForTesting
  static RouteSettings parseRouteFromURI(Uri uri) {
    if (uri.scheme != 'route') return null;

    final _host = '/${uri.host}';
    final routeName =
        Routes.values.firstWhere((val) => val == _host, orElse: () => null);
    if (routeName == null) return null;

    if (routeName == Routes.moviePage || routeName == Routes.seriesPage) {
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

  static Route<dynamic> fromURI(Uri uri) {
    return MyRouter().onGenerateRoute(parseRouteFromURI(uri));
  }
}

class MediaArguments {
  final AnimeItemFieldsMixin anime;
  final bool isMinimal;

  MediaArguments(this.anime, {this.isMinimal = false});
}
