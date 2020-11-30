import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/modules/authentication/domain/usecase/login_with_anonymous.dart';
import '../../../../core/modules/authentication/domain/usecase/login_with_facebook.dart';
import '../../../../core/modules/authentication/domain/usecase/login_with_google.dart';
import '../../../../core/usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginWithGoogle loginWithGoogle;
  final LoginWithFacebook loginWithFacebook;
  final LoginWithAnonymous loginWithAnonymous;

  LoginCubit({
    @required this.loginWithGoogle,
    @required this.loginWithFacebook,
    @required this.loginWithAnonymous,
  }) : super(LoginInitial());

  void signInWithGoogle() async {
    final method = LoginMethod.google;
    emit(LoginSubmitting(method));
    final result = await loginWithGoogle(NoParams());
    result.fold(
      (l) => emit(LoginError(l.message)),
      (r) => emit(LoginInitial()),
    );
  }

  void signInWithFacebook() async {
    final method = LoginMethod.facebook;
    emit(LoginSubmitting(method));
    final result = await loginWithFacebook(NoParams());
    result.fold(
      (l) => emit(LoginError(l.message)),
      (r) => emit(LoginInitial()),
    );
  }

  void signInAnonymously() async {
    final method = LoginMethod.anonymous;
    emit(LoginSubmitting(method));
    final result = await loginWithAnonymous(NoParams());
    result.fold(
      (l) => emit(LoginError(l.message)),
      (r) => emit(LoginInitial()),
    );
  }
}
