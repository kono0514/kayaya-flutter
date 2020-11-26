import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/core/repositories/user_repository/auth_repository.dart';
import 'package:kayaya_flutter/core/services/notification_service.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepo;
  StreamSubscription<User> _userSubscription;

  AuthenticationBloc(AuthRepository authenticationRepository)
      : assert(authenticationRepository != null),
        _authRepo = authenticationRepository,
        super(Uninitialized()) {
    _userSubscription = _authRepo.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authRepo.signOut();
    }
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
      AuthenticationUserChanged event) {
    if (event.user != User.empty) {
      GetIt.I<NotificationService>().uploadCurrentFcmToken();
      return Authenticated(event.user);
    }
    return Unauthenticated();
  }
}
