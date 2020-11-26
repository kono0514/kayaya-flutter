abstract class AuthFailure implements Exception {
  final String message;
  const AuthFailure([this.message]);
}

class SignInWithGoogleFailure extends AuthFailure {
  const SignInWithGoogleFailure([message]) : super(message);
}

class SignInWithFacebookFailure extends AuthFailure {
  const SignInWithFacebookFailure([message]) : super(message);
}

class SignInWithPasswordFailure extends AuthFailure {
  const SignInWithPasswordFailure([message]) : super(message);
}

class SignInWithPhoneNumberFailure extends AuthFailure {
  const SignInWithPhoneNumberFailure([message]) : super(message);
}

class SignInAnonymouslyFailure extends AuthFailure {
  const SignInAnonymouslyFailure([message]) : super(message);
}

class SignOutFailure extends AuthFailure {
  const SignOutFailure([message]) : super(message);
}
