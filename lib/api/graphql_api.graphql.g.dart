// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowseAnimes$Query$AnimePaginator$PaginatorInfo
    _$BrowseAnimes$Query$AnimePaginator$PaginatorInfoFromJson(
        Map<String, dynamic> json) {
  return BrowseAnimes$Query$AnimePaginator$PaginatorInfo()
    ..total = json['total'] as int
    ..lastPage = json['lastPage'] as int
    ..hasMorePages = json['hasMorePages'] as bool
    ..currentPage = json['currentPage'] as int;
}

Map<String, dynamic> _$BrowseAnimes$Query$AnimePaginator$PaginatorInfoToJson(
        BrowseAnimes$Query$AnimePaginator$PaginatorInfo instance) =>
    <String, dynamic>{
      'total': instance.total,
      'lastPage': instance.lastPage,
      'hasMorePages': instance.hasMorePages,
      'currentPage': instance.currentPage,
    };

BrowseAnimes$Query$AnimePaginator$Anime$Translatable
    _$BrowseAnimes$Query$AnimePaginator$Anime$TranslatableFromJson(
        Map<String, dynamic> json) {
  return BrowseAnimes$Query$AnimePaginator$Anime$Translatable()
    ..en = json['en'] as String
    ..mn = json['mn'] as String;
}

Map<String, dynamic>
    _$BrowseAnimes$Query$AnimePaginator$Anime$TranslatableToJson(
            BrowseAnimes$Query$AnimePaginator$Anime$Translatable instance) =>
        <String, dynamic>{
          'en': instance.en,
          'mn': instance.mn,
        };

BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage
    _$BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImageFromJson(
        Map<String, dynamic> json) {
  return BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage()
    ..large = json['large'] as String;
}

Map<String, dynamic>
    _$BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImageToJson(
            BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage instance) =>
        <String, dynamic>{
          'large': instance.large,
        };

BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable
    _$BrowseAnimes$Query$AnimePaginator$Anime$Genre$TranslatableFromJson(
        Map<String, dynamic> json) {
  return BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable()
    ..en = json['en'] as String
    ..mn = json['mn'] as String;
}

Map<String,
    dynamic> _$BrowseAnimes$Query$AnimePaginator$Anime$Genre$TranslatableToJson(
        BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable instance) =>
    <String, dynamic>{
      'en': instance.en,
      'mn': instance.mn,
    };

BrowseAnimes$Query$AnimePaginator$Anime$Genre
    _$BrowseAnimes$Query$AnimePaginator$Anime$GenreFromJson(
        Map<String, dynamic> json) {
  return BrowseAnimes$Query$AnimePaginator$Anime$Genre()
    ..id = json['id'] as String
    ..name = json['name'] == null
        ? null
        : BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable.fromJson(
            json['name'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BrowseAnimes$Query$AnimePaginator$Anime$GenreToJson(
        BrowseAnimes$Query$AnimePaginator$Anime$Genre instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name?.toJson(),
    };

BrowseAnimes$Query$AnimePaginator$Anime
    _$BrowseAnimes$Query$AnimePaginator$AnimeFromJson(
        Map<String, dynamic> json) {
  return BrowseAnimes$Query$AnimePaginator$Anime()
    ..id = json['id'] as String
    ..name = json['name'] == null
        ? null
        : BrowseAnimes$Query$AnimePaginator$Anime$Translatable.fromJson(
            json['name'] as Map<String, dynamic>)
    ..animeType = _$enumDecodeNullable(_$AnimeTypeEnumMap, json['animeType'],
        unknownValue: AnimeType.artemisUnknown)
    ..rating = json['rating'] as int
    ..coverImage = json['coverImage'] == null
        ? null
        : BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..coverColor = json['coverColor'] as String
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : BrowseAnimes$Query$AnimePaginator$Anime$Genre.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BrowseAnimes$Query$AnimePaginator$AnimeToJson(
        BrowseAnimes$Query$AnimePaginator$Anime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name?.toJson(),
      'animeType': _$AnimeTypeEnumMap[instance.animeType],
      'rating': instance.rating,
      'coverImage': instance.coverImage?.toJson(),
      'coverColor': instance.coverColor,
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

BrowseAnimes$Query$AnimePaginator _$BrowseAnimes$Query$AnimePaginatorFromJson(
    Map<String, dynamic> json) {
  return BrowseAnimes$Query$AnimePaginator()
    ..paginatorInfo = json['paginatorInfo'] == null
        ? null
        : BrowseAnimes$Query$AnimePaginator$PaginatorInfo.fromJson(
            json['paginatorInfo'] as Map<String, dynamic>)
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : BrowseAnimes$Query$AnimePaginator$Anime.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BrowseAnimes$Query$AnimePaginatorToJson(
        BrowseAnimes$Query$AnimePaginator instance) =>
    <String, dynamic>{
      'paginatorInfo': instance.paginatorInfo?.toJson(),
      'data': instance.data?.map((e) => e?.toJson())?.toList(),
    };

BrowseAnimes$Query _$BrowseAnimes$QueryFromJson(Map<String, dynamic> json) {
  return BrowseAnimes$Query()
    ..animes = json['animes'] == null
        ? null
        : BrowseAnimes$Query$AnimePaginator.fromJson(
            json['animes'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BrowseAnimes$QueryToJson(BrowseAnimes$Query instance) =>
    <String, dynamic>{
      'animes': instance.animes?.toJson(),
    };

AnimesHasGenresWhereConditions _$AnimesHasGenresWhereConditionsFromJson(
    Map<String, dynamic> json) {
  return AnimesHasGenresWhereConditions(
    column: _$enumDecodeNullable(_$AnimesHasGenresColumnEnumMap, json['column'],
        unknownValue: AnimesHasGenresColumn.artemisUnknown),
    kw$operator: _$enumDecodeNullable(
        _$SQLOperatorEnumMap, json[r'kw$operator'],
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

GetGenres$Query$Genre$Translatable _$GetGenres$Query$Genre$TranslatableFromJson(
    Map<String, dynamic> json) {
  return GetGenres$Query$Genre$Translatable()
    ..en = json['en'] as String
    ..mn = json['mn'] as String;
}

Map<String, dynamic> _$GetGenres$Query$Genre$TranslatableToJson(
        GetGenres$Query$Genre$Translatable instance) =>
    <String, dynamic>{
      'en': instance.en,
      'mn': instance.mn,
    };

GetGenres$Query$Genre _$GetGenres$Query$GenreFromJson(
    Map<String, dynamic> json) {
  return GetGenres$Query$Genre()
    ..id = json['id'] as String
    ..name = json['name'] == null
        ? null
        : GetGenres$Query$Genre$Translatable.fromJson(
            json['name'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetGenres$Query$GenreToJson(
        GetGenres$Query$Genre instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name?.toJson(),
    };

GetGenres$Query _$GetGenres$QueryFromJson(Map<String, dynamic> json) {
  return GetGenres$Query()
    ..genres = (json['genres'] as List)
        ?.map((e) => e == null
            ? null
            : GetGenres$Query$Genre.fromJson(e as Map<String, dynamic>))
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
