import 'package:firebase_auth/firebase_auth.dart';

class LogInAnonymouslyFailure implements Exception {}

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  AuthenticationRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> logInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on Exception {
      throw LogInAnonymouslyFailure();
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
