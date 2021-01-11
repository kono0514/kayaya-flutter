import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'core/services/notification_service.dart';
import 'core/widgets/navigation_bar/material_tab_scaffold.dart';
import 'env_config.dart';
import 'layers/presentation/authentication/bloc/authentication_bloc.dart';
import 'layers/presentation/genre/cubit/genre_list_cubit.dart';
import 'layers/presentation/library/cubit/subscription_list_cubit.dart';
import 'layers/presentation/locale/cubit/locale_cubit.dart';
import 'layers/presentation/login/view/login_page.dart';
import 'layers/presentation/splash/view/splash_page.dart';
import 'layers/presentation/theme/cubit/theme_cubit.dart';
import 'layers/presentation/updater/cubit/updater_cubit.dart';
import 'locale/generated/l10n.dart';
import 'router.dart';
import 'theme.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<AuthenticationBloc>(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => GetIt.I<ThemeCubit>()..resolveTheme(),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => GetIt.I<LocaleCubit>()..resolveLocale(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) {
            final cubit = GetIt.I<UpdaterCubit>();
            cubit.init().then((value) => cubit.checkForUpdate());
            return cubit;
          },
          lazy: false,
        ),
        BlocProvider(
          create: (_) => GetIt.I<GenreListCubit>()..getGenreList(),
          lazy: true,
        ),
        BlocProvider(
          create: (_) => GetIt.I<SubscriptionListCubit>(),
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
            localizationsDelegates: const [
              TR.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: EnvironmentConfig.isWarmupMode
                ? const Locale('en')
                : Locale(localeState.locale),
            supportedLocales: TR.delegate.supportedLocales,
            home: const AppHome(),
            onGenerateRoute: MyRouter(),
            // checkerboardRasterCacheImages: true,
            // checkerboardOffscreenLayers: true,
            // showPerformanceOverlay: true,
          );
        },
      ),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({Key key}) : super(key: key);

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
          return const LoginPage();
        }

        return const SplashPage();
      },
    );
  }

  void _configureNotification() {
    GetIt.I<NotificationService>().configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("onMessage: $message");
        // _showItemDialog(message);
      },
      onSelectNotification: (String payload) async {
        debugPrint('onSelectNotification: $payload');
        if (payload == null) return;

        final uri = Uri.parse(payload.trim());
        Navigator.of(context, rootNavigator: true).push(MyRouter.fromURI(uri));
      },
    );
  }
}
