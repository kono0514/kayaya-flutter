import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'data/repository/auth_repository_impl.dart';
import 'domain/repository/auth_repository.dart';
import 'domain/usecase/get_user_stream.dart';
import 'domain/usecase/logout.dart';
import 'presentation/bloc/authentication_bloc.dart';

final sl = GetIt.I;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => AuthenticationBloc(
      getUserStream: sl(),
      logout: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserStream(authRepo: sl()));
  sl.registerLazySingleton(() => Logout(authRepo: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepositoryImpl(
      firebaseAuth: FirebaseAuth.instance,
      facebookAuth: FacebookAuth.instance,
      googleAuth: GoogleSignIn(),
    ),
  );
}
