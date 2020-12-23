import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    @required String id,
    @required String email,
    @required String name,
    @required String avatar,
    @required AuthProvider provider,
    @required String providerIdentifier,
  }) : super(
          id: id,
          email: email,
          name: name,
          avatar: avatar,
          provider: provider,
          providerIdentifier: providerIdentifier,
        );

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName,
      avatar: firebaseUser.photoURL,
      provider: firebaseUser._mapFirebaseProvider,
      providerIdentifier: firebaseUser._mapFirebaseProviderIdentifier,
    );
  }
}

extension on firebase_auth.User {
  AuthProvider get _mapFirebaseProvider {
    if (isAnonymous) return AuthProvider.anonymous;

    switch (providerData.first.providerId) {
      case 'facebook.com':
        return AuthProvider.facebook;
      case 'google.com':
        return AuthProvider.google;
      case 'phone':
        return AuthProvider.phone;
      case 'password':
        return AuthProvider.password;
    }

    return null;
  }

  String get _mapFirebaseProviderIdentifier {
    if (isAnonymous) return null;

    final provider = providerData.first;
    switch (provider.providerId) {
      case 'facebook.com':
        return provider.displayName;
      case 'google.com':
        return provider.email;
      case 'phone':
        return provider.phoneNumber;
      case 'password':
        return provider.email;
    }

    return null;
  }
}
