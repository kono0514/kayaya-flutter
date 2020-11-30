abstract class Failure implements Exception {
  String get message;
}

class SignInWithGoogleFailure extends Failure {
  final String message;
  SignInWithGoogleFailure({this.message});
}

class SignInWithFacebookFailure extends Failure {
  final String message;
  SignInWithFacebookFailure({this.message});
}

class SignInWithPasswordFailure extends Failure {
  final String message;
  SignInWithPasswordFailure({this.message});
}

class SignInWithPhoneNumberFailure extends Failure {
  final String message;
  SignInWithPhoneNumberFailure({this.message});
}

class SignInAnonymouslyFailure extends Failure {
  final String message;
  SignInAnonymouslyFailure({this.message});
}

class SignOutFailure extends Failure {
  final String message;
  SignOutFailure({this.message});
}
