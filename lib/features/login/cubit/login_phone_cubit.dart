import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/core/repositories/user_repository/auth_repository.dart';
import 'package:kayaya_flutter/core/bloc/authentication_bloc.dart';
import 'package:quiver/core.dart';

part 'login_phone_state.dart';

class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  final AuthRepository repository;
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
      number: state.phoneNumber,
      callback: (verificationId) {
        emit(state.copyWith(
          status: LoginPhoneStatus.sent,
          verificationId: verificationId,
          exception: Optional.absent(),
        ));
      },
    );
  }

  void verifySMSCode() async {
    emit(state.copyWith(
      status: LoginPhoneStatus.verifying,
      exception: Optional.absent(),
    ));
    try {
      await repository.signInWithPhoneNumberVerify(
        verificationId: state.verificationId,
        code: state.otpCode,
      );
      emit(LoginPhoneState());
    } on SignInWithPhoneNumberFailure catch (e) {
      emit(state.copyWith(
        status: LoginPhoneStatus.verifyError,
        exception: Optional.of(e),
      ));
    }
  }
}
