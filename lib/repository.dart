import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/models/filter.dart';

class AniimRepository {
  final GraphQLClient client;

  const AniimRepository(this.client);

  Future<BrowseAnimes$Query$Animes> fetchAnimes({
    int page = 1,
    Filter filter,
  }) async {
    var orderBy = filter?.orderBy == null
        ? null
        : _mapFilterOrderByToGraphQL(filter.orderBy);
    var typeIn =
        filter?.type == null ? null : _mapFilterTypeToGraphQL(filter.type);
    var genres =
        filter?.genres == null ? null : _mapGenresToGraphQL(filter.genres);

    final args = BrowseAnimesArguments(
      first: 10,
      page: page,
      orderBy: orderBy ?? [],
      typeIn: typeIn ?? [],
      hasGenres: genres,
    );
    final _options = QueryOptions(
      documentNode: BrowseAnimesQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final animes = BrowseAnimes$Query.fromJson(result.data).animes;

    if (genres != null) {
      // Show filtered genres first
      animes.data.forEach((anime) {
        anime.genres = [
          ...anime.genres
              .where((genre) => filter.genres.indexOf(genre.id) > -1),
          ...anime.genres
              .where((genre) => filter.genres.indexOf(genre.id) == -1),
        ];
      });
    }
    return animes;
  }

  List<AnimesOrderByOrderByClause> _mapFilterOrderByToGraphQL(
      FilterOrderBy filterOrderBy) {
    if (filterOrderBy == FilterOrderBy.alpha_asc) {
      return <AnimesOrderByOrderByClause>[
        AnimesOrderByOrderByClause(
            field: AnimeOrderColumns.nameMn, order: SortOrder.asc)
      ];
    } else if (filterOrderBy == FilterOrderBy.alpha_desc) {
      return <AnimesOrderByOrderByClause>[
        AnimesOrderByOrderByClause(
            field: AnimeOrderColumns.nameMn, order: SortOrder.desc)
      ];
    } else if (filterOrderBy == FilterOrderBy.rating_asc) {
      return <AnimesOrderByOrderByClause>[
        AnimesOrderByOrderByClause(
            field: AnimeOrderColumns.rating, order: SortOrder.asc)
      ];
    } else if (filterOrderBy == FilterOrderBy.rating_desc) {
      return <AnimesOrderByOrderByClause>[
        AnimesOrderByOrderByClause(
            field: AnimeOrderColumns.rating, order: SortOrder.desc)
      ];
    }

    // (filterOrderBy == FilterOrderBy.recent)
    return <AnimesOrderByOrderByClause>[
      AnimesOrderByOrderByClause(
          field: AnimeOrderColumns.id, order: SortOrder.desc)
    ];
  }

  List<AnimeType> _mapFilterTypeToGraphQL(FilterType filterType) {
    if (filterType == FilterType.movie) {
      return <AnimeType>[AnimeType.movie];
    } else if (filterType == FilterType.series) {
      return <AnimeType>[AnimeType.series];
    }

    // (filterType == FilterType.all)
    return <AnimeType>[];
  }

  AnimesHasGenresWhereConditions _mapGenresToGraphQL(List<String> genreIds) {
    if (genreIds.length == 0) {
      return null;
    }

    var uniqueIds = genreIds.toSet().toList();
    return AnimesHasGenresWhereConditions(
      or: uniqueIds
          .map((e) => AnimesHasGenresWhereConditions(
              column: AnimesHasGenresColumn.id,
              kw$operator: SQLOperator.eq,
              value: e))
          .toList(),
    );
  }

  Future<List<GetGenres$Query$Genres>> fetchGenres() async {
    final _options = QueryOptions(
      documentNode: GetGenresQuery().document,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetGenres$Query.fromJson(result.data).genres;
  }

  Future<GetAnimeDetails$Query$Anime> fetchDetails(String id) async {
    final args = GetAnimeDetailsArguments(id: id);
    final _options = QueryOptions(
      documentNode: GetAnimeDetailsQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetAnimeDetails$Query.fromJson(result.data).anime;
  }

  Future<GetAnimeEpisodes$Query$Episodes> fetchEpisodes(
    String id, {
    int page = 1,
    SortOrder sortOrder = SortOrder.asc,
  }) async {
    final args = GetAnimeEpisodesArguments(
      hasAnime: EpisodesHasAnimeWhereConditions(
        column: EpisodesHasAnimeColumn.id,
        value: id,
        kw$operator: SQLOperator.eq,
      ),
      page: page,
      first: 10,
      orderBy: <EpisodesOrderByOrderByClause>[
        EpisodesOrderByOrderByClause(
          field: EpisodesOrderByColumn.number,
          order: sortOrder,
        ),
      ],
    );
    final _options = QueryOptions(
      documentNode: GetAnimeEpisodesQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetAnimeEpisodes$Query.fromJson(result.data).episodes;
  }
}
