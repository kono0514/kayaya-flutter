import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/shared_preferences_service.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_app_bar.dart';

class LibraryPage extends StatefulWidget {
  final ScrollController scrollController;

  const LibraryPage({Key key, this.scrollController}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomStaticAppBar(
        title: Text(S.current.tabs_library),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('This is library page'),
              RaisedButton(
                onPressed: () async {
                  (await SharedPreferencesService.instance).setLanguage('en');
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Language updated. Restart the app to see the changes.')));
                },
                child: Text('EN'),
              ),
              RaisedButton(
                onPressed: () async {
                  (await SharedPreferencesService.instance).setLanguage('mn');
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Language updated. Restart the app to see the changes.')));
                },
                child: Text('MN'),
              ),
              Divider(),
              RaisedButton(
                onPressed: () {
                  BlocProvider.of<ThemeCubit>(context)
                      .changeTheme(ThemeMode.light);
                },
                child: Text('Light'),
              ),
              RaisedButton(
                onPressed: () async {
                  BlocProvider.of<ThemeCubit>(context)
                      .changeTheme(ThemeMode.dark);
                },
                child: Text('Dark'),
              ),
              RaisedButton(
                onPressed: () async {
                  BlocProvider.of<ThemeCubit>(context)
                      .changeTheme(ThemeMode.system);
                },
                child: Text('System'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
