import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/screens/login/phone_auth.dart';
import 'package:kayaya_flutter/widgets/sign_in_button.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationRepository authRepo;
  bool _numberLoggingIn = false;
  bool _googleLoggingIn = false;
  bool _facebookLoggingIn = false;
  bool _anonymousLoggingIn = false;

  bool get loggingIn =>
      _numberLoggingIn ||
      _googleLoggingIn ||
      _facebookLoggingIn ||
      _anonymousLoggingIn;

  @override
  void initState() {
    super.initState();
    authRepo = RepositoryProvider.of<AuthenticationRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 46,
              height: 46,
              child: SignInButton(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(Icons.phone, size: 28),
                ),
                label: Text('Sign in with Number'),
                color: Colors.grey.shade700,
                disabled: loggingIn,
                loading: _numberLoggingIn,
                onPressed: _number,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 46,
              height: 46,
              child: SignInButton(
                icon: Image.asset(
                  'assets/logos/google_light.png',
                  width: 40,
                  height: 40,
                ),
                label: Text('Sign in with Google'),
                color: Color.fromRGBO(219, 68, 55, 1),
                disabled: loggingIn,
                loading: _googleLoggingIn,
                onPressed: _google,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 46,
              height: 46,
              child: SignInButton(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Image.asset(
                    'assets/logos/facebook.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                label: Text('Sign in with Facebook'),
                color: Color.fromRGBO(23, 120, 242, 1),
                disabled: loggingIn,
                loading: _facebookLoggingIn,
                onPressed: _facebook,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 46,
              height: 46,
              child: SpinnerButton(
                label: Text('Continue without signing in'),
                spinnerColor: Theme.of(context).buttonColor,
                disabled: loggingIn,
                loading: _anonymousLoggingIn,
                onPressed: _anonymous,
                buttonType: TextButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _number() async {
    setState(() {
      _numberLoggingIn = true;
    });
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPhoneAuthPage()),
    );
    if (mounted) {
      setState(() {
        _numberLoggingIn = false;
      });
    }
  }

  void _google() async {
    setState(() {
      _googleLoggingIn = true;
    });
    try {
      await authRepo.signInWithGoogle();
    } on SocialAuthProcessAborted {
      print('AuthProcessAborted');
    } on SocialAuthProcessFailed {
      print('SocialAuthProcessFailed');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {
        _googleLoggingIn = false;
      });
    }
  }

  void _facebook() async {
    setState(() {
      _facebookLoggingIn = true;
    });
    try {
      await authRepo.signInWithFacebook();
    } on SocialAuthProcessAborted {
      print('AuthProcessAborted');
    } on SocialAuthProcessFailed {
      print('SocialAuthProcessFailed');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {
        _facebookLoggingIn = false;
      });
    }
  }

  void _anonymous() async {
    setState(() {
      _anonymousLoggingIn = true;
    });
    try {
      await authRepo.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    if (mounted) {
      setState(() {
        _anonymousLoggingIn = false;
      });
    }
  }
}
