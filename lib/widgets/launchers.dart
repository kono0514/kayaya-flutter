import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/widgets/player/fullscreen_player.dart';

void launchPlayRelease(BuildContext context,
    GetAnimeEpisodes$Query$Episodes$Data$Releases release) {
  if (release.type == 'direct') {
    Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => FullscreenPlayer(
        url: release.url,
      ),
      transitionDuration: Duration(seconds: 0),
    ));
  } else {
    try {
      launch(
        release.url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: false,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Failed to open browser'),
      ));
      debugPrint(e.toString());
    }
  }
}

void launchMediaPage(BuildContext context, MediaArguments mediaArguments) {
  final route = mediaArguments.anime.animeType == AnimeType.movie
      ? RouteConstants.movieDetail
      : RouteConstants.seriesDetail;

  Navigator.of(
    context,
    rootNavigator: true,
  ).pushNamed(route, arguments: mediaArguments);
}
