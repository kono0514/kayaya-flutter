import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository repository;
  final AuthenticationBloc authBloc;

  LoginCubit(this.repository, this.authBloc) : super(LoginInitial());

  void signInWithGoogle() async {
    final method = LoginMethod.google;
    emit(LoginSubmitting(method));
    try {
      final cred = await repository.signInWithGoogle();
      if (cred.wasLinkedWithAnonymous) {
        authBloc.add(AuthenticationUserChanged(cred.userCredential.user));
      }
      emit(LoginInitial());
    } on AuthException catch (e) {
      emit(LoginError(e));
    }
  }

  void signInWithFacebook() async {
    final method = LoginMethod.facebook;
    emit(LoginSubmitting(method));
    try {
      final cred = await repository.signInWithFacebook();
      if (cred.wasLinkedWithAnonymous) {
        authBloc.add(AuthenticationUserChanged(cred.userCredential.user));
      }
      emit(LoginInitial());
    } on AuthException catch (e) {
      emit(LoginError(e));
    }
  }

  void signInAnonymously() async {
    final method = LoginMethod.anonymous;
    emit(LoginSubmitting(method));
    try {
      await repository.signInAnonymously();
      emit(LoginInitial());
    } on AuthException catch (e) {
      emit(LoginError(e));
    }
  }
}
