import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../codegen/graphql_api.graphql.dart' as gen;
import '../../core/paged_list.dart';
import '../data/datasources/anime_network_datasource.dart';
import '../data/models/anime_model.dart';
import '../data/models/genre_model.dart';
import '../domain/entities/anime_filter.dart';

@Injectable(as: AnimeNetworkDatasource)
class AnimeNetworkDatasourceKayayaImpl extends AnimeNetworkDatasource {
  final GraphQLClient graphql;

  AnimeNetworkDatasourceKayayaImpl({@required this.graphql});

  @override
  Future<String> fetchFeatured() async {
    final result = await graphql.query(
      QueryOptions(
        document: gen.GetFeaturedQuery().document,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return gen.GetFeatured$Query.fromJson(result.data).featured;
  }

  @override
  Future<List<GenreModel>> fetchGenres() async {
    final _options = QueryOptions(
      document: gen.GetGenresQuery().document,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return gen.GetGenres$Query.fromJson(result.data)
        .genres
        .map((e) => GenreModel.fromGraphQL(e))
        .toList();
  }

  @override
  Future<PagedList<AnimeModel>> fetchAnimes(int page, Filter filter) async {
    final orderBy = filter?.orderBy ?? FilterOrderBy.recent;
    final type = filter?.type ?? FilterType.all;
    final genres = filter?.genres ?? <String>[];

    final gqlOrderBy = _mapFilterOrderByToGraphQL(orderBy);
    final gqlType = _mapFilterTypeToGraphQL(type);
    final gqlGenres = _mapGenresToGraphQL(genres);

    final args = gen.BrowseAnimesArguments(
      first: 20,
      page: page,
      orderBy: gqlOrderBy,
      typeIn: gqlType,
      hasGenres: gqlGenres,
    );
    final _options = QueryOptions(
      document: gen.BrowseAnimesQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final _result = gen.BrowseAnimes$Query.fromJson(result.data).animes;
    var animes =
        _result.data.map((e) => AnimeModel.fromGraphQLWithGenres(e)).toList();

    // Show active filtered genres first
    if (genres != null) {
      animes = animes.map<AnimeModel>((anime) {
        return anime.modelCopyWith(
          genres: [
            ...anime.genres.where((genre) => genres.indexOf(genre.id) > -1),
            ...anime.genres.where((genre) => genres.indexOf(genre.id) == -1),
          ],
        );
      }).toList();
    }

    return PagedList<AnimeModel>(
      elements: animes,
      total: _result.paginatorInfo.total,
      currentPage: _result.paginatorInfo.currentPage,
      hasMorePages: _result.paginatorInfo.hasMorePages,
    );
  }
}

List<gen.AnimesOrderByOrderByClause> _mapFilterOrderByToGraphQL(
    FilterOrderBy filterOrderBy) {
  List<gen.AnimesOrderByOrderByClause> _wrap(
      gen.AnimeOrderColumns field, gen.SortOrder order) {
    return [
      gen.AnimesOrderByOrderByClause(
        field: field,
        order: order,
      ),
    ];
  }

  switch (filterOrderBy) {
    case FilterOrderBy.recent:
      return _wrap(gen.AnimeOrderColumns.id, gen.SortOrder.desc);
    case FilterOrderBy.alpha_asc:
      return _wrap(gen.AnimeOrderColumns.name, gen.SortOrder.asc);
    case FilterOrderBy.alpha_desc:
      return _wrap(gen.AnimeOrderColumns.name, gen.SortOrder.desc);
    case FilterOrderBy.rating_asc:
      return _wrap(gen.AnimeOrderColumns.rating, gen.SortOrder.asc);
    case FilterOrderBy.rating_desc:
      return _wrap(gen.AnimeOrderColumns.rating, gen.SortOrder.desc);
  }

  return _wrap(gen.AnimeOrderColumns.id, gen.SortOrder.desc);
}

List<gen.AnimeType> _mapFilterTypeToGraphQL(FilterType filterType) {
  if (filterType == FilterType.movie) {
    return [gen.AnimeType.movie];
  } else if (filterType == FilterType.series) {
    return [gen.AnimeType.series];
  }

  // (filterType == FilterType.all)
  return <gen.AnimeType>[];
}

gen.AnimesHasGenresWhereConditions _mapGenresToGraphQL(List<String> genres) {
  if (genres.length == 0) {
    return null;
  }

  var uniqueIds = genres.toSet().toList();
  return gen.AnimesHasGenresWhereConditions(
    or: uniqueIds
        .map((e) => gen.AnimesHasGenresWhereConditions(
              column: gen.AnimesHasGenresColumn.id,
              kw$operator: gen.SQLOperator.eq,
              value: e,
            ))
        .toList(),
  );
}
