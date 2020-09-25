part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {}

class AuthenticationUserChanged extends AuthenticationEvent {
  final User user;

  AuthenticationUserChanged(this.user);

  @override
  List<Object> get props => [user];
}
