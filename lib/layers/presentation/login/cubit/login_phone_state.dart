part of 'login_phone_cubit.dart';

class LoginPhoneState extends Equatable {
  final String phoneNumber;
  final String otpCode;
  final LoginPhoneStatus status;
  final String error;
  final String verificationId;

  const LoginPhoneState({
    this.phoneNumber = '',
    this.otpCode = '',
    this.status = LoginPhoneStatus.initial,
    this.error,
    this.verificationId = '',
  });

  @override
  List<Object> get props =>
      [phoneNumber, otpCode, status, error, verificationId];

  LoginPhoneState copyWith({
    String phoneNumber,
    String otpCode,
    LoginPhoneStatus status,
    Optional<String> error,
    String verificationId,
  }) {
    return LoginPhoneState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
      error: error != null ? error.orNull : this.error,
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
