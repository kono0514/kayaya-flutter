class AuthProvider {
  final String _value;

  const AuthProvider._(this._value);

  String get value => _value;

  static const google = const AuthProvider._('Google');
  static const facebook = const AuthProvider._('Facebook');
  static const password = const AuthProvider._('Password');
  static const phone = const AuthProvider._('Phone');
  static const anonymous = const AuthProvider._('Anonymous');
}
