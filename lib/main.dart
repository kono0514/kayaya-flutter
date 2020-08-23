import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/cubit/genre_list_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:kayaya_flutter/graphql_client.dart';
import 'package:kayaya_flutter/language_service.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/simple_bloc_observer.dart';
import 'package:kayaya_flutter/widgets/navigation_bar/navigation_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  Locale locale;
  final languageService = await LanguageService.instance;
  await Future.delayed(const Duration(seconds: 3));
  String languageCode = languageService.languageCode;
  if (languageCode != null) {
    locale = Locale(languageCode);
  }

  runApp(RepositoryProvider(
    create: (context) => AniimRepository(getGraphQLClient()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GenreListCubit(context.repository<AniimRepository>())
                ..getGenreList(),
        ),
        BlocProvider(
          create: (context) => BrowseFilterCubit(),
        ),
      ],
      child: MyApp(locale: locale),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({Key key, this.locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      home: RootScreen(),
    );
  }
}

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationTab();
  }
}
