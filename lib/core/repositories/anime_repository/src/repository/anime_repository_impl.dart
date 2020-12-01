import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/core/entity/paged_list.dart';
import 'package:kayaya_flutter/core/repositories/anime_repository/src/entity/episode.dart';
import 'package:meta/meta.dart';

import '../../../../../codegen/graphql_api.graphql.dart' as gen;
import '../entity/anime.dart';
import '../entity/anime_details.dart';
import '../entity/genre.dart';
import '../model/anime_model.dart';
import '../model/anime_details_model.dart';
import '../model/genre_model.dart';
import '../model/episode_model.dart';
import 'anime_repository.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  final GraphQLClient graphql;

  AnimeRepositoryImpl({
    @required this.graphql,
  });

  @override
  Future<PagedList<Anime>> getAnimes({
    int page = 1,
    FilterOrderBy orderBy = FilterOrderBy.recent,
    FilterType type = FilterType.all,
    List<Genre> genres = const [],
  }) async {
    final _orderBy = _mapFilterOrderByToGraphQL(orderBy);
    final _type = _mapFilterTypeToGraphQL(type);
    final _genres = _mapGenresToGraphQL(genres);

    final args = gen.BrowseAnimesArguments(
      first: 20,
      page: page,
      orderBy: _orderBy ?? [],
      typeIn: _type,
      hasGenres: _genres,
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
    final animes = _result.data.map((e) => AnimeModel.fromGraphQL(e)).toList();

    // Show active filtered genres first
    if (genres != null) {
      animes.forEach((anime) {
        anime = anime.copyWith(
          genres: [
            ...anime.genres.where((genre) => genres.indexOf(genre) > -1),
            ...anime.genres.where((genre) => genres.indexOf(genre) == -1),
          ],
        );
      });
    }

    return PagedList<Anime>(
      elements: animes,
      total: _result.paginatorInfo.total,
      currentPage: _result.paginatorInfo.currentPage,
      hasMorePages: _result.paginatorInfo.hasMorePages,
    );
  }

  @override
  Future<AnimeDetails> getAnimeDetails({
    String id,
  }) async {
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

    final _anime = gen.GetAnimeDetailsFull$Query.fromJson(result.data).anime;
    return AnimeDetailsModel.fromGraphQL(_anime);
  }

  @override
  Future<List<Genre>> getGenres() async {
    final _options = QueryOptions(
      document: GetGenresQuery().document,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetGenres$Query.fromJson(result.data)
        .genres
        .map((e) => GenreModel.fromGraphQL(e))
        .toList();
  }

  @override
  Future<PagedList<Episode>> getEpisodes({
    String id,
    int page = 1,
    SortDirection sort = SortDirection.asc,
  }) async {
    var _order = sort == SortDirection.asc ? SortOrder.asc : SortOrder.desc;

    final args = GetAnimeEpisodesArguments(
      hasAnime: EpisodesHasAnimeWhereConditions(
        column: EpisodesHasAnimeColumn.id,
        value: id,
        kw$operator: SQLOperator.eq,
      ),
      page: page,
      first: 30,
      orderBy: <EpisodesOrderByOrderByClause>[
        EpisodesOrderByOrderByClause(
          field: EpisodesOrderByColumn.number,
          order: _order,
        ),
      ],
    );
    final _options = QueryOptions(
      document: GetAnimeEpisodesQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await graphql.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final _result = GetAnimeEpisodes$Query.fromJson(result.data).episodes;
    final episodes =
        _result.data.map((e) => EpisodeModel.fromGraphQL(e)).toList();

    return PagedList<Episode>(
      elements: episodes,
      total: _result.paginatorInfo.total,
      currentPage: _result.paginatorInfo.currentPage,
      hasMorePages: _result.paginatorInfo.hasMorePages,
    );
  }
}

List<AnimesOrderByOrderByClause> _mapFilterOrderByToGraphQL(
    FilterOrderBy filterOrderBy) {
  List<AnimesOrderByOrderByClause> _wrap(
      AnimeOrderColumns field, SortOrder order) {
    return [
      AnimesOrderByOrderByClause(
        field: field,
        order: order,
      ),
    ];
  }

  switch (filterOrderBy) {
    case FilterOrderBy.recent:
      return _wrap(AnimeOrderColumns.id, SortOrder.desc);
    case FilterOrderBy.alpha_asc:
      return _wrap(AnimeOrderColumns.name, SortOrder.asc);
    case FilterOrderBy.alpha_desc:
      return _wrap(AnimeOrderColumns.name, SortOrder.desc);
    case FilterOrderBy.rating_asc:
      return _wrap(AnimeOrderColumns.rating, SortOrder.asc);
    case FilterOrderBy.rating_desc:
      return _wrap(AnimeOrderColumns.rating, SortOrder.desc);
  }

  return _wrap(AnimeOrderColumns.id, SortOrder.desc);
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

AnimesHasGenresWhereConditions _mapGenresToGraphQL(List<Genre> genres) {
  if (genres.length == 0) {
    return null;
  }

  var uniqueIds = genres.map((g) => g.id).toSet().toList();
  return AnimesHasGenresWhereConditions(
    or: uniqueIds
        .map((e) => AnimesHasGenresWhereConditions(
              column: AnimesHasGenresColumn.id,
              kw$operator: SQLOperator.eq,
              value: e,
            ))
        .toList(),
  );
}
