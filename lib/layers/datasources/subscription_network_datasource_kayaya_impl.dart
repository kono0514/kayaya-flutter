import 'package:graphql_flutter/graphql_flutter.dart' hide ServerException;
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../codegen/graphql_api.graphql.dart' as gen;
import '../../core/exception.dart';
import '../../core/paged_list.dart';
import '../data/datasources/subscription_network_datasource.dart';
import '../data/models/anime_model.dart';

@Injectable(as: SubscriptionNetworkDatasource)
class SubscriptionNetworkDatasourceKayayaImpl
    implements SubscriptionNetworkDatasource {
  final GraphQLClient graphql;

  SubscriptionNetworkDatasourceKayayaImpl({@required this.graphql});

  @override
  Future<PagedList<AnimeModel>> fetchSubscriptions(int page) async {
    final args = gen.GetSubscriptionsArguments(
      first: 20,
      page: page,
    );
    final _options = QueryOptions(
      document: gen.GetSubscriptionsQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw ServerException(result.exception);
    }

    final _result =
        gen.GetSubscriptions$Query.fromJson(result.data).me.subscriptions;

    return PagedList<AnimeModel>(
      elements: _result.data.map((e) => AnimeModel.fromGraphQL(e)).toList(),
      total: _result.paginatorInfo.total,
      currentPage: _result.paginatorInfo.currentPage,
      hasMorePages: _result.paginatorInfo.hasMorePages,
    );
  }

  @override
  Future<bool> subscribe(String id) async {
    final args = gen.SubscribeToArguments(animeId: id);
    final result = await graphql.mutate(
      MutationOptions(
        document: gen.SubscribeToMutation().document,
        variables: args.toJson(),
      ),
    );

    if (result.hasException) {
      throw ServerException(result.exception);
    }

    return gen.SubscribeTo$Mutation.fromJson(result.data).subscribeTo;
  }

  @override
  Future<bool> unsubscribe(String id) async {
    final args = gen.UnsubscribeFromArguments(animeId: id);
    final result = await graphql.mutate(
      MutationOptions(
        document: gen.UnsubscribeFromMutation().document,
        variables: args.toJson(),
      ),
    );

    if (result.hasException) {
      throw ServerException(result.exception);
    }

    return gen.UnsubscribeFrom$Mutation.fromJson(result.data).unsubscribeFrom;
  }

  @override
  Future<bool> fetchIsSubscribed(String id) async {
    final args = gen.IsSubscribedToArguments(animeId: id);
    final _options = QueryOptions(
      document: gen.IsSubscribedToQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw ServerException(result.exception);
    }

    return gen.IsSubscribedTo$Query.fromJson(result.data).isUserSubscribedTo;
  }
}
