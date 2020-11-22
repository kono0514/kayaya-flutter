part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSubmitting extends LoginState {
  final LoginMethod method;

  LoginSubmitting(this.method);

  @override
  List<Object> get props => [method];
}

class LoginError extends LoginState {
  final AuthException exception;

  LoginError(this.exception);

  @override
  List<Object> get props => [exception];
}

enum LoginMethod {
  google,
  facebook,
  anonymous,
}
