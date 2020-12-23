import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/icon_popup_menu.dart';
import '../../../../core/widgets/spinner_button.dart';
import '../../../../locale/generated/l10n.dart';
import '../../locale/cubit/locale_cubit.dart';
import '../cubit/login_cubit.dart';
import '../widget/sign_in_button.dart';
import 'login_phone_auth_page.dart';

class LoginPage extends StatelessWidget {
  final bool disableAnonymous;

  const LoginPage({
    Key key,
    this.disableAnonymous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = context.watch<LocaleCubit>().state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => GetIt.I<LoginCubit>(),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? 'Authentication Failure'),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.fromLTRB(46.0, 5.0, 46.0, 10.0),
                  ),
                );
            }
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/aots4.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: _isDark
                        ? ColorFilter.mode(
                            Colors.blue.withOpacity(0.7),
                            BlendMode.darken,
                          )
                        : ColorFilter.mode(
                            Colors.amber.withOpacity(0.7),
                            BlendMode.darken,
                          ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF00326c).withOpacity(0.4),
                      const Color(0xFF02001d),
                    ],
                    stops: const [0.0, 0.3, 0.8],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 46.0, right: 46.0, bottom: 30.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: UnconstrainedBox(
                          child: IconPopupMenu<String>(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 12),
                            items: const [
                              PopupMenuItem<String>(
                                value: 'en',
                                child: Text('English'),
                              ),
                              PopupMenuItem<String>(
                                value: 'mn',
                                child: Text('Монгол'),
                              ),
                            ],
                            title: Text(
                              locale.locale.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.language),
                            iconColor: Colors.white,
                            initialValue: locale.locale,
                            onSelected: (value) {
                              BlocProvider.of<LocaleCubit>(context)
                                  .changeLocale(value);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      'Brand Logo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .apply(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  const Center(
                                    child: Text(
                                      'Short paragraph lorem lorem lorem lorem lorem',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const _NumberButton(),
                            const SizedBox(height: 10),
                            const _GoogleButton(),
                            const SizedBox(height: 10),
                            const _FacebookButton(),
                            const SizedBox(height: 10),
                            if (!disableAnonymous) const _AnonymousButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          label: Text(TR.of(context).sign_in_anonymous),
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
          label: Text(TR.of(context).sign_in_facebook),
          color: const Color.fromRGBO(23, 120, 242, 0.9),
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
          label: Text(TR.of(context).sign_in_google),
          color: const Color.fromRGBO(219, 68, 55, 0.9),
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
          icon: const Padding(
            padding: EdgeInsets.only(left: 6.0),
            child: Icon(Icons.phone, size: 28),
          ),
          label: Text(TR.of(context).sign_in_number),
          color: Colors.blueGrey,
          disabled: state is LoginSubmitting,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPhoneAuthPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
