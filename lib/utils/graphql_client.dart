import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphql/client.dart';

GraphQLClient getGraphQLClient({String locale = 'en'}) {
  final NormalizedInMemoryCache cache = NormalizedInMemoryCache(
    dataIdFromObject: typenameDataIdFromObject,
  );

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

  return GraphQLClient(
    link: authLink.concat(httpLink),
    cache: cache,
  );
}
