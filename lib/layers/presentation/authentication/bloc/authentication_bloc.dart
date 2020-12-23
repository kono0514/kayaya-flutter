import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/usecase.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/authentication/get_user_stream_usecase.dart';
import '../../../domain/usecases/authentication/logout_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@Injectable()
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetUserStreamUsecase getUserStreamUsecase;
  final LogoutUsecase logoutUsecase;

  StreamSubscription<User> _userSubscription;

  AuthenticationBloc({
    @required this.getUserStreamUsecase,
    @required this.logoutUsecase,
  }) : super(Uninitialized()) {
    listenUserChanges();
  }

  Future<void> listenUserChanges() async {
    final result = await getUserStreamUsecase(NoParams());
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
      logoutUsecase(NoParams());
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
