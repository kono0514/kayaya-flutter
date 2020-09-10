// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowseAnimes$Query$Animes$PaginatorInfo
    _$BrowseAnimes$Query$Animes$PaginatorInfoFromJson(
        Map<String, dynamic> json) {
  return BrowseAnimes$Query$Animes$PaginatorInfo()
    ..total = json['total'] as int
    ..lastPage = json['lastPage'] as int
    ..hasMorePages = json['hasMorePages'] as bool
    ..currentPage = json['currentPage'] as int;
}

Map<String, dynamic> _$BrowseAnimes$Query$Animes$PaginatorInfoToJson(
        BrowseAnimes$Query$Animes$PaginatorInfo instance) =>
    <String, dynamic>{
      'total': instance.total,
      'lastPage': instance.lastPage,
      'hasMorePages': instance.hasMorePages,
      'currentPage': instance.currentPage,
    };

BrowseAnimes$Query$Animes$Data _$BrowseAnimes$Query$Animes$DataFromJson(
    Map<String, dynamic> json) {
  return BrowseAnimes$Query$Animes$Data()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..animeType = _$enumDecodeNullable(_$AnimeTypeEnumMap, json['animeType'],
        unknownValue: AnimeType.artemisUnknown)
    ..rating = json['rating'] as int
    ..coverImage = json['coverImage'] == null
        ? null
        : ListItemAnimeMixin$CoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..coverColor = json['coverColor'] as String
    ..bannerImage = json['bannerImage'] as String
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : ListItemAnimeMixin$Genres.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BrowseAnimes$Query$Animes$DataToJson(
        BrowseAnimes$Query$Animes$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'animeType': _$AnimeTypeEnumMap[instance.animeType],
      'rating': instance.rating,
      'coverImage': instance.coverImage?.toJson(),
      'coverColor': instance.coverColor,
      'bannerImage': instance.bannerImage,
      'genres': instance.genres?.map((e) => e?.toJson())?.toList(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$AnimeTypeEnumMap = {
  AnimeType.series: 'SERIES',
  AnimeType.movie: 'MOVIE',
  AnimeType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

BrowseAnimes$Query$Animes _$BrowseAnimes$Query$AnimesFromJson(
    Map<String, dynamic> json) {
  return BrowseAnimes$Query$Animes()
    ..paginatorInfo = json['paginatorInfo'] == null
        ? null
        : BrowseAnimes$Query$Animes$PaginatorInfo.fromJson(
            json['paginatorInfo'] as Map<String, dynamic>)
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : BrowseAnimes$Query$Animes$Data.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BrowseAnimes$Query$AnimesToJson(
        BrowseAnimes$Query$Animes instance) =>
    <String, dynamic>{
      'paginatorInfo': instance.paginatorInfo?.toJson(),
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };

BrowseAnimes$Query _$BrowseAnimes$QueryFromJson(Map<String, dynamic> json) {
  return BrowseAnimes$Query()
    ..animes = json['animes'] == null
        ? null
        : BrowseAnimes$Query$Animes.fromJson(
            json['animes'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BrowseAnimes$QueryToJson(BrowseAnimes$Query instance) =>
    <String, dynamic>{
      'animes': instance.animes?.toJson(),
    };

ListItemAnimeMixin$CoverImage _$ListItemAnimeMixin$CoverImageFromJson(
    Map<String, dynamic> json) {
  return ListItemAnimeMixin$CoverImage()..large = json['large'] as String;
}

Map<String, dynamic> _$ListItemAnimeMixin$CoverImageToJson(
        ListItemAnimeMixin$CoverImage instance) =>
    <String, dynamic>{
      'large': instance.large,
    };

ListItemAnimeMixin$Genres _$ListItemAnimeMixin$GenresFromJson(
    Map<String, dynamic> json) {
  return ListItemAnimeMixin$Genres()
    ..id = json['id'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$ListItemAnimeMixin$GenresToJson(
        ListItemAnimeMixin$Genres instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

AnimesHasGenresWhereConditions _$AnimesHasGenresWhereConditionsFromJson(
    Map<String, dynamic> json) {
  return AnimesHasGenresWhereConditions(
    column: _$enumDecodeNullable(_$AnimesHasGenresColumnEnumMap, json['column'],
        unknownValue: AnimesHasGenresColumn.artemisUnknown),
    kw$operator: _$enumDecodeNullable(_$SQLOperatorEnumMap, json['operator'],
        unknownValue: SQLOperator.artemisUnknown),
    value: json['value'] as String,
    and: (json['AND'] as List)
        ?.map((e) => e == null
            ? null
            : AnimesHasGenresWhereConditions.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
    or: (json['OR'] as List)
        ?.map((e) => e == null
            ? null
            : AnimesHasGenresWhereConditions.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AnimesHasGenresWhereConditionsToJson(
        AnimesHasGenresWhereConditions instance) =>
    <String, dynamic>{
      'column': _$AnimesHasGenresColumnEnumMap[instance.column],
      'operator': _$SQLOperatorEnumMap[instance.kw$operator],
      'value': instance.value,
      'AND': instance.and?.map((e) => e?.toJson())?.toList(),
      'OR': instance.or?.map((e) => e?.toJson())?.toList(),
    };

const _$AnimesHasGenresColumnEnumMap = {
  AnimesHasGenresColumn.id: 'ID',
  AnimesHasGenresColumn.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$SQLOperatorEnumMap = {
  SQLOperator.eq: 'EQ',
  SQLOperator.neq: 'NEQ',
  SQLOperator.gt: 'GT',
  SQLOperator.gte: 'GTE',
  SQLOperator.lt: 'LT',
  SQLOperator.lte: 'LTE',
  SQLOperator.like: 'LIKE',
  SQLOperator.notLike: 'NOT_LIKE',
  SQLOperator.kw$IN: 'IN',
  SQLOperator.notIn: 'NOT_IN',
  SQLOperator.between: 'BETWEEN',
  SQLOperator.notBetween: 'NOT_BETWEEN',
  SQLOperator.isNull: 'IS_NULL',
  SQLOperator.isNotNull: 'IS_NOT_NULL',
  SQLOperator.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

AnimesOrderByOrderByClause _$AnimesOrderByOrderByClauseFromJson(
    Map<String, dynamic> json) {
  return AnimesOrderByOrderByClause(
    field: _$enumDecodeNullable(_$AnimeOrderColumnsEnumMap, json['field'],
        unknownValue: AnimeOrderColumns.artemisUnknown),
    order: _$enumDecodeNullable(_$SortOrderEnumMap, json['order'],
        unknownValue: SortOrder.artemisUnknown),
  );
}

Map<String, dynamic> _$AnimesOrderByOrderByClauseToJson(
        AnimesOrderByOrderByClause instance) =>
    <String, dynamic>{
      'field': _$AnimeOrderColumnsEnumMap[instance.field],
      'order': _$SortOrderEnumMap[instance.order],
    };

const _$AnimeOrderColumnsEnumMap = {
  AnimeOrderColumns.id: 'ID',
  AnimeOrderColumns.nameEn: 'NAME_EN',
  AnimeOrderColumns.nameMn: 'NAME_MN',
  AnimeOrderColumns.rating: 'RATING',
  AnimeOrderColumns.animeType: 'ANIME_TYPE',
  AnimeOrderColumns.createdAt: 'CREATED_AT',
  AnimeOrderColumns.anilistDataUpdatedAt: 'ANILIST_DATA_UPDATED_AT',
  AnimeOrderColumns.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$SortOrderEnumMap = {
  SortOrder.asc: 'ASC',
  SortOrder.desc: 'DESC',
  SortOrder.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GetAnimeDetails$Query$Anime$Relations$Data$RelationPivot
    _$GetAnimeDetails$Query$Anime$Relations$Data$RelationPivotFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetails$Query$Anime$Relations$Data$RelationPivot()
    ..relationType = json['relationType'] as String;
}

Map<String,
    dynamic> _$GetAnimeDetails$Query$Anime$Relations$Data$RelationPivotToJson(
        GetAnimeDetails$Query$Anime$Relations$Data$RelationPivot instance) =>
    <String, dynamic>{
      'relationType': instance.relationType,
    };

GetAnimeDetails$Query$Anime$Relations$Data
    _$GetAnimeDetails$Query$Anime$Relations$DataFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetails$Query$Anime$Relations$Data()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..animeType = _$enumDecodeNullable(_$AnimeTypeEnumMap, json['animeType'],
        unknownValue: AnimeType.artemisUnknown)
    ..rating = json['rating'] as int
    ..coverImage = json['coverImage'] == null
        ? null
        : ListItemAnimeMixin$CoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..coverColor = json['coverColor'] as String
    ..bannerImage = json['bannerImage'] as String
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : ListItemAnimeMixin$Genres.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..relationPivot = json['relationPivot'] == null
        ? null
        : GetAnimeDetails$Query$Anime$Relations$Data$RelationPivot.fromJson(
            json['relationPivot'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeDetails$Query$Anime$Relations$DataToJson(
        GetAnimeDetails$Query$Anime$Relations$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'animeType': _$AnimeTypeEnumMap[instance.animeType],
      'rating': instance.rating,
      'coverImage': instance.coverImage?.toJson(),
      'coverColor': instance.coverColor,
      'bannerImage': instance.bannerImage,
      'genres': instance.genres?.map((e) => e?.toJson())?.toList(),
      'relationPivot': instance.relationPivot?.toJson(),
    };

GetAnimeDetails$Query$Anime$Relations
    _$GetAnimeDetails$Query$Anime$RelationsFromJson(Map<String, dynamic> json) {
  return GetAnimeDetails$Query$Anime$Relations()
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : GetAnimeDetails$Query$Anime$Relations$Data.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetAnimeDetails$Query$Anime$RelationsToJson(
        GetAnimeDetails$Query$Anime$Relations instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };

GetAnimeDetails$Query$Anime$Recommendations$Data$RecommendationPivot
    _$GetAnimeDetails$Query$Anime$Recommendations$Data$RecommendationPivotFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetails$Query$Anime$Recommendations$Data$RecommendationPivot()
    ..rating = json['rating'] as int;
}

Map<String, dynamic>
    _$GetAnimeDetails$Query$Anime$Recommendations$Data$RecommendationPivotToJson(
            GetAnimeDetails$Query$Anime$Recommendations$Data$RecommendationPivot
                instance) =>
        <String, dynamic>{
          'rating': instance.rating,
        };

GetAnimeDetails$Query$Anime$Recommendations$Data
    _$GetAnimeDetails$Query$Anime$Recommendations$DataFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetails$Query$Anime$Recommendations$Data()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..animeType = _$enumDecodeNullable(_$AnimeTypeEnumMap, json['animeType'],
        unknownValue: AnimeType.artemisUnknown)
    ..rating = json['rating'] as int
    ..coverImage = json['coverImage'] == null
        ? null
        : ListItemAnimeMixin$CoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..coverColor = json['coverColor'] as String
    ..bannerImage = json['bannerImage'] as String
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : ListItemAnimeMixin$Genres.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..recommendationPivot = json['recommendationPivot'] == null
        ? null
        : GetAnimeDetails$Query$Anime$Recommendations$Data$RecommendationPivot
            .fromJson(json['recommendationPivot'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeDetails$Query$Anime$Recommendations$DataToJson(
        GetAnimeDetails$Query$Anime$Recommendations$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'animeType': _$AnimeTypeEnumMap[instance.animeType],
      'rating': instance.rating,
      'coverImage': instance.coverImage?.toJson(),
      'coverColor': instance.coverColor,
      'bannerImage': instance.bannerImage,
      'genres': instance.genres?.map((e) => e?.toJson())?.toList(),
      'recommendationPivot': instance.recommendationPivot?.toJson(),
    };

GetAnimeDetails$Query$Anime$Recommendations
    _$GetAnimeDetails$Query$Anime$RecommendationsFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetails$Query$Anime$Recommendations()
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : GetAnimeDetails$Query$Anime$Recommendations$Data.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetAnimeDetails$Query$Anime$RecommendationsToJson(
        GetAnimeDetails$Query$Anime$Recommendations instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };

GetAnimeDetails$Query$Anime _$GetAnimeDetails$Query$AnimeFromJson(
    Map<String, dynamic> json) {
  return GetAnimeDetails$Query$Anime()
    ..id = json['id'] as String
    ..description = json['description'] as String
    ..anilist = fromGraphQLAnilistMediaToDartGraphqlAnilistApi$Query$Media(
        json['anilist'] as String)
    ..relations = json['relations'] == null
        ? null
        : GetAnimeDetails$Query$Anime$Relations.fromJson(
            json['relations'] as Map<String, dynamic>)
    ..recommendations = json['recommendations'] == null
        ? null
        : GetAnimeDetails$Query$Anime$Recommendations.fromJson(
            json['recommendations'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeDetails$Query$AnimeToJson(
        GetAnimeDetails$Query$Anime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'anilist': fromDartGraphqlAnilistApi$Query$MediaToGraphQLAnilistMedia(
          instance.anilist),
      'relations': instance.relations?.toJson(),
      'recommendations': instance.recommendations?.toJson(),
    };

GetAnimeDetails$Query _$GetAnimeDetails$QueryFromJson(
    Map<String, dynamic> json) {
  return GetAnimeDetails$Query()
    ..anime = json['anime'] == null
        ? null
        : GetAnimeDetails$Query$Anime.fromJson(
            json['anime'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeDetails$QueryToJson(
        GetAnimeDetails$Query instance) =>
    <String, dynamic>{
      'anime': instance.anime?.toJson(),
    };

GetAnimeDetailsFull$Query$Anime$Relations$Data$RelationPivot
    _$GetAnimeDetailsFull$Query$Anime$Relations$Data$RelationPivotFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query$Anime$Relations$Data$RelationPivot()
    ..relationType = json['relationType'] as String;
}

Map<String, dynamic>
    _$GetAnimeDetailsFull$Query$Anime$Relations$Data$RelationPivotToJson(
            GetAnimeDetailsFull$Query$Anime$Relations$Data$RelationPivot
                instance) =>
        <String, dynamic>{
          'relationType': instance.relationType,
        };

GetAnimeDetailsFull$Query$Anime$Relations$Data
    _$GetAnimeDetailsFull$Query$Anime$Relations$DataFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query$Anime$Relations$Data()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..animeType = _$enumDecodeNullable(_$AnimeTypeEnumMap, json['animeType'],
        unknownValue: AnimeType.artemisUnknown)
    ..rating = json['rating'] as int
    ..coverImage = json['coverImage'] == null
        ? null
        : ListItemAnimeMixin$CoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..coverColor = json['coverColor'] as String
    ..bannerImage = json['bannerImage'] as String
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : ListItemAnimeMixin$Genres.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..relationPivot = json['relationPivot'] == null
        ? null
        : GetAnimeDetailsFull$Query$Anime$Relations$Data$RelationPivot.fromJson(
            json['relationPivot'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeDetailsFull$Query$Anime$Relations$DataToJson(
        GetAnimeDetailsFull$Query$Anime$Relations$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'animeType': _$AnimeTypeEnumMap[instance.animeType],
      'rating': instance.rating,
      'coverImage': instance.coverImage?.toJson(),
      'coverColor': instance.coverColor,
      'bannerImage': instance.bannerImage,
      'genres': instance.genres?.map((e) => e?.toJson())?.toList(),
      'relationPivot': instance.relationPivot?.toJson(),
    };

GetAnimeDetailsFull$Query$Anime$Relations
    _$GetAnimeDetailsFull$Query$Anime$RelationsFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query$Anime$Relations()
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : GetAnimeDetailsFull$Query$Anime$Relations$Data.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetAnimeDetailsFull$Query$Anime$RelationsToJson(
        GetAnimeDetailsFull$Query$Anime$Relations instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };

GetAnimeDetailsFull$Query$Anime$Recommendations$Data$RecommendationPivot
    _$GetAnimeDetailsFull$Query$Anime$Recommendations$Data$RecommendationPivotFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query$Anime$Recommendations$Data$RecommendationPivot()
    ..rating = json['rating'] as int;
}

Map<String, dynamic>
    _$GetAnimeDetailsFull$Query$Anime$Recommendations$Data$RecommendationPivotToJson(
            GetAnimeDetailsFull$Query$Anime$Recommendations$Data$RecommendationPivot
                instance) =>
        <String, dynamic>{
          'rating': instance.rating,
        };

GetAnimeDetailsFull$Query$Anime$Recommendations$Data
    _$GetAnimeDetailsFull$Query$Anime$Recommendations$DataFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query$Anime$Recommendations$Data()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..animeType = _$enumDecodeNullable(_$AnimeTypeEnumMap, json['animeType'],
        unknownValue: AnimeType.artemisUnknown)
    ..rating = json['rating'] as int
    ..coverImage = json['coverImage'] == null
        ? null
        : ListItemAnimeMixin$CoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..coverColor = json['coverColor'] as String
    ..bannerImage = json['bannerImage'] as String
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : ListItemAnimeMixin$Genres.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..recommendationPivot = json['recommendationPivot'] == null
        ? null
        : GetAnimeDetailsFull$Query$Anime$Recommendations$Data$RecommendationPivot
            .fromJson(json['recommendationPivot'] as Map<String, dynamic>);
}

Map<String, dynamic>
    _$GetAnimeDetailsFull$Query$Anime$Recommendations$DataToJson(
            GetAnimeDetailsFull$Query$Anime$Recommendations$Data instance) =>
        <String, dynamic>{
          'id': instance.id,
          'name': instance.name,
          'animeType': _$AnimeTypeEnumMap[instance.animeType],
          'rating': instance.rating,
          'coverImage': instance.coverImage?.toJson(),
          'coverColor': instance.coverColor,
          'bannerImage': instance.bannerImage,
          'genres': instance.genres?.map((e) => e?.toJson())?.toList(),
          'recommendationPivot': instance.recommendationPivot?.toJson(),
        };

GetAnimeDetailsFull$Query$Anime$Recommendations
    _$GetAnimeDetailsFull$Query$Anime$RecommendationsFromJson(
        Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query$Anime$Recommendations()
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : GetAnimeDetailsFull$Query$Anime$Recommendations$Data.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetAnimeDetailsFull$Query$Anime$RecommendationsToJson(
        GetAnimeDetailsFull$Query$Anime$Recommendations instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };

GetAnimeDetailsFull$Query$Anime _$GetAnimeDetailsFull$Query$AnimeFromJson(
    Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query$Anime()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..animeType = _$enumDecodeNullable(_$AnimeTypeEnumMap, json['animeType'],
        unknownValue: AnimeType.artemisUnknown)
    ..rating = json['rating'] as int
    ..coverImage = json['coverImage'] == null
        ? null
        : ListItemAnimeMixin$CoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..coverColor = json['coverColor'] as String
    ..bannerImage = json['bannerImage'] as String
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : ListItemAnimeMixin$Genres.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..description = json['description'] as String
    ..anilist = fromGraphQLAnilistMediaToDartGraphqlAnilistApi$Query$Media(
        json['anilist'] as String)
    ..relations = json['relations'] == null
        ? null
        : GetAnimeDetailsFull$Query$Anime$Relations.fromJson(
            json['relations'] as Map<String, dynamic>)
    ..recommendations = json['recommendations'] == null
        ? null
        : GetAnimeDetailsFull$Query$Anime$Recommendations.fromJson(
            json['recommendations'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeDetailsFull$Query$AnimeToJson(
        GetAnimeDetailsFull$Query$Anime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'animeType': _$AnimeTypeEnumMap[instance.animeType],
      'rating': instance.rating,
      'coverImage': instance.coverImage?.toJson(),
      'coverColor': instance.coverColor,
      'bannerImage': instance.bannerImage,
      'genres': instance.genres?.map((e) => e?.toJson())?.toList(),
      'description': instance.description,
      'anilist': fromDartGraphqlAnilistApi$Query$MediaToGraphQLAnilistMedia(
          instance.anilist),
      'relations': instance.relations?.toJson(),
      'recommendations': instance.recommendations?.toJson(),
    };

GetAnimeDetailsFull$Query _$GetAnimeDetailsFull$QueryFromJson(
    Map<String, dynamic> json) {
  return GetAnimeDetailsFull$Query()
    ..anime = json['anime'] == null
        ? null
        : GetAnimeDetailsFull$Query$Anime.fromJson(
            json['anime'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeDetailsFull$QueryToJson(
        GetAnimeDetailsFull$Query instance) =>
    <String, dynamic>{
      'anime': instance.anime?.toJson(),
    };

GetAnimeEpisodes$Query$Episodes$PaginatorInfo
    _$GetAnimeEpisodes$Query$Episodes$PaginatorInfoFromJson(
        Map<String, dynamic> json) {
  return GetAnimeEpisodes$Query$Episodes$PaginatorInfo()
    ..total = json['total'] as int
    ..lastPage = json['lastPage'] as int
    ..hasMorePages = json['hasMorePages'] as bool
    ..currentPage = json['currentPage'] as int;
}

Map<String, dynamic> _$GetAnimeEpisodes$Query$Episodes$PaginatorInfoToJson(
        GetAnimeEpisodes$Query$Episodes$PaginatorInfo instance) =>
    <String, dynamic>{
      'total': instance.total,
      'lastPage': instance.lastPage,
      'hasMorePages': instance.hasMorePages,
      'currentPage': instance.currentPage,
    };

GetAnimeEpisodes$Query$Episodes$Data$Releases
    _$GetAnimeEpisodes$Query$Episodes$Data$ReleasesFromJson(
        Map<String, dynamic> json) {
  return GetAnimeEpisodes$Query$Episodes$Data$Releases()
    ..id = json['id'] as String
    ..url = json['url'] as String
    ..type = json['type'] as String
    ..resolution = json['resolution'] as int
    ..group = json['group'] as String;
}

Map<String, dynamic> _$GetAnimeEpisodes$Query$Episodes$Data$ReleasesToJson(
        GetAnimeEpisodes$Query$Episodes$Data$Releases instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': instance.type,
      'resolution': instance.resolution,
      'group': instance.group,
    };

GetAnimeEpisodes$Query$Episodes$Data
    _$GetAnimeEpisodes$Query$Episodes$DataFromJson(Map<String, dynamic> json) {
  return GetAnimeEpisodes$Query$Episodes$Data()
    ..id = json['id'] as String
    ..number = json['number'] as int
    ..releases = (json['releases'] as List)
        ?.map((e) => e == null
            ? null
            : GetAnimeEpisodes$Query$Episodes$Data$Releases.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetAnimeEpisodes$Query$Episodes$DataToJson(
        GetAnimeEpisodes$Query$Episodes$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'releases': instance.releases?.map((e) => e?.toJson())?.toList(),
    };

GetAnimeEpisodes$Query$Episodes _$GetAnimeEpisodes$Query$EpisodesFromJson(
    Map<String, dynamic> json) {
  return GetAnimeEpisodes$Query$Episodes()
    ..paginatorInfo = json['paginatorInfo'] == null
        ? null
        : GetAnimeEpisodes$Query$Episodes$PaginatorInfo.fromJson(
            json['paginatorInfo'] as Map<String, dynamic>)
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : GetAnimeEpisodes$Query$Episodes$Data.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetAnimeEpisodes$Query$EpisodesToJson(
        GetAnimeEpisodes$Query$Episodes instance) =>
    <String, dynamic>{
      'paginatorInfo': instance.paginatorInfo?.toJson(),
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };

GetAnimeEpisodes$Query _$GetAnimeEpisodes$QueryFromJson(
    Map<String, dynamic> json) {
  return GetAnimeEpisodes$Query()
    ..episodes = json['episodes'] == null
        ? null
        : GetAnimeEpisodes$Query$Episodes.fromJson(
            json['episodes'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetAnimeEpisodes$QueryToJson(
        GetAnimeEpisodes$Query instance) =>
    <String, dynamic>{
      'episodes': instance.episodes?.toJson(),
    };

EpisodesHasAnimeWhereConditions _$EpisodesHasAnimeWhereConditionsFromJson(
    Map<String, dynamic> json) {
  return EpisodesHasAnimeWhereConditions(
    column: _$enumDecodeNullable(
        _$EpisodesHasAnimeColumnEnumMap, json['column'],
        unknownValue: EpisodesHasAnimeColumn.artemisUnknown),
    kw$operator: _$enumDecodeNullable(_$SQLOperatorEnumMap, json['operator'],
        unknownValue: SQLOperator.artemisUnknown),
    value: json['value'] as String,
    and: (json['AND'] as List)
        ?.map((e) => e == null
            ? null
            : EpisodesHasAnimeWhereConditions.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
    or: (json['OR'] as List)
        ?.map((e) => e == null
            ? null
            : EpisodesHasAnimeWhereConditions.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EpisodesHasAnimeWhereConditionsToJson(
        EpisodesHasAnimeWhereConditions instance) =>
    <String, dynamic>{
      'column': _$EpisodesHasAnimeColumnEnumMap[instance.column],
      'operator': _$SQLOperatorEnumMap[instance.kw$operator],
      'value': instance.value,
      'AND': instance.and?.map((e) => e?.toJson())?.toList(),
      'OR': instance.or?.map((e) => e?.toJson())?.toList(),
    };

const _$EpisodesHasAnimeColumnEnumMap = {
  EpisodesHasAnimeColumn.id: 'ID',
  EpisodesHasAnimeColumn.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

EpisodesOrderByOrderByClause _$EpisodesOrderByOrderByClauseFromJson(
    Map<String, dynamic> json) {
  return EpisodesOrderByOrderByClause(
    field: _$enumDecodeNullable(_$EpisodesOrderByColumnEnumMap, json['field'],
        unknownValue: EpisodesOrderByColumn.artemisUnknown),
    order: _$enumDecodeNullable(_$SortOrderEnumMap, json['order'],
        unknownValue: SortOrder.artemisUnknown),
  );
}

Map<String, dynamic> _$EpisodesOrderByOrderByClauseToJson(
        EpisodesOrderByOrderByClause instance) =>
    <String, dynamic>{
      'field': _$EpisodesOrderByColumnEnumMap[instance.field],
      'order': _$SortOrderEnumMap[instance.order],
    };

const _$EpisodesOrderByColumnEnumMap = {
  EpisodesOrderByColumn.number: 'NUMBER',
  EpisodesOrderByColumn.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GetFeatured$Query _$GetFeatured$QueryFromJson(Map<String, dynamic> json) {
  return GetFeatured$Query()..featured = json['featured'] as String;
}

Map<String, dynamic> _$GetFeatured$QueryToJson(GetFeatured$Query instance) =>
    <String, dynamic>{
      'featured': instance.featured,
    };

GetGenres$Query$Genres _$GetGenres$Query$GenresFromJson(
    Map<String, dynamic> json) {
  return GetGenres$Query$Genres()
    ..id = json['id'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$GetGenres$Query$GenresToJson(
        GetGenres$Query$Genres instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

GetGenres$Query _$GetGenres$QueryFromJson(Map<String, dynamic> json) {
  return GetGenres$Query()
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : GetGenres$Query$Genres.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetGenres$QueryToJson(GetGenres$Query instance) =>
    <String, dynamic>{
      'genres': instance.genres?.map((e) => e?.toJson())?.toList(),
    };

BrowseAnimesArguments _$BrowseAnimesArgumentsFromJson(
    Map<String, dynamic> json) {
  return BrowseAnimesArguments(
    first: json['first'] as int,
    page: json['page'] as int,
    orderBy: (json['orderBy'] as List)
        ?.map((e) => e == null
            ? null
            : AnimesOrderByOrderByClause.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    hasGenres: json['hasGenres'] == null
        ? null
        : AnimesHasGenresWhereConditions.fromJson(
            json['hasGenres'] as Map<String, dynamic>),
    typeIn: (json['typeIn'] as List)
        ?.map((e) => _$enumDecodeNullable(_$AnimeTypeEnumMap, e))
        ?.toList(),
  );
}

Map<String, dynamic> _$BrowseAnimesArgumentsToJson(
        BrowseAnimesArguments instance) =>
    <String, dynamic>{
      'first': instance.first,
      'page': instance.page,
      'orderBy': instance.orderBy?.map((e) => e?.toJson())?.toList(),
      'hasGenres': instance.hasGenres?.toJson(),
      'typeIn': instance.typeIn?.map((e) => _$AnimeTypeEnumMap[e])?.toList(),
    };

GetAnimeDetailsArguments _$GetAnimeDetailsArgumentsFromJson(
    Map<String, dynamic> json) {
  return GetAnimeDetailsArguments(
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$GetAnimeDetailsArgumentsToJson(
        GetAnimeDetailsArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

GetAnimeDetailsFullArguments _$GetAnimeDetailsFullArgumentsFromJson(
    Map<String, dynamic> json) {
  return GetAnimeDetailsFullArguments(
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$GetAnimeDetailsFullArgumentsToJson(
        GetAnimeDetailsFullArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

GetAnimeEpisodesArguments _$GetAnimeEpisodesArgumentsFromJson(
    Map<String, dynamic> json) {
  return GetAnimeEpisodesArguments(
    hasAnime: json['hasAnime'] == null
        ? null
        : EpisodesHasAnimeWhereConditions.fromJson(
            json['hasAnime'] as Map<String, dynamic>),
    orderBy: (json['orderBy'] as List)
        ?.map((e) => e == null
            ? null
            : EpisodesOrderByOrderByClause.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    first: json['first'] as int,
    page: json['page'] as int,
  );
}

Map<String, dynamic> _$GetAnimeEpisodesArgumentsToJson(
        GetAnimeEpisodesArguments instance) =>
    <String, dynamic>{
      'hasAnime': instance.hasAnime?.toJson(),
      'orderBy': instance.orderBy?.map((e) => e?.toJson())?.toList(),
      'first': instance.first,
      'page': instance.page,
    };
