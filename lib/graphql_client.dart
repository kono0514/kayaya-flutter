import 'package:graphql/client.dart';

final NormalizedInMemoryCache cache = NormalizedInMemoryCache(
  dataIdFromObject: typenameDataIdFromObject,
);

Link link = HttpLink(uri: 'http://aniim-api.test/graphql');

GraphQLClient _client;

GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
    link: link,
    cache: cache,
  );

  return _client;
}
