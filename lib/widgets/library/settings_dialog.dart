import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/shared_preferences_service.dart';
import 'package:settings_ui/settings_ui.dart';

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
                  title: Text('Settings'),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SettingsSection(
                  title: 'General',
                  tiles: [
                    SettingsTile(
                      title: 'Language',
                      subtitle: languageLabel,
                      leading: Icon(Icons.translate),
                      onTap: () async {
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Text('Language'),
                            children: <Widget>[
                              buildSimpleDialogItem('English', 'en'),
                              buildSimpleDialogItem('Монгол', 'mn'),
                            ],
                          ),
                        );
                        if (result != null) {
                          SharedPreferencesService.instance.setLanguage(result);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Language updated. Restart the app to see the changes.'),
                            ),
                          );
                          setState(() {});
                        }
                      },
                    ),
                    SettingsTile(
                      title: 'Theme',
                      subtitle: themeLabel,
                      leading: Icon(Icons.brightness_medium),
                      onTap: () async {
                        final result = await showDialog<int>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Text('Theme'),
                            children: <Widget>[
                              buildSimpleDialogItem('Dark', 1),
                              buildSimpleDialogItem('Light', 2),
                              buildSimpleDialogItem('System', 0),
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
