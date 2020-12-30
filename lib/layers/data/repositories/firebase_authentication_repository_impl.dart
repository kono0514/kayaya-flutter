import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../models/user_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryFirebaseImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleAuth;
  final FacebookAuth facebookAuth;
  StreamController<User> userStream = StreamController.broadcast();

  AuthRepositoryFirebaseImpl({
    @required this.firebaseAuth,
    @required this.googleAuth,
    @required this.facebookAuth,
  }) {
    userStream.onCancel = () {
      userStream.close();
    };
    firebaseAuth.authStateChanges().listen((firebaseUser) {
      final user = firebaseUser == null
          ? User.empty
          : UserModel.fromFirebaseUser(firebaseUser);
      userStream.add(user);
    });
  }

  @override
  Future<Either<Failure, User>> signInAnonymously() async {
    try {
      final _userCred = await firebaseAuth.signInAnonymously();
      return Right(UserModel.fromFirebaseUser(_userCred.user));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInAnonymouslyFailure(message: e.shortMessage));
    } catch (e, s) {
      errorLog(e, s);
      return const Left(SignInAnonymouslyFailure());
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
      return Right(UserModel.fromFirebaseUser(_userCred.user));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithPasswordFailure(message: e.shortMessage));
    } catch (e, s) {
      errorLog(e, s);
      return const Left(SignInWithPasswordFailure());
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
        return const Left(SignInWithFacebookFailure(message: 'Aborted'));
      }
      return const Left(SignInWithFacebookFailure());
    } catch (e, s) {
      errorLog(e, s);
      return const Left(SignInWithFacebookFailure());
    }

    // Create a credential from the access token
    final firebase_auth.OAuthCredential credential =
        firebase_auth.FacebookAuthProvider.credential(accessToken.token);

    try {
      final _userCred = await _linkWithAnonymousOrLoginUsing(credential);
      return Right(UserModel.fromFirebaseUser(_userCred.user));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithFacebookFailure(message: e.shortMessage));
    } catch (e, s) {
      errorLog(e, s);
      return const Left(SignInWithFacebookFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await googleAuth.signIn();

    // Aborted
    if (googleUser == null) {
      return const Left(SignInWithGoogleFailure(message: 'Aborted'));
    }

    // Obtain the auth details from the request
    GoogleSignInAuthentication _googleAuth;
    try {
      _googleAuth = await googleUser.authentication;
    } catch (e) {
      return const Left(SignInWithGoogleFailure());
    }

    // Create a new credential
    final firebase_auth.OAuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );

    try {
      final _userCred = await _linkWithAnonymousOrLoginUsing(credential);
      return Right(UserModel.fromFirebaseUser(_userCred.user));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithGoogleFailure(message: e.shortMessage));
    } catch (e, s) {
      errorLog(e, s);
      return const Left(SignInWithGoogleFailure());
    }
  }

  @override
  Future<Either<Failure, String>> signInWithPhoneNumberSend({
    String number,
  }) async {
    final _completer = Completer<Either<Failure, String>>();

    try {
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted:
            (firebase_auth.PhoneAuthCredential credential) async {
          try {
            await _linkWithAnonymousOrLoginUsing(credential);
          } catch (e, s) {
            errorLog(e, s);
          }
        },
        verificationFailed: (e) => _completer.complete(
            Left(SignInWithPhoneNumberFailure(message: e.shortMessage))),
        codeSent: (verificationId, forceResendingToken) =>
            _completer.complete(Right(verificationId)),
        codeAutoRetrievalTimeout: (_) => {},
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithPhoneNumberFailure(message: e.shortMessage));
    } catch (e) {
      return const Left(SignInWithPhoneNumberFailure());
    }

    return _completer.future;
  }

  @override
  Future<Either<Failure, User>> signInWithPhoneNumberVerify({
    String verificationId,
    String code,
  }) async {
    // Create a PhoneAuthCredential with the code
    final firebase_auth.AuthCredential phoneAuthCredential =
        firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    try {
      final _userCred =
          await _linkWithAnonymousOrLoginUsing(phoneAuthCredential);
      return Right(UserModel.fromFirebaseUser(_userCred.user));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(SignInWithPhoneNumberFailure(message: e.shortMessage));
    } catch (e, s) {
      errorLog(e, s);
      return const Left(SignInWithPhoneNumberFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      final _googleSignedIn = await googleAuth.isSignedIn();
      if (_googleSignedIn) {
        await googleAuth.signOut();
      }

      final _facebookSignedIn = (await facebookAuth.isLogged) != null;
      if (_facebookSignedIn) {
        await facebookAuth.logOut();
      }

      await firebaseAuth.signOut();

      return const Right(unit);
    } catch (e, s) {
      errorLog(e, s);
      return const Left(SignOutFailure());
    }
  }

  @override
  Stream<User> get user => userStream.stream;

  @override
  Future<Either<Failure, String>> getIdToken() async {
    try {
      final _token = await firebaseAuth.currentUser?.getIdToken();
      return Right(_token);
    } catch (e, s) {
      errorLog(e, s);
      return const Left(ServerFailure());
    }
  }

  Future<firebase_auth.UserCredential> _linkWithAnonymousOrLoginUsing(
    firebase_auth.AuthCredential credential,
  ) async {
    if (firebaseAuth.currentUser?.isAnonymous == true) {
      final _userCred =
          await firebaseAuth.currentUser.linkWithCredential(credential);
      // Trigger user change so that the UI can re-render
      userStream.add(UserModel.fromFirebaseUser(firebaseAuth.currentUser));
      return _userCred;
    } else {
      return firebaseAuth.signInWithCredential(credential);
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() {
    return Future.value(Right(firebaseAuth.currentUser != null));
  }
}

extension ShortErrorMessage on firebase_auth.FirebaseAuthException {
  String get shortMessage {
    if (code == 'credential-already-in-use') {
      return 'Account already exists. Please logout first and try logging in again.';
    }
    return toBeginningOfSentenceCase(
      code.replaceAll('-', ' '),
    );
  }
}
