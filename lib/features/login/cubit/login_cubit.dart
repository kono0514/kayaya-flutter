import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/core/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/core/repositories/auth_repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;
  final AuthenticationBloc authBloc;

  LoginCubit(this.repository, this.authBloc) : super(LoginInitial());

  void signInWithGoogle() async {
    final method = LoginMethod.google;
    emit(LoginSubmitting(method));
    try {
      await repository.signInWithGoogle();
      emit(LoginInitial());
    } on SignInWithGoogleFailure catch (e) {
      emit(LoginError(e));
    }
  }

  void signInWithFacebook() async {
    final method = LoginMethod.facebook;
    emit(LoginSubmitting(method));
    try {
      await repository.signInWithFacebook();
      emit(LoginInitial());
    } on SignInWithFacebookFailure catch (e) {
      emit(LoginError(e));
    }
  }

  void signInAnonymously() async {
    final method = LoginMethod.anonymous;
    emit(LoginSubmitting(method));
    try {
      await repository.signInAnonymously();
      emit(LoginInitial());
    } on SignInAnonymouslyFailure catch (e) {
      emit(LoginError(e));
    }
  }
}
