import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/services/shared_preferences_service.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsDialog extends StatefulWidget {
  final BuildContext mainContext;

  const SettingsDialog({Key key, this.mainContext}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final List items = [];

  String get themeLabel {
    final darkModeEnabled = SharedPreferencesService.instance.isDarkModeEnabled;
    return darkModeEnabled == null
        ? 'System'
        : darkModeEnabled == false ? 'Light' : 'Dark';
  }

  String get languageLabel {
    final languageCode = SharedPreferencesService.instance.languageCode ??
        (Localizations.localeOf(context, nullOk: true)?.languageCode ?? 'en');
    if (languageCode == 'en') {
      return 'English';
    } else if (languageCode == 'mn') {
      return 'Монгол';
    }
    return languageCode;
  }

  String developerUrl = 'https://github.com/kono0514';
  String sourceUrl = 'https://github.com/kono0514'; // TODO: Update repo url

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      expand: true,
      builder: (context, scrollController) => Container(
        margin:
            EdgeInsets.only(top: MediaQuery.of(widget.mainContext).padding.top),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Scaffold(
          body: Builder(
            builder: (context) => Column(
              children: [
                AppBar(
                  title: Text(S.of(context).settings),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SettingsSection(
                  title: S.of(context).general,
                  tiles: [
                    SettingsTile(
                      title: S.of(context).language,
                      subtitle: languageLabel,
                      leading: Icon(Icons.translate),
                      onTap: () async {
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Text(S.of(context).language),
                            children: <Widget>[
                              buildSimpleDialogItem('English', 'en'),
                              buildSimpleDialogItem('Монгол', 'mn'),
                            ],
                          ),
                        );
                        if (result != null) {
                          SharedPreferencesService.instance.setLanguage(result);
                          S.load(Locale(result));
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context).language_updated),
                            ),
                          );
                          setState(() {});
                        }
                      },
                    ),
                    SettingsTile(
                      title: S.of(context).theme,
                      subtitle: themeLabel,
                      leading: Icon(Icons.brightness_medium),
                      onTap: () async {
                        final result = await showDialog<int>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Text(S.of(context).theme),
                            children: <Widget>[
                              buildSimpleDialogItem(
                                  S.of(context).theme_dark, 1),
                              buildSimpleDialogItem(
                                  S.of(context).theme_light, 2),
                              buildSimpleDialogItem(
                                  S.of(context).theme_system, 0),
                            ],
                          ),
                        );

                        if (result == null) return;

                        if (result == 1) {
                          BlocProvider.of<ThemeCubit>(context)
                              .changeTheme(ThemeMode.dark);
                        } else if (result == 2) {
                          BlocProvider.of<ThemeCubit>(context)
                              .changeTheme(ThemeMode.light);
                        } else if (result == 0) {
                          BlocProvider.of<ThemeCubit>(context)
                              .changeTheme(ThemeMode.system);
                        }

                        setState(() {});
                      },
                    ),
                    SettingsTile(
                      title: S.of(context).clear_search_history,
                      leading: Icon(Icons.history),
                      onTap: () {
                        SharedPreferencesService.instance.clearSearchHistory();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                S.of(context).clear_search_history_success),
                          ),
                        );
                      },
                    ),
                    SettingsTile(
                      title: 'Logout',
                      leading: Icon(Icons.history),
                      onTap: () {
                        context.repository<AuthenticationRepository>().logOut();
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: S.of(context).about,
                  tiles: [
                    SettingsTile(
                      title: S.of(context).developer,
                      subtitle: developerUrl,
                      onTap: () async {
                        if (await canLaunch(developerUrl)) {
                          await launch(developerUrl);
                        }
                      },
                    ),
                    SettingsTile(
                      title: S.of(context).source_code,
                      subtitle: sourceUrl,
                      onTap: () async {
                        if (await canLaunch(sourceUrl)) {
                          await launch(sourceUrl);
                        }
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: S.of(context).credits,
                  tiles: [
                    SettingsTile(
                      title: 'Search powered by Algolia',
                      onTap: () async {
                        if (await canLaunch('https://algolia.com')) {
                          await launch('https://algolia.com');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SimpleDialogOption buildSimpleDialogItem(String text, dynamic value) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, value);
      },
      child: Text(text),
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
    );
  }
}
