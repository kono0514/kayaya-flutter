import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../entity/error.dart';
import '../entity/user.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleAuth;
  final FacebookAuth facebookAuth;
  StreamController<User> userStream = StreamController.broadcast();

  FirebaseAuthRepository({
    @required this.firebaseAuth,
    @required this.googleAuth,
    @required this.facebookAuth,
  }) {
    userStream.onCancel = () {
      userStream.close();
    };
    firebaseAuth.authStateChanges().listen((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      userStream.add(user);
    });
  }

  @override
  Future<void> signInAnonymously() async {
    try {
      await firebaseAuth.signInAnonymously();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInAnonymouslyFailure(e.shortMessage);
    }
  }

  @override
  Future<void> signInWithPassword({
    String username,
    String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithPasswordFailure(e.shortMessage);
    }
  }

  @override
  Future<void> signInWithFacebook() async {
    // Trigger the sign-in flow
    AccessToken accessToken;
    try {
      accessToken = await facebookAuth.login();
    } on FacebookAuthException catch (e) {
      if (e.errorCode == FacebookAuthErrorCode.CANCELLED) {
        throw SignInWithFacebookFailure('Aborted');
      }
      throw SignInWithFacebookFailure();
    }

    // Create a credential from the access token
    final firebase_auth.FacebookAuthCredential credential =
        firebase_auth.FacebookAuthProvider.credential(accessToken.token);

    try {
      await _linkWithAnonymousOrLoginUsing(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithFacebookFailure(e.shortMessage);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await googleAuth.signIn();

    // Aborted
    if (googleUser == null) {
      throw SignInWithGoogleFailure('Aborted');
    }

    // Obtain the auth details from the request
    GoogleSignInAuthentication _googleAuth;
    try {
      _googleAuth = await googleUser.authentication;
    } catch (e) {
      throw SignInWithGoogleFailure();
    }

    // Create a new credential
    final firebase_auth.GoogleAuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );

    try {
      await _linkWithAnonymousOrLoginUsing(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithGoogleFailure(e.shortMessage);
    }
  }

  @override
  Future<void> signInWithPhoneNumberSend({
    String number,
    Function(String) callback,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          // Automatic background verification. Fail silently
          try {
            await _linkWithAnonymousOrLoginUsing(credential);
          } catch (e) {
            //
          }
        },
        verificationFailed: (_) => {},
        codeSent: (verificationId, forceResendingToken) =>
            callback.call(verificationId),
        codeAutoRetrievalTimeout: (_) => {},
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithPhoneNumberFailure(e.shortMessage);
    }
  }

  @override
  Future<void> signInWithPhoneNumberVerify({
    String verificationId,
    String code,
  }) async {
    // Create a PhoneAuthCredential with the code
    firebase_auth.PhoneAuthCredential phoneAuthCredential =
        firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    try {
      await _linkWithAnonymousOrLoginUsing(phoneAuthCredential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithPhoneNumberFailure(e.shortMessage);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      bool _googleSignedIn = await googleAuth.isSignedIn();
      if (_googleSignedIn) {
        await googleAuth.signOut();
      }

      bool _facebookSignedIn = (await facebookAuth.isLogged) != null;
      if (_facebookSignedIn) {
        await facebookAuth.logOut();
      }

      await firebaseAuth.signOut();
    } catch (e) {
      throw SignOutFailure();
    }
  }

  @override
  Stream<User> get user => userStream.stream;

  Future<void> _linkWithAnonymousOrLoginUsing(
    firebase_auth.AuthCredential credential,
  ) async {
    if (firebaseAuth.currentUser?.isAnonymous == true) {
      await firebaseAuth.currentUser.linkWithCredential(credential);
      // Trigger user change so that the UI can re-render
      userStream.add(firebaseAuth.currentUser.toUser);
    } else {
      await firebaseAuth.signInWithCredential(credential);
    }
  }
}

extension on firebase_auth.User {
  SigninProvider get _mapFirebaseProvider {
    if (isAnonymous) return SigninProvider.anonymous;

    switch (providerData.first.providerId) {
      case 'facebook.com':
        return SigninProvider.facebook;
      case 'google.com':
        return SigninProvider.google;
      case 'phone':
        return SigninProvider.phone;
      case 'password':
        return SigninProvider.password;
    }

    return null;
  }

  String get _mapFirebaseProviderIdentifier {
    if (isAnonymous) return null;

    final provider = providerData.first;
    switch (provider.providerId) {
      case 'facebook.com':
        return provider.displayName;
      case 'google.com':
        return provider.email;
      case 'phone':
        return provider.phoneNumber;
      case 'password':
        return provider.email;
    }

    return null;
  }

  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      avatar: photoURL,
      provider: _mapFirebaseProvider,
      providerIdentifier: _mapFirebaseProviderIdentifier,
    );
  }
}

extension ShortErrorMessage on firebase_auth.FirebaseAuthException {
  String get shortMessage {
    if (this.code == 'credential-already-in-use') {
      return 'Account already exists. Please logout first and try logging in again.';
    }
    return toBeginningOfSentenceCase(
      this.code.replaceAll('-', ' '),
    );
  }
}
