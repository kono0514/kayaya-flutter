import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  await Firebase.initializeApp();
  await SharedPreferencesService.init();
  await initializeAuth();

  Bloc.observer = SimpleBlocObserver();

  // Get the user's chosen locale from SharedPreferences
  // Fallback to 'en'
  String languageCode = SharedPreferencesService.instance.languageCode ?? 'en';
  Locale locale = Locale(languageCode);

  runApp(MyApp(locale: locale));
}

Future<void> initializeAuth() async {
  print('Initialize auth:');
  print(FirebaseAuth.instance.currentUser);
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({Key key, this.locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
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
        child: BlocBuilder<ThemeCubit, ThemeState>(
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
              locale: locale,
              supportedLocales: S.delegate.supportedLocales,
              home: RootScreen(),
              onGenerateRoute: Routes.materialRoutes,
            );
          },
        ),
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool showLandingPage = false;

  @override
  void initState() {
    super.initState();

    _createNotificationChannel();
    _configureFirebaseMessaging();

    final currentUser = FirebaseAuth.instance.currentUser;

    // User is either signed in or signed in anonymously
    // using "initializeAuth" method
    assert(currentUser != null);

    // Signed in anonymously
    if (currentUser.isAnonymous) {
      // TODO: Determine if we should show the landing page
      showLandingPage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showLandingPage)
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    return MaterialTabScaffold();
  }

  Future<void> _createNotificationChannel() async {
    var androidNotificationChannel = AndroidNotificationChannel(
      '1',
      'Subscriptions',
      "New episode on a series you've subsribed",
      importance: Importance.High,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  void _configureFirebaseMessaging() {
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
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('Uploading firebase messaging token: $newToken');
      final oldToken = SharedPreferencesService.instance.currentSavedFcmToken;
      if (oldToken != newToken) {
        SharedPreferencesService.instance.saveCurrentFcmToken(newToken);
      }
      RepositoryProvider.of<AniimRepository>(context)
          .uploadFcmToken(newToken, oldToken: oldToken);
    });
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
