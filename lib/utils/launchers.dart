import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/features/player/player.dart';
import 'package:kayaya_flutter/locale/generated/l10n.dart';

void launchPlayRelease(
  BuildContext context,
  AnimeItemFieldsMixin anime,
  GetAnimeEpisodes$Query$Episodes$Data episode,
  GetAnimeEpisodes$Query$Episodes$Data$Releases release,
) {
  if (release.type == 'direct') {
    String subtitle = '';
    subtitle += '${release.group}';
    if (release.resolution != null) {
      subtitle += ' / ${release.resolution}';
    }
    if (anime.animeType == AnimeType.series) {
      final _epLabel = TR.of(context).episode_item(episode.number);
      subtitle = '$_epLabel ($subtitle)';
    }

    Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => FullscreenPlayer(
        mediaInfo: MediaInfo(
          title: anime.name,
          subtitle: subtitle,
          url: release.url,
        ),
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
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Failed to open a browser')));
      debugPrint(e.toString());
    }
  }
}
