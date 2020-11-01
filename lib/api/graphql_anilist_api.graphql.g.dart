// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_anilist_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphqlAnilistApi$Query$Media$MediaTitle
    _$GraphqlAnilistApi$Query$Media$MediaTitleFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaTitle()
    ..romaji = json['romaji'] as String
    ..english = json['english'] as String
    ..native = json['native'] as String
    ..userPreferred = json['userPreferred'] as String;
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$MediaTitleToJson(
        GraphqlAnilistApi$Query$Media$MediaTitle instance) =>
    <String, dynamic>{
      'romaji': instance.romaji,
      'english': instance.english,
      'native': instance.native,
      'userPreferred': instance.userPreferred,
    };

GraphqlAnilistApi$Query$Media$FuzzyDate
    _$GraphqlAnilistApi$Query$Media$FuzzyDateFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$FuzzyDate()
    ..year = json['year'] as int
    ..month = json['month'] as int
    ..day = json['day'] as int;
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$FuzzyDateToJson(
        GraphqlAnilistApi$Query$Media$FuzzyDate instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
    };

GraphqlAnilistApi$Query$Media$MediaTrailer
    _$GraphqlAnilistApi$Query$Media$MediaTrailerFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaTrailer()
    ..id = json['id'] as String
    ..site = json['site'] as String
    ..thumbnail = json['thumbnail'] as String;
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$MediaTrailerToJson(
        GraphqlAnilistApi$Query$Media$MediaTrailer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'site': instance.site,
      'thumbnail': instance.thumbnail,
    };

GraphqlAnilistApi$Query$Media$MediaCoverImage
    _$GraphqlAnilistApi$Query$Media$MediaCoverImageFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaCoverImage()
    ..extraLarge = json['extraLarge'] as String
    ..large = json['large'] as String
    ..medium = json['medium'] as String
    ..color = json['color'] as String;
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$MediaCoverImageToJson(
        GraphqlAnilistApi$Query$Media$MediaCoverImage instance) =>
    <String, dynamic>{
      'extraLarge': instance.extraLarge,
      'large': instance.large,
      'medium': instance.medium,
      'color': instance.color,
    };

GraphqlAnilistApi$Query$Media$MediaTag
    _$GraphqlAnilistApi$Query$Media$MediaTagFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaTag()
    ..id = json['id'] as int
    ..name = json['name'] as String;
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$MediaTagToJson(
        GraphqlAnilistApi$Query$Media$MediaTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

GraphqlAnilistApi$Query$Media$StudioConnection$Studio
    _$GraphqlAnilistApi$Query$Media$StudioConnection$StudioFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$StudioConnection$Studio()
    ..name = json['name'] as String;
}

Map<String, dynamic>
    _$GraphqlAnilistApi$Query$Media$StudioConnection$StudioToJson(
            GraphqlAnilistApi$Query$Media$StudioConnection$Studio instance) =>
        <String, dynamic>{
          'name': instance.name,
        };

GraphqlAnilistApi$Query$Media$StudioConnection
    _$GraphqlAnilistApi$Query$Media$StudioConnectionFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$StudioConnection()
    ..nodes = (json['nodes'] as List)
        ?.map((e) => e == null
            ? null
            : GraphqlAnilistApi$Query$Media$StudioConnection$Studio.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$StudioConnectionToJson(
        GraphqlAnilistApi$Query$Media$StudioConnection instance) =>
    <String, dynamic>{
      'nodes': instance.nodes?.map((e) => e?.toJson())?.toList(),
    };

GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media
    _$GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$MediaFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media()
    ..id = json['id'] as int;
}

Map<String, dynamic>
    _$GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$MediaToJson(
            GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media
                instance) =>
        <String, dynamic>{
          'id': instance.id,
        };

GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation
    _$GraphqlAnilistApi$Query$Media$RecommendationConnection$RecommendationFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation()
    ..rating = json['rating'] as int
    ..mediaRecommendation = json['mediaRecommendation'] == null
        ? null
        : GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media
            .fromJson(json['mediaRecommendation'] as Map<String, dynamic>);
}

Map<String, dynamic>
    _$GraphqlAnilistApi$Query$Media$RecommendationConnection$RecommendationToJson(
            GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation
                instance) =>
        <String, dynamic>{
          'rating': instance.rating,
          'mediaRecommendation': instance.mediaRecommendation?.toJson(),
        };

GraphqlAnilistApi$Query$Media$RecommendationConnection
    _$GraphqlAnilistApi$Query$Media$RecommendationConnectionFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$RecommendationConnection()
    ..nodes = (json['nodes'] as List)
        ?.map((e) => e == null
            ? null
            : GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation
                .fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic>
    _$GraphqlAnilistApi$Query$Media$RecommendationConnectionToJson(
            GraphqlAnilistApi$Query$Media$RecommendationConnection instance) =>
        <String, dynamic>{
          'nodes': instance.nodes?.map((e) => e?.toJson())?.toList(),
        };

GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media
    _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$MediaFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media()
    ..id = json['id'] as int;
}

