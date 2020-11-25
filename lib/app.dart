import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/core/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/core/cubit/genre_list_cubit.dart';
import 'package:kayaya_flutter/core/cubit/locale_cubit.dart';
import 'package:kayaya_flutter/core/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/core/cubit/updater_cubit.dart';
import 'package:kayaya_flutter/core/services/notification_service.dart';
import 'package:kayaya_flutter/core/services/search_service.dart';
import 'package:kayaya_flutter/core/widgets/navigation_bar/material_tab_scaffold.dart';
import 'package:kayaya_flutter/locale/generated/l10n.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/router.dart';
import 'package:kayaya_flutter/theme.dart';
import 'package:kayaya_flutter/utils/graphql_client.dart';

import 'features/login/login.dart';
import 'features/splash/splash.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  AuthenticationRepository authRepo;
  AniimRepository aniimRepo;

  @override
  void initState() {
    super.initState();
    _setupLocators();
    authRepo = AuthenticationRepository();
    aniimRepo = AniimRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: aniimRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(authRepo),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => ThemeCubit()..resolveTheme(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => LocaleCubit()..resolveLocale(),
            lazy: false,
          ),
          BlocProvider(
            create: (_) => GenreListCubit(aniimRepo)..getGenreList(),
            lazy: true,
          ),
          BlocProvider(
            create: (_) {
              final cubit = UpdaterCubit();
              cubit.init().then((value) => cubit.checkForUpdate());
              return cubit;
            },
            lazy: false,
          ),
        ],
        child: Builder(
          builder: (context) {
            /// Rebuilds whenever either of these state changes
            final localeState = context.watch<LocaleCubit>().state;
            final themeState = context.watch<ThemeCubit>().state;

            return MaterialApp(
              title: 'Flutter Demo',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeState.themeMode,
              localizationsDelegates: [
                TR.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale(localeState.locale),
              supportedLocales: TR.delegate.supportedLocales,
              home: AppHome(),
              onGenerateRoute: MyRouter(),
            );
          },
        ),
      ),
    );
  }

  _setupLocators() {
    GetIt.I.registerSingleton<GraphQLClient>(getGraphQLClient());
    GetIt.I.registerLazySingleton<SearchService>(() => AlgoliaSearchService());
    GetIt.I.registerSingleton<NotificationService>(NotificationService());
  }
}

class AppHome extends StatefulWidget {
  AppHome({Key key}) : super(key: key);

  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  void initState() {
    super.initState();
    _configureNotification();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return MaterialTabScaffold();
        }

        if (state is Unauthenticated) {
          return LoginPage();
        }

        return SplashPage();
      },
    );
  }

  _configureNotification() {
    GetIt.I<NotificationService>().configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onSelectNotification: (String payload) async {
        print('onSelectNotification: $payload');
        if (payload == null) return;

        final uri = Uri.parse(payload.trim());
        Navigator.of(context, rootNavigator: true).push(MyRouter.fromURI(uri));
      },
    );
  }
}
