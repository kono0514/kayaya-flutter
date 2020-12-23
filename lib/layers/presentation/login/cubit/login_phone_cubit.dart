import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../../../domain/usecases/authentication/send_phone_code_usecase.dart';
import '../../../domain/usecases/authentication/verify_phone_code_usecase.dart';

part 'login_phone_state.dart';

@Injectable()
class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  final SendPhoneCodeUsecase sendPhoneCodeUsecase;
  final VerifyPhoneCodeUsecase verifyPhoneCodeUsecase;

  LoginPhoneCubit({
    @required this.sendPhoneCodeUsecase,
    @required this.verifyPhoneCodeUsecase,
  }) : super(const LoginPhoneState());

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

  Future<void> sendSMSCode() async {
    emit(state.copyWith(
      status: LoginPhoneStatus.sending,
      otpCode: '',
      verificationId: '',
      error: const Optional.absent(),
    ));
    final result = await sendPhoneCodeUsecase(
        SendPhoneCodeUsecaseParams(number: state.phoneNumber));
    result.fold(
      (l) => emit(state.copyWith(
        status: LoginPhoneStatus.sendError,
        error: Optional.of(l.message),
      )),
      (r) {
        emit(state.copyWith(
          status: LoginPhoneStatus.sent,
          verificationId: r,
          error: const Optional.absent(),
        ));
      },
    );
  }

  Future<void> verifySMSCode() async {
    emit(state.copyWith(
      status: LoginPhoneStatus.verifying,
      error: const Optional.absent(),
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
      (r) => const LoginPhoneState(),
    );
  }
}
