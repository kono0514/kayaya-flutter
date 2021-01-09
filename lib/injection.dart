import 'package:algolia/algolia.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'core/services/notification_service.dart';
import 'core/services/preferences_service.dart';
import 'core/utils/graphql_client.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  await Firebase.initializeApp();

  await Hive.initFlutter();

  await $initGetIt(getIt);
}

@module
abstract class RegisterModule {
  @Named('animeBox')
  @preResolve
  Future<Box> get animeBox => Hive.openBox('anime_box');

  @Named('preferencesBox')
  @preResolve
  Future<Box> get preferencesBox => Hive.openBox('preferences_box');

  @lazySingleton
  GraphQLClient get gqlClient => getGraphQLClient(
        getLocale: () => getIt<PreferencesService>().languageCode,
        getIdTokenUsecase: getIt(),
      );

  @lazySingleton
  NotificationService get notificationService => NotificationService();

  @lazySingleton
  Algolia get algolia => const Algolia.init(
        applicationId: 'IBF8ZIWBKS',
        apiKey: 'a248f7500d9424891a3892b7eadd25a7', // Search-only API key
      );

  @injectable
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @injectable
  GoogleSignIn get googleAuth => GoogleSignIn();

  @injectable
  FacebookAuth get facebookAuth => FacebookAuth.instance;
}
