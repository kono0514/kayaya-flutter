import 'package:get_it/get_it.dart';

import '../../core/modules/authentication/domain/usecase/login_with_anonymous.dart';
import '../../core/modules/authentication/domain/usecase/login_with_facebook.dart';
import '../../core/modules/authentication/domain/usecase/login_with_google.dart';
import '../../core/modules/authentication/domain/usecase/send_phone_code.dart';
import '../../core/modules/authentication/domain/usecase/verify_phone_code.dart';
import 'presentation/cubit/login_cubit.dart';
import 'presentation/cubit/login_phone_cubit.dart';

final sl = GetIt.I;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => LoginCubit(
      loginWithAnonymous: sl(),
      loginWithFacebook: sl(),
      loginWithGoogle: sl(),
    ),
  );
  sl.registerFactory(
    () => LoginPhoneCubit(
      sendPhoneCode: sl(),
      verifyPhoneCode: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginWithAnonymous(authRepo: sl()));
  sl.registerLazySingleton(() => LoginWithFacebook(authRepo: sl()));
  sl.registerLazySingleton(() => LoginWithGoogle(authRepo: sl()));
  sl.registerLazySingleton(() => SendPhoneCode(authRepo: sl()));
  sl.registerLazySingleton(() => VerifyPhoneCode(authRepo: sl()));
}
