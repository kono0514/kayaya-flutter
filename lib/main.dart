import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/cubit/animes_cubit.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/cubit/genre_list_cubit.dart';
import 'package:kayaya_flutter/graphql_client.dart';
import 'package:kayaya_flutter/repository.dart';
import 'package:kayaya_flutter/simple_bloc_observer.dart';
import 'package:kayaya_flutter/widgets/navigation_bar/navigation_tab.dart';
import 'client_provider.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
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
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
