part of 'login_phone_cubit.dart';

class LoginPhoneState extends Equatable {
  final String phoneNumber;
  final String otpCode;
  final LoginPhoneStatus status;
  final String exception;
  final String verificationId;

  const LoginPhoneState({
    this.phoneNumber = '',
    this.otpCode = '',
    this.status = LoginPhoneStatus.initial,
    this.exception,
    this.verificationId = '',
  });

  @override
  List<Object> get props =>
      [phoneNumber, otpCode, status, exception, verificationId];

  LoginPhoneState copyWith({
    String phoneNumber,
    String otpCode,
    LoginPhoneStatus status,
    Optional<String> exception,
    String verificationId,
  }) {
    return LoginPhoneState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
      exception: exception != null ? exception.orNull : this.exception,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

enum LoginPhoneStatus {
  initial,
  sending,
  sendError,
  sent,
  verifying,
  verifyError,
}
