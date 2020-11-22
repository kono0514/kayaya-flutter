import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/bloc/authentication_bloc.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:quiver/core.dart';

part 'login_phone_state.dart';

class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  final AuthenticationRepository repository;
  final AuthenticationBloc authBloc;

  LoginPhoneCubit(this.repository, this.authBloc) : super(LoginPhoneState());

  void numberChanged(String value) {
    emit(state.copyWith(
      phoneNumber: value,
    ));
  }

  void otpChanged(String value) {
    emit(state.copyWith(
      otpCode: value,
    ));
  }

  void sendSMSCode() async {
    emit(state.copyWith(
      status: LoginPhoneStatus.sending,
      otpCode: '',
      verificationId: '',
      exception: Optional.absent(),
    ));
    await repository.signInWithPhoneNumberSend(
      phoneNumber: state.phoneNumber,
      verificationCompleted: () {
        // We don't need to do anything here.
        // AuthenticationBloc does popping/pushing screens
        // based on firebase login state automatically
      },
      verificationFailed: (e) {
        emit(state.copyWith(
          status: LoginPhoneStatus.sendError,
          exception: Optional.of(e),
        ));
      },
      codeSent: (verificationId) {
        emit(state.copyWith(
          status: LoginPhoneStatus.sent,
          verificationId: verificationId,
          exception: Optional.absent(),
        ));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  void verifySMSCode() async {
    emit(state.copyWith(
      status: LoginPhoneStatus.verifying,
      exception: Optional.absent(),
    ));
    try {
      final cred = await repository.signInWithPhoneNumberVerify(
        verificationId: state.verificationId,
        code: state.otpCode,
      );
      if (cred.wasLinkedWithAnonymous) {
        authBloc.add(AuthenticationUserChanged(cred.userCredential.user));
      }
      emit(LoginPhoneState());
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: LoginPhoneStatus.verifyError,
        exception: Optional.of(e),
      ));
    }
  }
}
