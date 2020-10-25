import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphql/client.dart';

final NormalizedInMemoryCache cache = NormalizedInMemoryCache(
  dataIdFromObject: typenameDataIdFromObject,
);

GraphQLClient _client;

GraphQLClient getGraphQLClient({String locale = 'en'}) {
  if (_client != null) return _client;

  final httpLink = HttpLink(
    // uri: 'https://api.kayaya.stream/graphql',
    uri: 'http://aniim-api.test/graphql',
    headers: {'Accept-Language': locale},
  );
  final authLink = AuthLink(
    getToken: () async {
      final userToken = await FirebaseAuth.instance.currentUser.getIdToken();
      return 'Bearer $userToken';
    },
  );

  _client = GraphQLClient(
    link: authLink.concat(httpLink),
    cache: cache,
  );

  return _client;
}
