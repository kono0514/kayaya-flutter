import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../codegen/graphql_api.graphql.dart' as gen;
import '../../core/paged_list.dart';
import '../data/datasources/detail_network_datasource.dart';
import '../data/models/anime_model.dart';
import '../data/models/anime_relation_model.dart';
import '../data/models/detail_model.dart';
import '../data/models/episode_model.dart';

@Injectable(as: DetailNetworkDatasource)
class DetailNetworkDatasourceKayayaImpl extends DetailNetworkDatasource {
  final GraphQLClient graphql;

  DetailNetworkDatasourceKayayaImpl({@required this.graphql});

  @override
  Future<DetailModel> fetchDetail(String id) async {
    final args = gen.GetAnimeDetailsFullArguments(id: id);
    final _options = QueryOptions(
      document: gen.GetAnimeDetailsQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final _result = gen.GetAnimeDetails$Query.fromJson(result.data).anime;
    return DetailModel.fromGraphQL(_result);
  }

  @override
  Future<Tuple2<AnimeModel, DetailModel>> fetchDetailFull(String id) async {
    final args = gen.GetAnimeDetailsFullArguments(id: id);
    final _options = QueryOptions(
      document: gen.GetAnimeDetailsFullQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final _result = gen.GetAnimeDetailsFull$Query.fromJson(result.data).anime;
    final _anime =
        gen.BrowseAnimes$Query$Animes$Data.fromJson(_result.toJson());
    return Tuple2(
      AnimeModel.fromGraphQLWithGenres(_anime),
      DetailModel.fromGraphQL(_result),
    );
  }

  @override
  Future<AnimeRelationModel> fetchRelations(String id) async {
    final args = gen.GetAnimeRelationsArguments(id: id);
    final _options = QueryOptions(
      document: gen.GetAnimeRelationsQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return AnimeRelationModel.fromGraphQL(
      gen.GetAnimeRelations$Query.fromJson(result.data).anime,
    );
  }

  @override
  Future<PagedList<EpisodeModel>> fetchEpisodes(
      String id, int page, String order) async {
    var _order = order == 'asc' ? gen.SortOrder.asc : gen.SortOrder.desc;

    final args = gen.GetAnimeEpisodesArguments(
      hasAnime: gen.EpisodesHasAnimeWhereConditions(
        column: gen.EpisodesHasAnimeColumn.id,
        value: id,
        kw$operator: gen.SQLOperator.eq,
      ),
      page: page,
      first: 30,
      orderBy: <gen.EpisodesOrderByOrderByClause>[
        gen.EpisodesOrderByOrderByClause(
          field: gen.EpisodesOrderByColumn.number,
          order: _order,
        ),
      ],
    );
    final _options = QueryOptions(
      document: gen.GetAnimeEpisodesQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final _result = gen.GetAnimeEpisodes$Query.fromJson(result.data).episodes;
    final episodes =
        _result.data.map((e) => EpisodeModel.fromGraphQL(e)).toList();

    return PagedList<EpisodeModel>(
      elements: episodes,
      total: _result.paginatorInfo.total,
      currentPage: _result.paginatorInfo.currentPage,
      hasMorePages: _result.paginatorInfo.hasMorePages,
    );
  }

  @override
  Future<Tuple2<int, bool>> fetchEpisodePageInfo(String id, int number) async {
    final args = gen.GetEpisodePageInfoArguments(
      animeId: id,
      episodeNumber: number,
      perPage: 30,
    );
    final _options = QueryOptions(
      document: gen.GetEpisodePageInfoQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final _result =
        gen.GetEpisodePageInfo$Query.fromJson(result.data).episodePageLocator;

    return Tuple2(_result.page, _result.hasMorePages);
  }
}
