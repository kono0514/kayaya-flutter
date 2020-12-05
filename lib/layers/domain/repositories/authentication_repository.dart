import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithPassword({
    @required String username,
    @required String password,
  });
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithFacebook();
  Future<Either<Failure, User>> signInAnonymously();
  Future<Either<Failure, Either<User, String>>> signInWithPhoneNumberSend({
    @required String number,
  });
  Future<Either<Failure, User>> signInWithPhoneNumberVerify({
    @required String verificationId,
    @required String code,
  });
  Future<Either<Failure, Unit>> signOut();
  Stream<User> get user;
  Future<Either<Failure, String>> getIdToken();
  Future<Either<Failure, bool>> isLoggedIn();
}
