import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

final NormalizedInMemoryCache cache = NormalizedInMemoryCache(
  dataIdFromObject: typenameDataIdFromObject,
);

ValueNotifier<GraphQLClient> clientFor({
  @required String uri,
}) {
  Link link = HttpLink(uri: uri);

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: cache,
      link: link,
    ),
  );
}

/// Wraps the root application with the `graphql_flutter` client.
/// We use the cache for all state management.
class ClientProvider extends StatelessWidget {
  ClientProvider({
    @required this.child,
    @required String uri,
  }) : client = clientFor(
          uri: uri,
        );

  final Widget child;
  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: child,
    );
  }
}