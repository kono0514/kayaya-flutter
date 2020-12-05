import 'package:flutter/material.dart';
import 'package:kayaya_flutter/layers/domain/entities/anime.dart';

import 'app.dart';
import 'layers/presentation/detail/view/movie.dart';
import 'layers/presentation/detail/view/series.dart';
import 'layers/presentation/login/view/login_page.dart';
import 'layers/presentation/search/view/search_page.dart';

class Routes {
  static const homePage = '/';
  static const seriesPage = '/series';
  static const moviePage = '/movie';
  static const movieOrSeries = '/movieOrSeries';
  static const searchPage = '/search';
  static const libraryPage = '/library';
  static const loginPage = '/login';

  static List<String> get values => [
        homePage,
        seriesPage,
        moviePage,
        movieOrSeries,
        searchPage,
        libraryPage,
        loginPage
      ];
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
      if (args.anime.isMovie) {
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
    },
    Routes.loginPage: (settings) {
      var args = settings.arguments as LoginPageArguments;
      args ??= LoginPageArguments();
      return MaterialPageRoute(
        builder: (context) => LoginPage(
          disableAnonymous: args.disableAnonymous,
        ),
      );
    },
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

      var anime = Anime(
        id: uri.queryParameters['id'],
      );
      if (uri.queryParameters['image'] != null) {
        anime = anime.copyWith(
          coverImage: uri.queryParameters['image'],
        );
      }
      if (uri.queryParameters['name'] != null) {
        anime = anime.copyWith(
          name: uri.queryParameters['name'],
        );
      }

      final args = MediaArguments(
        anime,
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
  final Anime anime;
  final bool isMinimal;

  MediaArguments(this.anime, {this.isMinimal = false});
}

class LoginPageArguments {
  final bool disableAnonymous;

  LoginPageArguments({this.disableAnonymous = false});
}
