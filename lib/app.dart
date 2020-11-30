import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'core/cubit/genre_list_cubit.dart';
import 'core/cubit/locale_cubit.dart';
import 'core/cubit/theme_cubit.dart';
import 'core/cubit/updater_cubit.dart';
import 'core/modules/authentication/presentation/bloc/authentication_bloc.dart';
import 'core/services/notification_service.dart';
import 'core/widgets/navigation_bar/material_tab_scaffold.dart';
import 'features/login/presentation/view/login_page.dart';
import 'features/splash/splash.dart';
import 'locale/generated/l10n.dart';
import 'repositories/aniim_repository.dart';
import 'router.dart';
import 'theme.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  AniimRepository aniimRepo;

  @override
  void initState() {
    super.initState();
    aniimRepo = AniimRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: aniimRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => GetIt.I<AuthenticationBloc>(),
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
            create: (context) {
              final cubit = UpdaterCubit();
              cubit.init().then((value) => cubit.checkForUpdate());
              return cubit;
            },
            lazy: false,
          ),
          BlocProvider(
            create: (_) => GenreListCubit(aniimRepo)..getGenreList(),
            lazy: true,
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
