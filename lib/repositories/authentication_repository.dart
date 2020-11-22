import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleAuth;
  final FacebookAuth _facebookAuth;

  AuthenticationRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleAuth = GoogleSignIn(),
        _facebookAuth = FacebookAuth.instance;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future<UserCredentialWrapper> signInAnonymously() async {
    return UserCredentialWrapper(
      await _firebaseAuth.signInAnonymously(),
      false,
    );
  }

  Future<UserCredentialWrapper> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _googleAuth.signIn();

    // Aborted
    if (googleUser == null) {
      throw AuthException('Aborted');
    }

    // Obtain the auth details from the request
    GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = await googleUser.authentication;
    } catch (e) {
      throw AuthException('GoogleAuth failed');
    }

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _linkWithAnonymous(credential);
  }

  Future<UserCredentialWrapper> signInWithFacebook() async {
    // Trigger the sign-in flow
    AccessToken accessToken;
    try {
      accessToken = await FacebookAuth.instance.login();
    } on FacebookAuthException catch (e) {
      if (e.errorCode == FacebookAuthErrorCode.CANCELLED) {
        throw AuthException('Aborted');
      }
      throw AuthException('FacebookAuth failed');
    }

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.token);

    return await _linkWithAnonymous(facebookAuthCredential);
  }

  Future<void> signInWithPhoneNumberSend({
    @required String phoneNumber,
    @required Function verificationCompleted,
    @required Function(AuthException) verificationFailed,
    @required Function(String verificationId) codeSent,
    @required Function(String verificationId) codeAutoRetrievalTimeout,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _linkWithAnonymous(credential);
          verificationCompleted.call();
        } catch (e) {
          verificationFailed.call(e);
        }
      },
      verificationFailed: (e) => verificationFailed(
        AuthException(e.shortMessage),
      ),
      codeSent: (verificationId, forceResendingToken) =>
          codeSent.call(verificationId),
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredentialWrapper> signInWithPhoneNumberVerify({
    @required String verificationId,
    @required String code,
  }) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    // Once signed in, link with currently logged in anonymous account (if any)
    // and return the linked UserCredential
    return await _linkWithAnonymous(phoneAuthCredential);
  }

  /// If a user is currently signed in with anonymous account,
  /// link it with the [credential] using [linkWithCredential]
  ///
  /// Otherwise, log the user in normally with [signInWithCredential]
  Future<UserCredentialWrapper> _linkWithAnonymous(
      AuthCredential credential) async {
    if (_firebaseAuth.currentUser != null &&
        _firebaseAuth.currentUser.isAnonymous) {
      try {
        final linked =
            await _firebaseAuth.currentUser.linkWithCredential(credential);
        return UserCredentialWrapper(linked, true);
      } on FirebaseAuthException catch (e) {
        throw AuthException(e.shortMessage);
      }
    }

    try {
      final result = await _firebaseAuth.signInWithCredential(credential);
      return UserCredentialWrapper(result, false);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.shortMessage);
    }
  }

  Future<void> logOut() async {
    bool _googleSignedIn = await _googleAuth.isSignedIn();
    if (_googleSignedIn) {
      await _googleAuth.signOut();
    }

    bool _facebookSignedIn = (await _facebookAuth.isLogged) != null;
    if (_facebookSignedIn) {
      await _facebookAuth.logOut();
    }

    await _firebaseAuth.signOut();
  }
}

class UserCredentialWrapper {
  final UserCredential userCredential;
  final bool wasLinkedWithAnonymous;

  UserCredentialWrapper(this.userCredential, this.wasLinkedWithAnonymous);
}

extension ShortErrorMessage on FirebaseAuthException {
  String get shortMessage {
    if (this.code == 'credential-already-in-use') {
      return 'Account already exists. Please logout first and try logging in again.';
    }
    return toBeginningOfSentenceCase(
      this.code.replaceAll('-', ' '),
    );
  }
}
