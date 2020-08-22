import 'package:flutter/material.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/language_service.dart';

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
      appBar: AppBar(
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
                  (await LanguageService.instance).setLanguage('en');
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Language updated. Restart the app to see the changes.')));
                },
                child: Text('EN'),
              ),
              RaisedButton(
                onPressed: () async {
                  (await LanguageService.instance).setLanguage('mn');
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Language updated. Restart the app to see the changes.')));
                },
                child: Text('MN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
