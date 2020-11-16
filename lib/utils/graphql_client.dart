import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:kayaya_flutter/services/shared_preferences_service.dart';
import 'package:meta/meta.dart';

GraphQLClient getGraphQLClient() {
  final GraphQLCache cache = GraphQLCache();
  final sps = GetIt.I<SharedPreferencesService>();

  final httpLink = HttpLink(
    // 'https://api.kayaya.stream/graphql',
    'http://aniim-api.test/graphql',
  );
  final authLink = AuthLink(
    getToken: () async {
      final userToken =
          await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
      return 'Bearer $userToken';
    },
  );
  final localeLink = LocaleLink(getLocale: () => sps.languageCode ?? 'en');
  Link links = Link.from([
    localeLink,
    authLink,
    httpLink,
  ]);

  return GraphQLClient(
    link: links,
    cache: cache,
  );
}

class LocaleLink extends Link {
  final Function() getLocale;
  LocaleLink({@required this.getLocale});

  @override
  Stream<Response> request(Request request, [forward]) {
    final locale = getLocale();
    final req = request.updateContextEntry<HttpLinkHeaders>(
      (headers) => HttpLinkHeaders(
        headers: <String, String>{
          ...headers?.headers ?? <String, String>{},
          'Accept-Language': locale,
        },
      ),
    );
    return forward(req);
  }
}
