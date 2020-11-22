import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';

class UserDataRepositry {
  GraphQLClient client;

  UserDataRepositry() {
    this.client = GetIt.I<GraphQLClient>();
  }

  Future<List<GetSubscriptions$Query$Subscriptions>>
      fetchSubscriptions() async {
    final _options = QueryOptions(
      document: GetSubscriptionsQuery().document,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetSubscriptions$Query.fromJson(result.data).subscriptions;
  }
}
