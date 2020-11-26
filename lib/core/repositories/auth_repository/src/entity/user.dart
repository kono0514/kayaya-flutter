import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final SigninProvider provider;
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

  bool get isAnonymous => provider == SigninProvider.anonymous;

  @override
  List<Object> get props =>
      [id, email, name, avatar, provider, providerIdentifier];
}

class SigninProvider {
  final String _value;

  const SigninProvider._(this._value);

  String get value => _value;

  static const google = const SigninProvider._('Google');
  static const facebook = const SigninProvider._('Facebook');
  static const password = const SigninProvider._('Password');
  static const phone = const SigninProvider._('Phone');
  static const anonymous = const SigninProvider._('Anonymous');
}
