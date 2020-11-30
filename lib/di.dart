import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kayaya_flutter/core/modules/authentication/di.dart'
    as auth_module;
import 'package:kayaya_flutter/core/modules/authentication/domain/usecase/get_id_token.dart';
import 'package:kayaya_flutter/core/modules/authentication/domain/usecase/is_logged_in.dart';
import 'package:kayaya_flutter/core/services/notification_service.dart';
import 'package:kayaya_flutter/core/services/preferences_service.dart';
import 'package:kayaya_flutter/features/login/di.dart' as login_module;
import 'package:kayaya_flutter/features/search/di.dart' as search_module;
import 'package:kayaya_flutter/utils/graphql_client.dart';

final sl = GetIt.I;

Future<void> init() async {
  // Modules
  await auth_module.init();
  await login_module.init();
  await search_module.init();
  sl.registerLazySingleton(() => GetIdToken(authRepo: sl()));
  sl.registerLazySingleton(() => IsLoggedIn(authRepo: sl()));

  // External
  await Hive.initFlutter();
  final box = await Hive.openBox('kayaya_box');
  sl.registerSingleton<Box>(box);
  sl.registerLazySingleton<PreferencesService>(
    () => PreferencesService(dataSource: sl()),
  );
  sl.registerLazySingleton<PreferencesDatasource>(
    () => HivePreferencesDatasource(hiveBox: sl()),
  );
  sl.registerLazySingleton<GraphQLClient>(
    () => getGraphQLClient(
      getLocale: () => sl<PreferencesService>().languageCode,
      getIdToken: sl(),
    ),
  );
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  await sl.allReady();
}
