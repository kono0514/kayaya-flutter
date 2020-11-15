import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/cubit/locale_cubit.dart';
import 'package:kayaya_flutter/cubit/theme_cubit.dart';
import 'package:kayaya_flutter/cubit/updater_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/services/search_service.dart';
import 'package:kayaya_flutter/utils/graphql_client.dart';
import 'package:kayaya_flutter/services/notification_service.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/theme_data.dart';
import 'package:kayaya_flutter/widgets/navigation_bar/material_tab_scaffold.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  NotificationService _notificationService = NotificationService();
  AuthenticationRepository authRepo = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    _configureNotification();
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
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale(localeState.locale),
              supportedLocales: S.delegate.supportedLocales,
              home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is Unauthenticated) {
                    authRepo.logInAnonymously();
                  }
                },
                builder: (context, state) {
                  if (state is Authenticated) {
                    return MaterialTabScaffold();
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
              onGenerateRoute: Routes.materialRoutes,
            );
          },
        ),
      ),
    );
  }

  _configureNotification() {
    _notificationService.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onSelectNotification: (String payload) async {
        print('onSelectNotification: $payload');
        if (payload == null) return;

        final uri = Uri.parse(payload.trim());
        Navigator.of(context, rootNavigator: true).push(Routes.fromURI(uri));
      },
    );
  }

  _setupLocators() {
    GetIt.I.registerSingleton<GraphQLClient>(getGraphQLClient());
    GetIt.I.registerSingleton<SearchService>(AlgoliaSearchService());
  }
}
