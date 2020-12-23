part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSubmitting extends LoginState {
  final LoginMethod method;

  const LoginSubmitting(this.method);

  @override
  List<Object> get props => [method];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}

enum LoginMethod {
  google,
  facebook,
  anonymous,
}
