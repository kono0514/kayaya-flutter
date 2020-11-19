import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/cubit/locale_cubit.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/cubit/updater_cubit.dart';
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
  final sps = GetIt.I<SharedPreferencesService>();

  String get themeLabel {
    final darkModeEnabled = sps.isDarkModeEnabled;
    return darkModeEnabled == null
        ? 'System'
        : darkModeEnabled == false
            ? 'Light'
            : 'Dark';
  }

  String get currentLanguageCode {
    return sps.languageCode ??
        (Localizations.localeOf(context, nullOk: true)?.languageCode ?? 'en');
  }

  String get languageLabel {
    final languageCode = currentLanguageCode;
    if (languageCode == 'en') {
      return 'English';
    } else if (languageCode == 'mn') {
      return 'Монгол';
    }
    return languageCode;
  }

  String sourceUrl = 'https://github.com/kono0514'; // TODO: Update repo url

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UpdaterCubit>(context).resetErrors();
  }

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
            builder: (context) => BlocListener<UpdaterCubit, UpdaterState>(
              listener: (context, state) {
                if (state is UpdaterError) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message['message']),
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  AppBar(
                    primary: false,
                    title: Text(S.of(context).settings),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                                    BlocProvider.of<LocaleCubit>(context)
                                        .changeLocale(result);
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
                                  sps.clearSearchHistory();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(S
                                          .of(context)
                                          .clear_search_history_success),
                                    ),
                                  );
                                },
                              ),
                              SettingsTile(
                                title: 'Check for Update',
                                leading: Icon(Icons.cloud_download),
                                onTap: () {
                                  BlocProvider.of<UpdaterCubit>(context)
                                      .checkForUpdate();
                                },
                              ),
                              SettingsTile(
                                title: 'Logout',
                                leading: Icon(Icons.history),
                                onTap: () {
                                  context
                                      .read<AuthenticationRepository>()
                                      .logOut();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          SettingsSection(
                            title: S.of(context).about,
                            tiles: [
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
                ],
              ),
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
