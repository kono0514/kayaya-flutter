import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/shared/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/shared/cubit/locale_cubit.dart';
import 'package:kayaya_flutter/shared/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/shared/cubit/updater_cubit.dart';
import 'package:kayaya_flutter/locale/generated/l10n.dart';
import 'package:kayaya_flutter/login/login.dart';
import 'package:kayaya_flutter/shared/services/search_service.dart';
import 'package:kayaya_flutter/splash/splash.dart';
import 'package:kayaya_flutter/utils/graphql_client.dart';
import 'package:kayaya_flutter/shared/services/notification_service.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/router.dart';
import 'package:kayaya_flutter/theme.dart';
import 'package:kayaya_flutter/shared/widgets/navigation_bar/material_tab_scaffold.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  AuthenticationRepository authRepo = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    _setupLocators();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider(create: (_) => AniimRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  AuthenticationBloc(authenticationRepository: authRepo)),
          BlocProvider(create: (_) => ThemeCubit()..resolveTheme()),
          BlocProvider(create: (_) => LocaleCubit()..resolveLocale()),
          BlocProvider(
            lazy: false,
            create: (_) {
              final cubit = UpdaterCubit();
              cubit.init().then((value) => cubit.checkForUpdate());
              return cubit;
            },
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
