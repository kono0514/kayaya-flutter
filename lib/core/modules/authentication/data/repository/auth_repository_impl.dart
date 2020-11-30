import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../../error.dart';
import '../../domain/entity/user.dart';
import '../../domain/entity/auth_provider.dart';
import '../../domain/repository/auth_repository.dart';

class FirebaseAuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleAuth;
  final FacebookAuth facebookAuth;
  StreamController<User> userStream = StreamController.broadcast();

  FirebaseAuthRepositoryImpl({
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
  Future<Either<Failure, User>> signInAnonymously() async {
    try {
      final _userCred = await firebaseAuth.signInAnonymously();
      return Right(_userCred.user.toUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInAnonymouslyFailure(message: e.shortMessage));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, User>> signInWithPassword({
    String username,
    String password,
  }) async {
    try {
      final _userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      return Right(_userCred.user.toUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithPasswordFailure(message: e.shortMessage));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, User>> signInWithFacebook() async {
    // Trigger the sign-in flow
    AccessToken accessToken;
    try {
      accessToken = await facebookAuth.login();
    } on FacebookAuthException catch (e) {
      if (e.errorCode == FacebookAuthErrorCode.CANCELLED) {
        return Left(SignInWithFacebookFailure(message: 'Aborted'));
      }
      return Left(SignInWithFacebookFailure());
    } catch (e) {
      return Left(e);
    }

    // Create a credential from the access token
    final firebase_auth.FacebookAuthCredential credential =
        firebase_auth.FacebookAuthProvider.credential(accessToken.token);

    try {
      final _userCred = await _linkWithAnonymousOrLoginUsing(credential);
      return Right(_userCred.user.toUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithFacebookFailure(message: e.shortMessage));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await googleAuth.signIn();

    // Aborted
    if (googleUser == null) {
      return Left(SignInWithGoogleFailure(message: 'Aborted'));
    }

    // Obtain the auth details from the request
    GoogleSignInAuthentication _googleAuth;
    try {
      _googleAuth = await googleUser.authentication;
    } catch (e) {
      return Left(SignInWithGoogleFailure());
    }

    // Create a new credential
    final firebase_auth.GoogleAuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );

    try {
      final _userCred = await _linkWithAnonymousOrLoginUsing(credential);
      return Right(_userCred.user.toUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithGoogleFailure(message: e.shortMessage));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Either<User, String>>> signInWithPhoneNumberSend({
    String number,
  }) async {
    final _completer = Completer<Either<Failure, Either<User, String>>>();

    try {
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          try {
            final _userCred = await _linkWithAnonymousOrLoginUsing(credential);
            _completer.complete(Right(Left(_userCred.user.toUser)));
          } on firebase_auth.FirebaseAuthException catch (e) {
            _completer.completeError(
                Left(SignInWithPhoneNumberFailure(message: e.shortMessage)));
          } catch (e) {
            _completer.completeError(Left(e));
          }
        },
        verificationFailed: (_) => {},
        codeSent: (verificationId, forceResendingToken) =>
            _completer.complete(Right(Right(verificationId))),
        codeAutoRetrievalTimeout: (_) => {},
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithPhoneNumberFailure(message: e.shortMessage));
    } catch (e) {
      return Left(e);
    }

    return _completer.future;
  }

  @override
  Future<Either<Failure, User>> signInWithPhoneNumberVerify({
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
      final _userCred =
          await _linkWithAnonymousOrLoginUsing(phoneAuthCredential);
      return Right(_userCred.user.toUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithPhoneNumberFailure(message: e.shortMessage));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
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

      return Right(unit);
    } catch (e) {
      return Left(SignOutFailure());
    }
  }

  @override
  Stream<User> get user => userStream.stream;

  @override
  Future<Either<Failure, String>> getIdToken() async {
    try {
      final _token = await firebaseAuth.currentUser?.getIdToken();
      return Right(_token);
    } catch (e) {
      return Left(e);
    }
  }

  Future<firebase_auth.UserCredential> _linkWithAnonymousOrLoginUsing(
    firebase_auth.AuthCredential credential,
  ) async {
    if (firebaseAuth.currentUser?.isAnonymous == true) {
      final _userCred =
          await firebaseAuth.currentUser.linkWithCredential(credential);
      // Trigger user change so that the UI can re-render
      userStream.add(firebaseAuth.currentUser.toUser);
      return _userCred;
    } else {
      return await firebaseAuth.signInWithCredential(credential);
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() {
    return Future.value(Right(firebaseAuth.currentUser != null));
  }
}

extension on firebase_auth.User {
  AuthProvider get _mapFirebaseProvider {
    if (isAnonymous) return AuthProvider.anonymous;

    switch (providerData.first.providerId) {
      case 'facebook.com':
        return AuthProvider.facebook;
      case 'google.com':
        return AuthProvider.google;
      case 'phone':
        return AuthProvider.phone;
      case 'password':
        return AuthProvider.password;
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
