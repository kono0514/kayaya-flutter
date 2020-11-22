import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/cubit/login_cubit.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/screens/login/phone_auth.dart';
import 'package:kayaya_flutter/widgets/sign_in_button.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';

class LoginPage extends StatelessWidget {
  final bool disableAnonymous;

  const LoginPage({
    Key key,
    this.disableAnonymous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => LoginCubit(
          context.read<AuthenticationRepository>(),
          context.read<AuthenticationBloc>(),
        ),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        state.exception.message ?? 'Authentication Failure'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.fromLTRB(36.0, 5.0, 36.0, 10.0),
                  ),
                );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NumberButton(),
                SizedBox(height: 8),
                _GoogleButton(),
                SizedBox(height: 8),
                _FacebookButton(),
                SizedBox(height: 8),
                if (!disableAnonymous) _AnonymousButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnonymousButton extends StatelessWidget {
  const _AnonymousButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) => SizedBox(
        width: 46,
        height: 46,
        child: SpinnerButton(
          label: Text('Continue without signing in'),
          spinnerColor: Theme.of(context).buttonColor,
          disabled: state is LoginSubmitting,
          loading:
              state is LoginSubmitting && state.method == LoginMethod.anonymous,
          onPressed: () {
            context.read<LoginCubit>().signInAnonymously();
          },
          buttonType: TextButton,
        ),
      ),
    );
  }
}

class _FacebookButton extends StatelessWidget {
  const _FacebookButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) => SizedBox(
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
          disabled: state is LoginSubmitting,
          loading:
              state is LoginSubmitting && state.method == LoginMethod.facebook,
          onPressed: () {
            context.read<LoginCubit>().signInWithFacebook();
          },
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) => SizedBox(
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
          disabled: state is LoginSubmitting,
          loading:
              state is LoginSubmitting && state.method == LoginMethod.google,
          onPressed: () {
            context.read<LoginCubit>().signInWithGoogle();
          },
        ),
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) => SizedBox(
        width: 46,
        height: 46,
        child: SignInButton(
          icon: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Icon(Icons.phone, size: 28),
          ),
          label: Text('Sign in with Number'),
          color: Colors.grey.shade700,
          disabled: state is LoginSubmitting,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPhoneAuthPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