Map<String, dynamic>
    _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$MediaToJson(
            GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media
                instance) =>
        <String, dynamic>{
          'id': instance.id,
        };

GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge
    _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdgeFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge()
    ..id = json['id'] as int
    ..relationType = _$enumDecodeNullable(
        _$MediaRelationEnumMap, json['relationType'],
        unknownValue: MediaRelation.artemisUnknown)
    ..node = json['node'] == null
        ? null
        : GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media
            .fromJson(json['node'] as Map<String, dynamic>);
}

Map<String, dynamic>
    _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdgeToJson(
            GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge instance) =>
        <String, dynamic>{
          'id': instance.id,
          'relationType': _$MediaRelationEnumMap[instance.relationType],
          'node': instance.node?.toJson(),
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

const _$MediaRelationEnumMap = {
  MediaRelation.adaptation: 'ADAPTATION',
  MediaRelation.prequel: 'PREQUEL',
  MediaRelation.sequel: 'SEQUEL',
  MediaRelation.parent: 'PARENT',
  MediaRelation.sideStory: 'SIDE_STORY',
  MediaRelation.character: 'CHARACTER',
  MediaRelation.summary: 'SUMMARY',
  MediaRelation.alternative: 'ALTERNATIVE',
  MediaRelation.spinOff: 'SPIN_OFF',
  MediaRelation.other: 'OTHER',
  MediaRelation.source: 'SOURCE',
  MediaRelation.compilation: 'COMPILATION',
  MediaRelation.contains: 'CONTAINS',
  MediaRelation.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GraphqlAnilistApi$Query$Media$MediaConnection
    _$GraphqlAnilistApi$Query$Media$MediaConnectionFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaConnection()
    ..edges = (json['edges'] as List)
        ?.map((e) => e == null
            ? null
            : GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$MediaConnectionToJson(
        GraphqlAnilistApi$Query$Media$MediaConnection instance) =>
    <String, dynamic>{
      'edges': instance.edges?.map((e) => e?.toJson())?.toList(),
    };

GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution
    _$GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistributionFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution()
    ..score = json['score'] as int
    ..amount = json['amount'] as int;
}

Map<String,
    dynamic> _$GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistributionToJson(
        GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution instance) =>
    <String, dynamic>{
      'score': instance.score,
      'amount': instance.amount,
    };

GraphqlAnilistApi$Query$Media$MediaStats
    _$GraphqlAnilistApi$Query$Media$MediaStatsFromJson(
        Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media$MediaStats()
    ..scoreDistribution = (json['scoreDistribution'] as List)
        ?.map((e) => e == null
            ? null
            : GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution
                .fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$Media$MediaStatsToJson(
        GraphqlAnilistApi$Query$Media$MediaStats instance) =>
    <String, dynamic>{
      'scoreDistribution':
          instance.scoreDistribution?.map((e) => e?.toJson())?.toList(),
    };

GraphqlAnilistApi$Query$Media _$GraphqlAnilistApi$Query$MediaFromJson(
    Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query$Media()
    ..id = json['id'] as int
    ..idMal = json['idMal'] as int
    ..title = json['title'] == null
        ? null
        : GraphqlAnilistApi$Query$Media$MediaTitle.fromJson(
            json['title'] as Map<String, dynamic>)
    ..type = _$enumDecodeNullable(_$MediaTypeEnumMap, json['type'],
        unknownValue: MediaType.artemisUnknown)
    ..format = _$enumDecodeNullable(_$MediaFormatEnumMap, json['format'],
        unknownValue: MediaFormat.artemisUnknown)
    ..status = _$enumDecodeNullable(_$MediaStatusEnumMap, json['status'],
        unknownValue: MediaStatus.artemisUnknown)
    ..description = json['description'] as String
    ..startDate = json['startDate'] == null
        ? null
        : GraphqlAnilistApi$Query$Media$FuzzyDate.fromJson(
            json['startDate'] as Map<String, dynamic>)
    ..endDate = json['endDate'] == null
        ? null
        : GraphqlAnilistApi$Query$Media$FuzzyDate.fromJson(
            json['endDate'] as Map<String, dynamic>)
    ..season = _$enumDecodeNullable(_$MediaSeasonEnumMap, json['season'],
        unknownValue: MediaSeason.artemisUnknown)
    ..seasonYear = json['seasonYear'] as int
    ..seasonInt = json['seasonInt'] as int
    ..episodes = json['episodes'] as int
    ..duration = json['duration'] as int
    ..countryOfOrigin = json['countryOfOrigin'] as String
    ..hashtag = json['hashtag'] as String
    ..trailer = json['trailer'] == null
        ? null
        : GraphqlAnilistApi$Query$Media$MediaTrailer.fromJson(
            json['trailer'] as Map<String, dynamic>)
    ..coverImage = json['coverImage'] == null
        ? null
        : GraphqlAnilistApi$Query$Media$MediaCoverImage.fromJson(
            json['coverImage'] as Map<String, dynamic>)
    ..bannerImage = json['bannerImage'] as String
    ..genres = (json['genres'] as List)?.map((e) => e as String)?.toList()
    ..synonyms = (json['synonyms'] as List)?.map((e) => e as String)?.toList()
    ..averageScore = json['averageScore'] as int
    ..meanScore = json['meanScore'] as int
    ..popularity = json['popularity'] as int
    ..trending = json['trending'] as int
    ..favourites = json['favourites'] as int
    ..tags = (json['tags'] as List)
        ?.map((e) => e == null ? null : GraphqlAnilistApi$Query$Media$MediaTag.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..studios = json['studios'] == null ? null : GraphqlAnilistApi$Query$Media$StudioConnection.fromJson(json['studios'] as Map<String, dynamic>)
    ..isAdult = json['isAdult'] as bool
    ..recommendations = json['recommendations'] == null ? null : GraphqlAnilistApi$Query$Media$RecommendationConnection.fromJson(json['recommendations'] as Map<String, dynamic>)
    ..siteUrl = json['siteUrl'] as String
    ..relations = json['relations'] == null ? null : GraphqlAnilistApi$Query$Media$MediaConnection.fromJson(json['relations'] as Map<String, dynamic>)
    ..stats = json['stats'] == null ? null : GraphqlAnilistApi$Query$Media$MediaStats.fromJson(json['stats'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GraphqlAnilistApi$Query$MediaToJson(
        GraphqlAnilistApi$Query$Media instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idMal': instance.idMal,
      'title': instance.title?.toJson(),
      'type': _$MediaTypeEnumMap[instance.type],
      'format': _$MediaFormatEnumMap[instance.format],
      'status': _$MediaStatusEnumMap[instance.status],
      'description': instance.description,
      'startDate': instance.startDate?.toJson(),
      'endDate': instance.endDate?.toJson(),
      'season': _$MediaSeasonEnumMap[instance.season],
      'seasonYear': instance.seasonYear,
      'seasonInt': instance.seasonInt,
      'episodes': instance.episodes,
      'duration': instance.duration,
      'countryOfOrigin': instance.countryOfOrigin,
      'hashtag': instance.hashtag,
      'trailer': instance.trailer?.toJson(),
      'coverImage': instance.coverImage?.toJson(),
      'bannerImage': instance.bannerImage,
      'genres': instance.genres,
      'synonyms': instance.synonyms,
      'averageScore': instance.averageScore,
      'meanScore': instance.meanScore,
      'popularity': instance.popularity,
      'trending': instance.trending,
      'favourites': instance.favourites,
      'tags': instance.tags?.map((e) => e?.toJson())?.toList(),
      'studios': instance.studios?.toJson(),
      'isAdult': instance.isAdult,
      'recommendations': instance.recommendations?.toJson(),
      'siteUrl': instance.siteUrl,
      'relations': instance.relations?.toJson(),
      'stats': instance.stats?.toJson(),
    };

const _$MediaTypeEnumMap = {
  MediaType.anime: 'ANIME',
  MediaType.manga: 'MANGA',
  MediaType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$MediaFormatEnumMap = {
  MediaFormat.tv: 'TV',
  MediaFormat.tvShort: 'TV_SHORT',
  MediaFormat.movie: 'MOVIE',
  MediaFormat.special: 'SPECIAL',
  MediaFormat.ova: 'OVA',
  MediaFormat.ona: 'ONA',
  MediaFormat.music: 'MUSIC',
  MediaFormat.manga: 'MANGA',
  MediaFormat.novel: 'NOVEL',
  MediaFormat.oneShot: 'ONE_SHOT',
  MediaFormat.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$MediaStatusEnumMap = {
  MediaStatus.finished: 'FINISHED',
  MediaStatus.releasing: 'RELEASING',
  MediaStatus.notYetReleased: 'NOT_YET_RELEASED',
  MediaStatus.cancelled: 'CANCELLED',
  MediaStatus.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$MediaSeasonEnumMap = {
  MediaSeason.winter: 'WINTER',
  MediaSeason.spring: 'SPRING',
  MediaSeason.summer: 'SUMMER',
  MediaSeason.fall: 'FALL',
  MediaSeason.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GraphqlAnilistApi$Query _$GraphqlAnilistApi$QueryFromJson(
    Map<String, dynamic> json) {
  return GraphqlAnilistApi$Query()
    ..media = json['Media'] == null
        ? null
        : GraphqlAnilistApi$Query$Media.fromJson(
            json['Media'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GraphqlAnilistApi$QueryToJson(
        GraphqlAnilistApi$Query instance) =>
    <String, dynamic>{
      'Media': instance.media?.toJson(),
    };

GraphqlAnilistApiArguments _$GraphqlAnilistApiArgumentsFromJson(
    Map<String, dynamic> json) {
  return GraphqlAnilistApiArguments(
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$GraphqlAnilistApiArgumentsToJson(
        GraphqlAnilistApiArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
