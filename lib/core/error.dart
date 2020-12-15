import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message = ''});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure() : super(message: 'Server Failure');
}

class CacheFailure extends Failure {
  CacheFailure() : super(message: 'Cache Failure');
}

class DataFailure extends Failure {
  DataFailure() : super(message: 'Failed to fetch data');
}

class SignInWithGoogleFailure extends Failure {
  const SignInWithGoogleFailure({String message}) : super(message: message);
}

class SignInWithFacebookFailure extends Failure {
  const SignInWithFacebookFailure({String message}) : super(message: message);
}

class SignInWithPasswordFailure extends Failure {
  const SignInWithPasswordFailure({String message}) : super(message: message);
}

class SignInWithPhoneNumberFailure extends Failure {
  const SignInWithPhoneNumberFailure({String message})
      : super(message: message);
}

class SignInAnonymouslyFailure extends Failure {
  const SignInAnonymouslyFailure({String message}) : super(message: message);
}

class SignOutFailure extends Failure {
  const SignOutFailure({String message}) : super(message: message);
}
