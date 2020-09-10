import 'package:graphql/client.dart';

final NormalizedInMemoryCache cache = NormalizedInMemoryCache(
  dataIdFromObject: typenameDataIdFromObject,
);

GraphQLClient _client;

GraphQLClient getGraphQLClient({String locale = 'en'}) {
  _client ??= GraphQLClient(
    link: HttpLink(
      uri: 'http://aniim-api.test/graphql',
      headers: {'Accept-Language': locale},
    ),
    cache: cache,
  );

  return _client;
}
