import 'package:algolia/algolia.dart';
import 'package:get_it/get_it.dart';

import 'data/datasource/local_search_datasource.dart';
import 'data/datasource/network_search_datasource.dart';
import 'data/repository/search_repository_impl.dart';
import 'datasource/local/local_search_datasource_impl.dart';
import 'datasource/network/algolia_search_datasource_impl.dart';
import 'domain/repository/search_repository.dart';
import 'domain/usecase/clear_search_history.dart';
import 'domain/usecase/get_search_history.dart';
import 'domain/usecase/save_search_history.dart';
import 'domain/usecase/search_by_text.dart';
import 'presentation/bloc/search_bloc.dart';

final sl = GetIt.I;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => SearchBloc(
      getSearchHistory: sl(),
      searchByText: sl(),
      saveSearchHistory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSearchHistory(searchRepo: sl()));
  sl.registerLazySingleton(() => SearchByText(searchRepo: sl()));
  sl.registerLazySingleton(() => SaveSearchHistory(searchRepo: sl()));
  sl.registerLazySingleton(() => ClearSearchHistory(searchRepo: sl()));

  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      localDatasource: sl(),
      networkDatasource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LocalSearchDatasource>(
    () => LocalSearchDatasourceImpl(pref: sl()),
  );
  sl.registerLazySingleton<NetworkSearchDatasource>(
    () => AlgoliaNetworkSearchDatasourceImpl(pref: sl(), algolia: sl()),
  );

  // External
  sl.registerLazySingleton(
    () => Algolia.init(
      applicationId: 'IBF8ZIWBKS',
      apiKey: 'a248f7500d9424891a3892b7eadd25a7',
    ),
  );
}
