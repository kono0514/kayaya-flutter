import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/cubit/locale_cubit.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/cubit/updater_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/router.dart';
import 'package:kayaya_flutter/shared/services/shared_preferences_service.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:settings_ui/src/abstract_section.dart';
import 'package:settings_ui/src/cupertino_settings_section.dart';

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
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.message['message'])),
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
                          CustomSettingsSection(
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
                                  Scaffold.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
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
                            ],
                          ),
                          CustomSettingsSection(
                            title: 'Account',
                            tiles: [
                              _buildAuthSettingsTile(),
                              _buildCreateAccountSettingsTile(),
                              _buildLogoutSettingsTile(),
                            ],
                          ),
                          CustomSettingsSection(
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
                          CustomSettingsSection(
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

  Widget _buildAuthSettingsTile() {
    return Builder(
      builder: (context) {
        final state = context.watch<AuthenticationBloc>().state;
        var loggedInAs = 'Unauthenticated';
        if (state is Authenticated) {
          if (state.user.isAnonymous) {
            loggedInAs = 'Anonymous User';
          } else if (state.user.providerData.length > 0) {
            final provider = state.user.providerData[0];
            switch (provider.providerId) {
              case 'facebook.com':
                loggedInAs = 'Facebook (${provider.displayName})';
                break;
              case 'google.com':
                loggedInAs = 'Google (${provider.email})';
                break;
              case 'phone':
                loggedInAs = 'Phone (${provider.phoneNumber})';
                break;
              default:
                loggedInAs = state.user.providerData[0].providerId;
            }
          }
        }

        return SettingsTile(
          leading: Icon(Icons.person),
          title: 'Logged in as',
          subtitle: loggedInAs,
          enabled: false,
        );
      },
    );
  }

  Widget _buildCreateAccountSettingsTile() {
    return Builder(
      builder: (context) {
        final state = context.watch<AuthenticationBloc>().state;

        if (state is Authenticated && state.user.isAnonymous) {
          return SettingsTile(
            leading: Icon(Icons.merge_type),
            title: 'Create/Link Account',
            subtitle: 'Your anonymous account data will persist',
            onTap: () async {
              Navigator.pushNamed(
                context,
                Routes.loginPage,
                arguments: LoginPageArguments(disableAnonymous: true),
              );
            },
          );
        }

        return Container();
      },
    );
  }

  Widget _buildLogoutSettingsTile() {
    return SettingsTile(
      title: 'Logout',
      leading: Icon(Icons.logout),
      onTap: () async {
        final state = context.read<AuthenticationBloc>().state;
        var _confirm = true;

        if (state is Authenticated && state.user.isAnonymous) {
          _confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: SingleChildScrollView(
                child: Text(
                  'You are currently using an anonymous account. '
                  'If you logout now, you will lose all your data. '
                  'Consider account linking instead. ',
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: Text('Logout'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          );
        }

        if (_confirm ?? false) {
          context
              .read<AuthenticationBloc>()
              .add(AuthenticationLogoutRequested());
          Navigator.pop(context);
        }
      },
    );
  }
}

class CustomSettingsSection extends AbstractSection {
  final List<Widget> tiles;
  final TextStyle titleTextStyle;

  CustomSettingsSection({
    Key key,
    String title,
    this.tiles,
    this.titleTextStyle,
  }) : super(key: key, title: title);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Platform.isIOS)
      return iosSection();
    else if (Platform.isAndroid)
      return androidSection(context);
    else
      return androidSection(context);
  }

  Widget iosSection() {
    return CupertinoSettingsSection(
      tiles,
      header: title == null ? null : Text(title, style: titleTextStyle),
    );
  }

  Widget androidSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      title == null
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: titleTextStyle ??
                    TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
      ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tiles.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          return tiles[index];
        },
      ),
      if (showBottomDivider) Divider(height: 1)
    ]);
  }
}
