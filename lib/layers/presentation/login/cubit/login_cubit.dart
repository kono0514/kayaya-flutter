import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/usecase.dart';
import '../../../domain/usecases/authentication/login_with_anonymous_usecase.dart';
import '../../../domain/usecases/authentication/login_with_facebook_usecase.dart';
import '../../../domain/usecases/authentication/login_with_google_usecase.dart';

part 'login_state.dart';

@Injectable()
class LoginCubit extends Cubit<LoginState> {
  final LoginWithGoogleUsecase loginWithGoogleUsecase;
  final LoginWithFacebookUsecase loginWithFacebookUsecase;
  final LoginWithAnonymousUsecase loginWithAnonymousUsecase;

  LoginCubit({
    @required this.loginWithGoogleUsecase,
    @required this.loginWithFacebookUsecase,
    @required this.loginWithAnonymousUsecase,
  }) : super(LoginInitial());

  Future<void> signInWithGoogle() async {
    const method = LoginMethod.google;
    emit(const LoginSubmitting(method));
    final result = await loginWithGoogleUsecase(NoParams());
    result.fold(
      (l) => emit(LoginError(l.message)),
      (r) => emit(LoginInitial()),
    );
  }

  Future<void> signInWithFacebook() async {
    const method = LoginMethod.facebook;
    emit(const LoginSubmitting(method));
    final result = await loginWithFacebookUsecase(NoParams());
    result.fold(
      (l) => emit(LoginError(l.message)),
      (r) => emit(LoginInitial()),
    );
  }

  Future<void> signInAnonymously() async {
    const method = LoginMethod.anonymous;
    emit(const LoginSubmitting(method));
    final result = await loginWithAnonymousUsecase(NoParams());
    result.fold(
      (l) => emit(LoginError(l.message)),
      (r) => emit(LoginInitial()),
    );
  }
}
