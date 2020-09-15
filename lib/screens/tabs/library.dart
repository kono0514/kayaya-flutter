import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/shared_preferences_service.dart';
import 'package:kayaya_flutter/widgets/app_bar/custom_app_bar.dart';
import 'package:kayaya_flutter/widgets/app_bar/sliver_button.dart';
import 'package:kayaya_flutter/widgets/library/settings_dialog.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
        actions: [
          SliverButton(
            text: Text(
              'SETTINGS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              BuildContext mainContext = context;
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SettingsDialog(mainContext: mainContext),
              );
            },
            collapsible: false,
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<User>(
                stream: _auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return Text('Not signed in');
                    } else {
                      snapshot.data.getIdToken().then((value) => print(value));
                      return Text(snapshot.data.uid);
                    }
                  }

                  return Text('Not signed in. No event');
                },
              ),
              RaisedButton(
                onPressed: () {
                  _auth.signInAnonymously().then((value) => print(value));
                },
                child: Text('Sign in anonymously'),
              ),
              RaisedButton(
                onPressed: () {
                  _auth.signOut();
                },
                child: Text('Signout'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
