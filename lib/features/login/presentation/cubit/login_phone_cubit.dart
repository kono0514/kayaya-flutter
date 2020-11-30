import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../../../../core/modules/authentication/domain/usecase/send_phone_code.dart';
import '../../../../core/modules/authentication/domain/usecase/verify_phone_code.dart';

part 'login_phone_state.dart';

class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  final SendPhoneCode sendPhoneCode;
  final VerifyPhoneCode verifyPhoneCode;

  LoginPhoneCubit({
    @required this.sendPhoneCode,
    @required this.verifyPhoneCode,
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
      exception: Optional.absent(),
    ));
    final result =
        await sendPhoneCode(SendPhoneCodeParams(number: state.phoneNumber));
    result.fold(
      (l) => emit(state.copyWith(
        status: LoginPhoneStatus.sendError,
        exception: Optional.of(l.message),
      )),
      (r) {
        r.fold(
          (l) => emit(LoginPhoneState()),
          (r) => emit(state.copyWith(
            status: LoginPhoneStatus.sent,
            verificationId: r,
            exception: Optional.absent(),
          )),
        );
      },
    );
  }

  void verifySMSCode() async {
    emit(state.copyWith(
      status: LoginPhoneStatus.verifying,
      exception: Optional.absent(),
    ));
    final result = await verifyPhoneCode(VerifyPhoneCodeParams(
      verificationId: state.verificationId,
      code: state.otpCode,
    ));
    result.fold(
      (l) => emit(state.copyWith(
        status: LoginPhoneStatus.verifyError,
        exception: Optional.of(l.message),
      )),
      (r) => LoginPhoneState(),
    );
  }
}
