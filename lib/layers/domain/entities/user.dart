import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final AuthProvider provider;
  final String providerIdentifier;

  const User({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.avatar,
    @required this.provider,
    @required this.providerIdentifier,
  });

  static const empty = User(
    id: '',
    email: '',
    name: '',
    avatar: null,
    provider: null,
    providerIdentifier: null,
  );

  bool get isAnonymous => provider == AuthProvider.anonymous;

  @override
  List<Object> get props =>
      [id, email, name, avatar, provider, providerIdentifier];
}

class AuthProvider {
  final String _value;

  const AuthProvider._(this._value);

  String get value => _value;

  static const google = AuthProvider._('Google');
  static const facebook = AuthProvider._('Facebook');
  static const password = AuthProvider._('Password');
  static const phone = AuthProvider._('Phone');
  static const anonymous = AuthProvider._('Anonymous');
}
