import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'auth_provider.dart';

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
