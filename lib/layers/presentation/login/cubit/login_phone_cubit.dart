import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../../../domain/usecases/authentication/send_phone_code_usecase.dart';
import '../../../domain/usecases/authentication/verify_phone_code_usecase.dart';

part 'login_phone_state.dart';

class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  final SendPhoneCodeUsecase sendPhoneCodeUsecase;
  final VerifyPhoneCodeUsecase verifyPhoneCodeUsecase;

  LoginPhoneCubit({
    @required this.sendPhoneCodeUsecase,
    @required this.verifyPhoneCodeUsecase,
  }) : super(LoginPhoneState());

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
      error: Optional.absent(),
    ));
    final result = await sendPhoneCodeUsecase(
        SendPhoneCodeUsecaseParams(number: state.phoneNumber));
    result.fold(
      (l) => emit(state.copyWith(
        status: LoginPhoneStatus.sendError,
        error: Optional.of(l.message),
      )),
      (r) {
        r.fold(
          (l) => emit(LoginPhoneState()),
          (r) => emit(state.copyWith(
            status: LoginPhoneStatus.sent,
            verificationId: r,
            error: Optional.absent(),
          )),
        );
      },
    );
  }

  void verifySMSCode() async {
    emit(state.copyWith(
      status: LoginPhoneStatus.verifying,
      error: Optional.absent(),
    ));
    final result = await verifyPhoneCodeUsecase(VerifyPhoneCodeUsecaseParams(
      verificationId: state.verificationId,
      code: state.otpCode,
    ));
    result.fold(
      (l) => emit(state.copyWith(
        status: LoginPhoneStatus.verifyError,
        error: Optional.of(l.message),
      )),
      (r) => LoginPhoneState(),
    );
  }
}
