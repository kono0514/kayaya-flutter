import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../services/notification_service.dart';
import '../../../../usecase.dart';
import '../../domain/entity/user.dart';
import '../../domain/usecase/get_user_stream.dart';
import '../../domain/usecase/logout.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetUserStream getUserStream;
  final Logout logout;

  StreamSubscription<User> _userSubscription;

  AuthenticationBloc({
    @required this.getUserStream,
    @required this.logout,
  }) : super(Uninitialized()) {
    listenUserChanges();
  }

  void listenUserChanges() async {
    final result = await getUserStream(NoParams());
    result.fold((l) => () {}, (stream) {
      _userSubscription = stream.listen(
        (user) => add(AuthenticationUserChanged(user)),
      );
    });
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
      logout(NoParams());
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
