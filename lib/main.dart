import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/cubit/genre_list_cubit.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/graphql_client.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/shared_preferences_service.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/simple_bloc_observer.dart';
import 'package:kayaya_flutter/theme_data.dart';
import 'package:kayaya_flutter/widgets/navigation_bar/material_tab_scaffold.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  await SharedPreferencesService.init();
  // Get the user's chosen locale from SharedPreferences
  // Fallback to 'en'
  String languageCode = SharedPreferencesService.instance.languageCode ?? 'en';
  Locale locale = Locale(languageCode);

  runApp(RepositoryProvider(
    create: (context) => AniimRepository(
      getGraphQLClient(locale: locale.languageCode),
    ),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GenreListCubit(context.repository<AniimRepository>())
                ..getGenreList(),
        ),
        BlocProvider(create: (context) => BrowseFilterCubit()),
        BlocProvider(create: (context) => ThemeCubit()..resolveTheme()),
      ],
      child: MyApp(locale: locale),
    ),
  ));
}

class MyApp extends StatefulWidget {
  final Locale locale;

  const MyApp({Key key, this.locale}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _createNotificationChannel();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.getToken().then((value) => print(value));
  }

  Future<void> _createNotificationChannel() async {
    var androidNotificationChannel = AndroidNotificationChannel(
      '1', // channel ID
      'Subscriptions', // channel name
      "New episode on a series you've subsribed", //channel description
      importance: Importance.High,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state.themeMode,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: widget.locale,
          supportedLocales: S.delegate.supportedLocales,
          home: RootScreen(),
          onGenerateRoute: Routes.materialRoutes,
        );
      },
    );
  }
}

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return NavigationTabScaffold();
    return MaterialTabScaffold();
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('Received message in background');
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
