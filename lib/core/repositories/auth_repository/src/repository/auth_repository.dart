import 'package:meta/meta.dart';

import '../entity/user.dart';

abstract class AuthRepository {
  Future<void> signInWithPassword({
    @required String username,
    @required String password,
  });
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> signInAnonymously();
  Future<void> signInWithPhoneNumberSend({
    @required String number,
    @required Function(String) callback,
  });
  Future<void> signInWithPhoneNumberVerify({
    String verificationId,
    @required String code,
  });
  Future<void> signOut();
  Stream<User> get user;
  Future<String> getIdToken();
}
