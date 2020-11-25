import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart';
import 'package:kayaya_flutter/features/browse/browse.dart';

class AniimRepository {
  GraphQLClient client;

  AniimRepository() {
    this.client = GetIt.I<GraphQLClient>();
  }

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
      first: 20,
      page: page,
      orderBy: orderBy ?? [],
      typeIn: typeIn ?? [],
      hasGenres: genres,
    );
    final _options = QueryOptions(
      document: BrowseAnimesQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    final animes = BrowseAnimes$Query.fromJson(result.data).animes;

    if (genres != null) {
      // Show active filtered genres first
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
      document: GetGenresQuery().document,
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
      document: GetAnimeDetailsQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetAnimeDetails$Query.fromJson(result.data).anime;
  }

  Future<GetAnimeDetailsFull$Query$Anime> fetchDetailsFull(String id) async {
    final args = GetAnimeDetailsFullArguments(id: id);
    final _options = QueryOptions(
      document: GetAnimeDetailsFullQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetAnimeDetailsFull$Query.fromJson(result.data).anime;
  }

  Future<GetAnimeRelations$Query$Anime> fetchRelations(String id) async {
    final args = GetAnimeRelationsArguments(id: id);
    final _options = QueryOptions(
      document: GetAnimeRelationsQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetAnimeRelations$Query.fromJson(result.data).anime;
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
      first: 30,
      orderBy: <EpisodesOrderByOrderByClause>[
        EpisodesOrderByOrderByClause(
          field: EpisodesOrderByColumn.number,
          order: sortOrder,
        ),
      ],
    );
    final _options = QueryOptions(
      document: GetAnimeEpisodesQuery().document,
      variables: args.toJson(),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final result = await client.query(_options);

    if (result.hasException) {
      throw result.exception;
    }

    return GetAnimeEpisodes$Query.fromJson(result.data).episodes;
  }

  Future<String> fetchFeatured() async {
    final result = await client.query(
      QueryOptions(
        document: GetFeaturedQuery().document,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return GetFeatured$Query.fromJson(result.data).featured;
  }

  Future<bool> subscribeTo(String id) async {
    final args = SubscribeToArguments(animeId: id);
    final result = await client.mutate(
      MutationOptions(
        document: SubscribeToMutation().document,
        variables: args.toJson(),
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return SubscribeTo$Mutation.fromJson(result.data).subscribeTo;
  }

  Future<bool> unsubscribeFrom(String id) async {
    final args = UnsubscribeFromArguments(animeId: id);
    final result = await client.mutate(
      MutationOptions(
        document: UnsubscribeFromMutation().document,
        variables: args.toJson(),
      ),
    );

    if (result.hasException) {
      throw result.exception;
    }

    return UnsubscribeFrom$Mutation.fromJson(result.data).unsubscribeFrom;
  }
}
