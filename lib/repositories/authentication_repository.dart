import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class SocialAuthProcessAborted implements Exception {}

class SocialAuthProcessFailed implements Exception {}

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

  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _googleAuth.signIn();

    // Aborted
    if (googleUser == null) {
      throw SocialAuthProcessAborted();
    }

    // Obtain the auth details from the request
    GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = await googleUser.authentication;
    } catch (_) {
      throw SocialAuthProcessFailed();
    }

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    AccessToken accessToken;
    try {
      accessToken = await FacebookAuth.instance.login();
    } on FacebookAuthException catch (e) {
      if (e.errorCode == FacebookAuthErrorCode.CANCELLED) {
        throw SocialAuthProcessAborted();
      }
      throw SocialAuthProcessFailed();
    } catch (_) {
      throw SocialAuthProcessFailed();
    }

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.token);

    // Once signed in, return the UserCredential
    return await _firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signInWithPhoneNumberSend({
    @required String phoneNumber,
    @required Function verificationCompleted,
    @required Function(FirebaseAuthException) verificationFailed,
    @required Function(String verificationId) codeSent,
    @required Function(String verificationId) codeAutoRetrievalTimeout,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _firebaseAuth.signInWithCredential(credential);
          verificationCompleted.call();
        } catch (e) {
          verificationFailed.call(e);
        }
      },
      verificationFailed: verificationFailed,
      codeSent: (verificationId, forceResendingToken) =>
          codeSent.call(verificationId),
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithPhoneNumberVerify({
    @required String verificationId,
    @required String code,
  }) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    // Sign the user in (or link) with the credential
    return await _firebaseAuth.signInWithCredential(phoneAuthCredential);
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
