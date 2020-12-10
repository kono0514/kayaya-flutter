// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:meta/meta.dart';
import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
import 'package:kayaya_flutter/codegen/graphql_anilist_api.graphql.dart';
import 'package:kayaya_flutter/codegen/coercers.dart';
part 'graphql_api.graphql.g.dart';

mixin AnimeItemWithGenresFieldsMixin {
  String id;
  String name;
  @JsonKey(unknownEnumValue: AnimeType.artemisUnknown)
  AnimeType animeType;
  int rating;
  AnimeItemWithGenresFieldsMixin$CoverImage coverImage;
  String coverColor;
  String bannerImage;
  List<AnimeItemWithGenresFieldsMixin$Genres> genres;
}
mixin GenreFieldsMixin {
  String id;
  String name;
}
mixin AnimeDetailsFieldsMixin {
  String id;
  String description;
  @JsonKey(
      fromJson: fromGraphQLAnilistMediaToDartGraphqlAnilistApi$Query$Media,
      toJson: fromDartGraphqlAnilistApi$Query$MediaToGraphQLAnilistMedia)
  GraphqlAnilistApi$Query$Media anilist;
  List<AnimeDetailsFieldsMixin$Genres> genres;
}
mixin AnimeItemFieldsMixin {
  String id;
  String name;
  @JsonKey(unknownEnumValue: AnimeType.artemisUnknown)
  AnimeType animeType;
  int rating;
  AnimeItemFieldsMixin$CoverImage coverImage;
  String coverColor;
  String bannerImage;
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$Animes$PaginatorInfo with EquatableMixin {
  BrowseAnimes$Query$Animes$PaginatorInfo();

  factory BrowseAnimes$Query$Animes$PaginatorInfo.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$Animes$PaginatorInfoFromJson(json);

  int total;

  int lastPage;

  bool hasMorePages;

  int currentPage;

  @override
  List<Object> get props => [total, lastPage, hasMorePages, currentPage];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$Animes$PaginatorInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$Animes$Data
    with EquatableMixin, AnimeItemWithGenresFieldsMixin {
  BrowseAnimes$Query$Animes$Data();

  factory BrowseAnimes$Query$Animes$Data.fromJson(Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$Animes$DataFromJson(json);

  @override
  List<Object> get props => [
        id,
        name,
        animeType,
        rating,
        coverImage,
        coverColor,
        bannerImage,
        genres
      ];
  Map<String, dynamic> toJson() => _$BrowseAnimes$Query$Animes$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$Animes with EquatableMixin {
  BrowseAnimes$Query$Animes();

  factory BrowseAnimes$Query$Animes.fromJson(Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimesFromJson(json);

  BrowseAnimes$Query$Animes$PaginatorInfo paginatorInfo;

  List<BrowseAnimes$Query$Animes$Data> data;

  @override
  List<Object> get props => [paginatorInfo, data];
  Map<String, dynamic> toJson() => _$BrowseAnimes$Query$AnimesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query with EquatableMixin {
  BrowseAnimes$Query();

  factory BrowseAnimes$Query.fromJson(Map<String, dynamic> json) =>
      _$BrowseAnimes$QueryFromJson(json);

  BrowseAnimes$Query$Animes animes;

  @override
  List<Object> get props => [animes];
  Map<String, dynamic> toJson() => _$BrowseAnimes$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimeItemWithGenresFieldsMixin$CoverImage with EquatableMixin {
  AnimeItemWithGenresFieldsMixin$CoverImage();

  factory AnimeItemWithGenresFieldsMixin$CoverImage.fromJson(
          Map<String, dynamic> json) =>
      _$AnimeItemWithGenresFieldsMixin$CoverImageFromJson(json);

  String large;

  @override
  List<Object> get props => [large];
  Map<String, dynamic> toJson() =>
      _$AnimeItemWithGenresFieldsMixin$CoverImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimeItemWithGenresFieldsMixin$Genres
    with EquatableMixin, GenreFieldsMixin {
  AnimeItemWithGenresFieldsMixin$Genres();

  factory AnimeItemWithGenresFieldsMixin$Genres.fromJson(
          Map<String, dynamic> json) =>
      _$AnimeItemWithGenresFieldsMixin$GenresFromJson(json);

  @override
  List<Object> get props => [id, name];
  Map<String, dynamic> toJson() =>
      _$AnimeItemWithGenresFieldsMixin$GenresToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimesHasGenresWhereConditions with EquatableMixin {
  AnimesHasGenresWhereConditions(
      {this.column, this.kw$operator, this.value, this.and, this.or});

  factory AnimesHasGenresWhereConditions.fromJson(Map<String, dynamic> json) =>
      _$AnimesHasGenresWhereConditionsFromJson(json);

  @JsonKey(unknownEnumValue: AnimesHasGenresColumn.artemisUnknown)
  AnimesHasGenresColumn column;

  @JsonKey(name: 'operator', unknownEnumValue: SQLOperator.artemisUnknown)
  SQLOperator kw$operator;

  String value;

  @JsonKey(name: 'AND')
  List<AnimesHasGenresWhereConditions> and;

  @JsonKey(name: 'OR')
  List<AnimesHasGenresWhereConditions> or;

  @override
  List<Object> get props => [column, kw$operator, value, and, or];
  Map<String, dynamic> toJson() => _$AnimesHasGenresWhereConditionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimesOrderByOrderByClause with EquatableMixin {
  AnimesOrderByOrderByClause({@required this.field, @required this.order});

  factory AnimesOrderByOrderByClause.fromJson(Map<String, dynamic> json) =>
      _$AnimesOrderByOrderByClauseFromJson(json);

  @JsonKey(unknownEnumValue: AnimeOrderColumns.artemisUnknown)
  AnimeOrderColumns field;

  @JsonKey(unknownEnumValue: SortOrder.artemisUnknown)
  SortOrder order;

  @override
  List<Object> get props => [field, order];
  Map<String, dynamic> toJson() => _$AnimesOrderByOrderByClauseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetails$Query$Anime with EquatableMixin, AnimeDetailsFieldsMixin {
  GetAnimeDetails$Query$Anime();

  factory GetAnimeDetails$Query$Anime.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeDetails$Query$AnimeFromJson(json);

  @override
  List<Object> get props => [id, description, anilist, genres];
  Map<String, dynamic> toJson() => _$GetAnimeDetails$Query$AnimeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetails$Query with EquatableMixin {
  GetAnimeDetails$Query();

  factory GetAnimeDetails$Query.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeDetails$QueryFromJson(json);

  GetAnimeDetails$Query$Anime anime;

  @override
  List<Object> get props => [anime];
  Map<String, dynamic> toJson() => _$GetAnimeDetails$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimeDetailsFieldsMixin$Genres with EquatableMixin, GenreFieldsMixin {
  AnimeDetailsFieldsMixin$Genres();

  factory AnimeDetailsFieldsMixin$Genres.fromJson(Map<String, dynamic> json) =>
      _$AnimeDetailsFieldsMixin$GenresFromJson(json);

  @override
  List<Object> get props => [id, name];
  Map<String, dynamic> toJson() => _$AnimeDetailsFieldsMixin$GenresToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetailsFull$Query$Anime
    with EquatableMixin, AnimeItemFieldsMixin, AnimeDetailsFieldsMixin {
  GetAnimeDetailsFull$Query$Anime();

  factory GetAnimeDetailsFull$Query$Anime.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeDetailsFull$Query$AnimeFromJson(json);

  @override
  List<Object> get props => [
        id,
        name,
        animeType,
        rating,
        coverImage,
        coverColor,
        bannerImage,
        id,
        description,
        anilist,
        genres
      ];
  Map<String, dynamic> toJson() =>
      _$GetAnimeDetailsFull$Query$AnimeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetailsFull$Query with EquatableMixin {
  GetAnimeDetailsFull$Query();

  factory GetAnimeDetailsFull$Query.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeDetailsFull$QueryFromJson(json);

  GetAnimeDetailsFull$Query$Anime anime;

  @override
  List<Object> get props => [anime];
  Map<String, dynamic> toJson() => _$GetAnimeDetailsFull$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimeItemFieldsMixin$CoverImage with EquatableMixin {
  AnimeItemFieldsMixin$CoverImage();

  factory AnimeItemFieldsMixin$CoverImage.fromJson(Map<String, dynamic> json) =>
      _$AnimeItemFieldsMixin$CoverImageFromJson(json);

  String large;

  @override
  List<Object> get props => [large];
  Map<String, dynamic> toJson() =>
      _$AnimeItemFieldsMixin$CoverImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeEpisodes$Query$Episodes$PaginatorInfo with EquatableMixin {
  GetAnimeEpisodes$Query$Episodes$PaginatorInfo();

  factory GetAnimeEpisodes$Query$Episodes$PaginatorInfo.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeEpisodes$Query$Episodes$PaginatorInfoFromJson(json);

  int total;

  int lastPage;

  bool hasMorePages;

  int currentPage;

  @override
  List<Object> get props => [total, lastPage, hasMorePages, currentPage];
  Map<String, dynamic> toJson() =>
      _$GetAnimeEpisodes$Query$Episodes$PaginatorInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeEpisodes$Query$Episodes$Data$Releases with EquatableMixin {
  GetAnimeEpisodes$Query$Episodes$Data$Releases();

  factory GetAnimeEpisodes$Query$Episodes$Data$Releases.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeEpisodes$Query$Episodes$Data$ReleasesFromJson(json);

  String id;

  String url;

  String type;

  int resolution;

  String group;

  @override
  List<Object> get props => [id, url, type, resolution, group];
  Map<String, dynamic> toJson() =>
      _$GetAnimeEpisodes$Query$Episodes$Data$ReleasesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeEpisodes$Query$Episodes$Data with EquatableMixin {
  GetAnimeEpisodes$Query$Episodes$Data();

  factory GetAnimeEpisodes$Query$Episodes$Data.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeEpisodes$Query$Episodes$DataFromJson(json);

  String id;

  int number;

  List<GetAnimeEpisodes$Query$Episodes$Data$Releases> releases;

  String title;

  int duration;

  String thumbnail;

  @override
  List<Object> get props => [id, number, releases, title, duration, thumbnail];
  Map<String, dynamic> toJson() =>
      _$GetAnimeEpisodes$Query$Episodes$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeEpisodes$Query$Episodes with EquatableMixin {
  GetAnimeEpisodes$Query$Episodes();

  factory GetAnimeEpisodes$Query$Episodes.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeEpisodes$Query$EpisodesFromJson(json);

  GetAnimeEpisodes$Query$Episodes$PaginatorInfo paginatorInfo;

  List<GetAnimeEpisodes$Query$Episodes$Data> data;

  @override
  List<Object> get props => [paginatorInfo, data];
  Map<String, dynamic> toJson() =>
      _$GetAnimeEpisodes$Query$EpisodesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeEpisodes$Query with EquatableMixin {
  GetAnimeEpisodes$Query();

  factory GetAnimeEpisodes$Query.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeEpisodes$QueryFromJson(json);

  GetAnimeEpisodes$Query$Episodes episodes;

  @override
  List<Object> get props => [episodes];
  Map<String, dynamic> toJson() => _$GetAnimeEpisodes$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EpisodesHasAnimeWhereConditions with EquatableMixin {
  EpisodesHasAnimeWhereConditions(
      {this.column, this.kw$operator, this.value, this.and, this.or});

  factory EpisodesHasAnimeWhereConditions.fromJson(Map<String, dynamic> json) =>
      _$EpisodesHasAnimeWhereConditionsFromJson(json);

  @JsonKey(unknownEnumValue: EpisodesHasAnimeColumn.artemisUnknown)
  EpisodesHasAnimeColumn column;

  @JsonKey(name: 'operator', unknownEnumValue: SQLOperator.artemisUnknown)
  SQLOperator kw$operator;

  String value;

  @JsonKey(name: 'AND')
  List<EpisodesHasAnimeWhereConditions> and;

  @JsonKey(name: 'OR')
  List<EpisodesHasAnimeWhereConditions> or;

  @override
  List<Object> get props => [column, kw$operator, value, and, or];
  Map<String, dynamic> toJson() =>
      _$EpisodesHasAnimeWhereConditionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EpisodesOrderByOrderByClause with EquatableMixin {
  EpisodesOrderByOrderByClause({@required this.field, @required this.order});

  factory EpisodesOrderByOrderByClause.fromJson(Map<String, dynamic> json) =>
      _$EpisodesOrderByOrderByClauseFromJson(json);

  @JsonKey(unknownEnumValue: EpisodesOrderByColumn.artemisUnknown)
  EpisodesOrderByColumn field;

  @JsonKey(unknownEnumValue: SortOrder.artemisUnknown)
  SortOrder order;

  @override
  List<Object> get props => [field, order];
  Map<String, dynamic> toJson() => _$EpisodesOrderByOrderByClauseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query$Anime$Relations$Data$RelationPivot
    with EquatableMixin {
  GetAnimeRelations$Query$Anime$Relations$Data$RelationPivot();

  factory GetAnimeRelations$Query$Anime$Relations$Data$RelationPivot.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeRelations$Query$Anime$Relations$Data$RelationPivotFromJson(
          json);

  String relationType;

  @override
  List<Object> get props => [relationType];
  Map<String, dynamic> toJson() =>
      _$GetAnimeRelations$Query$Anime$Relations$Data$RelationPivotToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query$Anime$Relations$Data
    with EquatableMixin, AnimeItemFieldsMixin {
  GetAnimeRelations$Query$Anime$Relations$Data();

  factory GetAnimeRelations$Query$Anime$Relations$Data.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeRelations$Query$Anime$Relations$DataFromJson(json);

  GetAnimeRelations$Query$Anime$Relations$Data$RelationPivot relationPivot;

  @override
  List<Object> get props => [
        id,
        name,
        animeType,
        rating,
        coverImage,
        coverColor,
        bannerImage,
        relationPivot
      ];
  Map<String, dynamic> toJson() =>
      _$GetAnimeRelations$Query$Anime$Relations$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query$Anime$Relations with EquatableMixin {
  GetAnimeRelations$Query$Anime$Relations();

  factory GetAnimeRelations$Query$Anime$Relations.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeRelations$Query$Anime$RelationsFromJson(json);

  List<GetAnimeRelations$Query$Anime$Relations$Data> data;

  @override
  List<Object> get props => [data];
  Map<String, dynamic> toJson() =>
      _$GetAnimeRelations$Query$Anime$RelationsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query$Anime$Recommendations$Data$RecommendationPivot
    with EquatableMixin {
  GetAnimeRelations$Query$Anime$Recommendations$Data$RecommendationPivot();

  factory GetAnimeRelations$Query$Anime$Recommendations$Data$RecommendationPivot.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeRelations$Query$Anime$Recommendations$Data$RecommendationPivotFromJson(
          json);

  int rating;

  @override
  List<Object> get props => [rating];
  Map<String, dynamic> toJson() =>
      _$GetAnimeRelations$Query$Anime$Recommendations$Data$RecommendationPivotToJson(
          this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query$Anime$Recommendations$Data
    with EquatableMixin, AnimeItemFieldsMixin {
  GetAnimeRelations$Query$Anime$Recommendations$Data();

  factory GetAnimeRelations$Query$Anime$Recommendations$Data.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeRelations$Query$Anime$Recommendations$DataFromJson(json);

  GetAnimeRelations$Query$Anime$Recommendations$Data$RecommendationPivot
      recommendationPivot;

  @override
  List<Object> get props => [
        id,
        name,
        animeType,
        rating,
        coverImage,
        coverColor,
        bannerImage,
        recommendationPivot
      ];
  Map<String, dynamic> toJson() =>
      _$GetAnimeRelations$Query$Anime$Recommendations$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query$Anime$Recommendations with EquatableMixin {
  GetAnimeRelations$Query$Anime$Recommendations();

  factory GetAnimeRelations$Query$Anime$Recommendations.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeRelations$Query$Anime$RecommendationsFromJson(json);

  List<GetAnimeRelations$Query$Anime$Recommendations$Data> data;

  @override
  List<Object> get props => [data];
  Map<String, dynamic> toJson() =>
      _$GetAnimeRelations$Query$Anime$RecommendationsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query$Anime with EquatableMixin {
  GetAnimeRelations$Query$Anime();

  factory GetAnimeRelations$Query$Anime.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeRelations$Query$AnimeFromJson(json);

  String id;

  GetAnimeRelations$Query$Anime$Relations relations;

  GetAnimeRelations$Query$Anime$Recommendations recommendations;

  @override
  List<Object> get props => [id, relations, recommendations];
  Map<String, dynamic> toJson() => _$GetAnimeRelations$Query$AnimeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelations$Query with EquatableMixin {
  GetAnimeRelations$Query();

  factory GetAnimeRelations$Query.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeRelations$QueryFromJson(json);

  GetAnimeRelations$Query$Anime anime;

  @override
  List<Object> get props => [anime];
  Map<String, dynamic> toJson() => _$GetAnimeRelations$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetEpisodePageInfo$Query$EpisodePageLocator with EquatableMixin {
  GetEpisodePageInfo$Query$EpisodePageLocator();

  factory GetEpisodePageInfo$Query$EpisodePageLocator.fromJson(
          Map<String, dynamic> json) =>
      _$GetEpisodePageInfo$Query$EpisodePageLocatorFromJson(json);

  int page;

  bool hasMorePages;

  @override
  List<Object> get props => [page, hasMorePages];
  Map<String, dynamic> toJson() =>
      _$GetEpisodePageInfo$Query$EpisodePageLocatorToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetEpisodePageInfo$Query with EquatableMixin {
  GetEpisodePageInfo$Query();

  factory GetEpisodePageInfo$Query.fromJson(Map<String, dynamic> json) =>
      _$GetEpisodePageInfo$QueryFromJson(json);

  GetEpisodePageInfo$Query$EpisodePageLocator episodePageLocator;

  @override
  List<Object> get props => [episodePageLocator];
  Map<String, dynamic> toJson() => _$GetEpisodePageInfo$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetFeatured$Query with EquatableMixin {
  GetFeatured$Query();

  factory GetFeatured$Query.fromJson(Map<String, dynamic> json) =>
      _$GetFeatured$QueryFromJson(json);

  String featured;

  @override
  List<Object> get props => [featured];
  Map<String, dynamic> toJson() => _$GetFeatured$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetGenres$Query$Genres with EquatableMixin, GenreFieldsMixin {
  GetGenres$Query$Genres();

  factory GetGenres$Query$Genres.fromJson(Map<String, dynamic> json) =>
      _$GetGenres$Query$GenresFromJson(json);

  @override
  List<Object> get props => [id, name];
  Map<String, dynamic> toJson() => _$GetGenres$Query$GenresToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetGenres$Query with EquatableMixin {
  GetGenres$Query();

  factory GetGenres$Query.fromJson(Map<String, dynamic> json) =>
      _$GetGenres$QueryFromJson(json);

  List<GetGenres$Query$Genres> genres;

  @override
  List<Object> get props => [genres];
  Map<String, dynamic> toJson() => _$GetGenres$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetSubscriptions$Query$Me$Subscriptions$PaginatorInfo
    with EquatableMixin {
  GetSubscriptions$Query$Me$Subscriptions$PaginatorInfo();

  factory GetSubscriptions$Query$Me$Subscriptions$PaginatorInfo.fromJson(
          Map<String, dynamic> json) =>
      _$GetSubscriptions$Query$Me$Subscriptions$PaginatorInfoFromJson(json);

  int total;

  int lastPage;

  bool hasMorePages;

  int currentPage;

  @override
  List<Object> get props => [total, lastPage, hasMorePages, currentPage];
  Map<String, dynamic> toJson() =>
      _$GetSubscriptions$Query$Me$Subscriptions$PaginatorInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetSubscriptions$Query$Me$Subscriptions$Data
    with EquatableMixin, AnimeItemFieldsMixin {
  GetSubscriptions$Query$Me$Subscriptions$Data();

  factory GetSubscriptions$Query$Me$Subscriptions$Data.fromJson(
          Map<String, dynamic> json) =>
      _$GetSubscriptions$Query$Me$Subscriptions$DataFromJson(json);

  @override
  List<Object> get props =>
      [id, name, animeType, rating, coverImage, coverColor, bannerImage];
  Map<String, dynamic> toJson() =>
      _$GetSubscriptions$Query$Me$Subscriptions$DataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetSubscriptions$Query$Me$Subscriptions with EquatableMixin {
  GetSubscriptions$Query$Me$Subscriptions();

  factory GetSubscriptions$Query$Me$Subscriptions.fromJson(
          Map<String, dynamic> json) =>
      _$GetSubscriptions$Query$Me$SubscriptionsFromJson(json);

  GetSubscriptions$Query$Me$Subscriptions$PaginatorInfo paginatorInfo;

  List<GetSubscriptions$Query$Me$Subscriptions$Data> data;

  @override
  List<Object> get props => [paginatorInfo, data];
  Map<String, dynamic> toJson() =>
      _$GetSubscriptions$Query$Me$SubscriptionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetSubscriptions$Query$Me with EquatableMixin {
  GetSubscriptions$Query$Me();

  factory GetSubscriptions$Query$Me.fromJson(Map<String, dynamic> json) =>
      _$GetSubscriptions$Query$MeFromJson(json);

  GetSubscriptions$Query$Me$Subscriptions subscriptions;

  @override
  List<Object> get props => [subscriptions];
  Map<String, dynamic> toJson() => _$GetSubscriptions$Query$MeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetSubscriptions$Query with EquatableMixin {
  GetSubscriptions$Query();

  factory GetSubscriptions$Query.fromJson(Map<String, dynamic> json) =>
      _$GetSubscriptions$QueryFromJson(json);

  GetSubscriptions$Query$Me me;

  @override
  List<Object> get props => [me];
  Map<String, dynamic> toJson() => _$GetSubscriptions$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class IsSubscribedTo$Query with EquatableMixin {
  IsSubscribedTo$Query();

  factory IsSubscribedTo$Query.fromJson(Map<String, dynamic> json) =>
      _$IsSubscribedTo$QueryFromJson(json);

  bool isUserSubscribedTo;

  @override
  List<Object> get props => [isUserSubscribedTo];
  Map<String, dynamic> toJson() => _$IsSubscribedTo$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimeItemModelGenerator$Query$Anime
    with EquatableMixin, AnimeItemFieldsMixin {
  AnimeItemModelGenerator$Query$Anime();

  factory AnimeItemModelGenerator$Query$Anime.fromJson(
          Map<String, dynamic> json) =>
      _$AnimeItemModelGenerator$Query$AnimeFromJson(json);

  @override
  List<Object> get props =>
      [id, name, animeType, rating, coverImage, coverColor, bannerImage];
  Map<String, dynamic> toJson() =>
      _$AnimeItemModelGenerator$Query$AnimeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimeItemModelGenerator$Query with EquatableMixin {
  AnimeItemModelGenerator$Query();

  factory AnimeItemModelGenerator$Query.fromJson(Map<String, dynamic> json) =>
      _$AnimeItemModelGenerator$QueryFromJson(json);

  AnimeItemModelGenerator$Query$Anime anime;

  @override
  List<Object> get props => [anime];
  Map<String, dynamic> toJson() => _$AnimeItemModelGenerator$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubscribeTo$Mutation with EquatableMixin {
  SubscribeTo$Mutation();

  factory SubscribeTo$Mutation.fromJson(Map<String, dynamic> json) =>
      _$SubscribeTo$MutationFromJson(json);

  bool subscribeTo;

  @override
  List<Object> get props => [subscribeTo];
  Map<String, dynamic> toJson() => _$SubscribeTo$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UnsubscribeFrom$Mutation with EquatableMixin {
  UnsubscribeFrom$Mutation();

  factory UnsubscribeFrom$Mutation.fromJson(Map<String, dynamic> json) =>
      _$UnsubscribeFrom$MutationFromJson(json);

  bool unsubscribeFrom;

  @override
  List<Object> get props => [unsubscribeFrom];
  Map<String, dynamic> toJson() => _$UnsubscribeFrom$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UploadFcmToken$Mutation with EquatableMixin {
  UploadFcmToken$Mutation();

  factory UploadFcmToken$Mutation.fromJson(Map<String, dynamic> json) =>
      _$UploadFcmToken$MutationFromJson(json);

  bool registerFcmToken;

  @override
  List<Object> get props => [registerFcmToken];
  Map<String, dynamic> toJson() => _$UploadFcmToken$MutationToJson(this);
}

enum AnimeType {
  @JsonValue('SERIES')
  series,
  @JsonValue('MOVIE')
  movie,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum AnimesHasGenresColumn {
  @JsonValue('ID')
  id,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum SQLOperator {
  @JsonValue('EQ')
  eq,
  @JsonValue('NEQ')
  neq,
  @JsonValue('GT')
  gt,
  @JsonValue('GTE')
  gte,
  @JsonValue('LT')
  lt,
  @JsonValue('LTE')
  lte,
  @JsonValue('LIKE')
  like,
  @JsonValue('NOT_LIKE')
  notLike,
  @JsonValue('IN')
  kw$IN,
  @JsonValue('NOT_IN')
  notIn,
  @JsonValue('BETWEEN')
  between,
  @JsonValue('NOT_BETWEEN')
  notBetween,
  @JsonValue('IS_NULL')
  isNull,
  @JsonValue('IS_NOT_NULL')
  isNotNull,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum AnimeOrderColumns {
  @JsonValue('ID')
  id,
  @JsonValue('NAME')
  name,
  @JsonValue('RATING')
  rating,
  @JsonValue('ANIME_TYPE')
  animeType,
  @JsonValue('CREATED_AT')
  createdAt,
  @JsonValue('ANILIST_DATA_UPDATED_AT')
  anilistDataUpdatedAt,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum SortOrder {
  @JsonValue('ASC')
  asc,
  @JsonValue('DESC')
  desc,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum EpisodesHasAnimeColumn {
  @JsonValue('ID')
  id,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum EpisodesOrderByColumn {
  @JsonValue('NUMBER')
  number,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimesArguments extends JsonSerializable with EquatableMixin {
  BrowseAnimesArguments(
      {this.first, this.page, this.orderBy, this.hasGenres, this.typeIn});

  @override
  factory BrowseAnimesArguments.fromJson(Map<String, dynamic> json) =>
      _$BrowseAnimesArgumentsFromJson(json);

  final int first;

  final int page;

  final List<AnimesOrderByOrderByClause> orderBy;

  final AnimesHasGenresWhereConditions hasGenres;

  final List<AnimeType> typeIn;

  @override
  List<Object> get props => [first, page, orderBy, hasGenres, typeIn];
  @override
  Map<String, dynamic> toJson() => _$BrowseAnimesArgumentsToJson(this);
}

class BrowseAnimesQuery
    extends GraphQLQuery<BrowseAnimes$Query, BrowseAnimesArguments> {
  BrowseAnimesQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'BrowseAnimes'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'first')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'page')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'orderBy')),
              type: ListTypeNode(
                  type: NamedTypeNode(
                      name: NameNode(value: 'AnimesOrderByOrderByClause'),
                      isNonNull: true),
                  isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'hasGenres')),
              type: NamedTypeNode(
                  name: NameNode(value: 'AnimesHasGenresWhereConditions'),
                  isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'typeIn')),
              type: ListTypeNode(
                  type: NamedTypeNode(
                      name: NameNode(value: 'AnimeType'), isNonNull: true),
                  isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'animes'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'first'),
                    value: VariableNode(name: NameNode(value: 'first'))),
                ArgumentNode(
                    name: NameNode(value: 'page'),
                    value: VariableNode(name: NameNode(value: 'page'))),
                ArgumentNode(
                    name: NameNode(value: 'orderBy'),
                    value: VariableNode(name: NameNode(value: 'orderBy'))),
                ArgumentNode(
                    name: NameNode(value: 'hasGenres'),
                    value: VariableNode(name: NameNode(value: 'hasGenres'))),
                ArgumentNode(
                    name: NameNode(value: 'animeTypeIn'),
                    value: VariableNode(name: NameNode(value: 'typeIn')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'paginatorInfo'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'total'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'lastPage'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'hasMorePages'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'currentPage'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ])),
                FieldNode(
                    name: NameNode(value: 'data'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'AnimeItemWithGenresFields'),
                          directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'AnimeItemWithGenresFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Anime'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'animeType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'rating'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'coverImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'large'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ])),
          FieldNode(
              name: NameNode(value: 'coverColor'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'bannerImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'genres'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'GenreFields'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'GenreFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Genre'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'BrowseAnimes';

  @override
  final BrowseAnimesArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  BrowseAnimes$Query parse(Map<String, dynamic> json) =>
      BrowseAnimes$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetailsArguments extends JsonSerializable with EquatableMixin {
  GetAnimeDetailsArguments({@required this.id});

  @override
  factory GetAnimeDetailsArguments.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeDetailsArgumentsFromJson(json);

  final String id;

  @override
  List<Object> get props => [id];
  @override
  Map<String, dynamic> toJson() => _$GetAnimeDetailsArgumentsToJson(this);
}

class GetAnimeDetailsQuery
    extends GraphQLQuery<GetAnimeDetails$Query, GetAnimeDetailsArguments> {
  GetAnimeDetailsQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetAnimeDetails'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'id')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'anime'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'id'),
                    value: VariableNode(name: NameNode(value: 'id')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'AnimeDetailsFields'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'AnimeDetailsFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Anime'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'description'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'anilist'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'genres'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'GenreFields'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'GenreFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Genre'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'GetAnimeDetails';

  @override
  final GetAnimeDetailsArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  GetAnimeDetails$Query parse(Map<String, dynamic> json) =>
      GetAnimeDetails$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetailsFullArguments extends JsonSerializable
    with EquatableMixin {
  GetAnimeDetailsFullArguments({@required this.id});

  @override
  factory GetAnimeDetailsFullArguments.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeDetailsFullArgumentsFromJson(json);

  final String id;

  @override
  List<Object> get props => [id];
  @override
  Map<String, dynamic> toJson() => _$GetAnimeDetailsFullArgumentsToJson(this);
}

class GetAnimeDetailsFullQuery extends GraphQLQuery<GetAnimeDetailsFull$Query,
    GetAnimeDetailsFullArguments> {
  GetAnimeDetailsFullQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetAnimeDetailsFull'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'id')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'anime'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'id'),
                    value: VariableNode(name: NameNode(value: 'id')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'AnimeItemFields'), directives: []),
                FragmentSpreadNode(
                    name: NameNode(value: 'AnimeDetailsFields'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'AnimeItemFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Anime'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'animeType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'rating'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'coverImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'large'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ])),
          FieldNode(
              name: NameNode(value: 'coverColor'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'bannerImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'AnimeDetailsFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Anime'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'description'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'anilist'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'genres'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'GenreFields'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'GenreFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Genre'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'GetAnimeDetailsFull';

  @override
  final GetAnimeDetailsFullArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  GetAnimeDetailsFull$Query parse(Map<String, dynamic> json) =>
      GetAnimeDetailsFull$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeEpisodesArguments extends JsonSerializable with EquatableMixin {
  GetAnimeEpisodesArguments(
      {@required this.hasAnime, this.orderBy, this.first, this.page});

  @override
  factory GetAnimeEpisodesArguments.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeEpisodesArgumentsFromJson(json);

  final EpisodesHasAnimeWhereConditions hasAnime;

  final List<EpisodesOrderByOrderByClause> orderBy;

  final int first;

  final int page;

  @override
  List<Object> get props => [hasAnime, orderBy, first, page];
  @override
  Map<String, dynamic> toJson() => _$GetAnimeEpisodesArgumentsToJson(this);
}

class GetAnimeEpisodesQuery
    extends GraphQLQuery<GetAnimeEpisodes$Query, GetAnimeEpisodesArguments> {
  GetAnimeEpisodesQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetAnimeEpisodes'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'hasAnime')),
              type: NamedTypeNode(
                  name: NameNode(value: 'EpisodesHasAnimeWhereConditions'),
                  isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'orderBy')),
              type: ListTypeNode(
                  type: NamedTypeNode(
                      name: NameNode(value: 'EpisodesOrderByOrderByClause'),
                      isNonNull: true),
                  isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'first')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'page')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'episodes'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'hasAnime'),
                    value: VariableNode(name: NameNode(value: 'hasAnime'))),
                ArgumentNode(
                    name: NameNode(value: 'orderBy'),
                    value: VariableNode(name: NameNode(value: 'orderBy'))),
                ArgumentNode(
                    name: NameNode(value: 'first'),
                    value: VariableNode(name: NameNode(value: 'first'))),
                ArgumentNode(
                    name: NameNode(value: 'page'),
                    value: VariableNode(name: NameNode(value: 'page')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'paginatorInfo'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'total'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'lastPage'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'hasMorePages'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'currentPage'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ])),
                FieldNode(
                    name: NameNode(value: 'data'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'id'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'number'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'releases'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FieldNode(
                                name: NameNode(value: 'id'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'url'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'type'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'resolution'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'group'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null)
                          ])),
                      FieldNode(
                          name: NameNode(value: 'title'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'duration'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'thumbnail'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ]))
              ]))
        ]))
  ]);

  @override
  final String operationName = 'GetAnimeEpisodes';

  @override
  final GetAnimeEpisodesArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  GetAnimeEpisodes$Query parse(Map<String, dynamic> json) =>
      GetAnimeEpisodes$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeRelationsArguments extends JsonSerializable with EquatableMixin {
  GetAnimeRelationsArguments({@required this.id});

  @override
  factory GetAnimeRelationsArguments.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeRelationsArgumentsFromJson(json);

  final String id;

  @override
  List<Object> get props => [id];
  @override
  Map<String, dynamic> toJson() => _$GetAnimeRelationsArgumentsToJson(this);
}

class GetAnimeRelationsQuery
    extends GraphQLQuery<GetAnimeRelations$Query, GetAnimeRelationsArguments> {
  GetAnimeRelationsQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetAnimeRelations'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'id')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'anime'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'id'),
                    value: VariableNode(name: NameNode(value: 'id')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'id'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'relations'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'data'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FragmentSpreadNode(
                                name: NameNode(value: 'AnimeItemFields'),
                                directives: []),
                            FieldNode(
                                name: NameNode(value: 'relationPivot'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: SelectionSetNode(selections: [
                                  FieldNode(
                                      name: NameNode(value: 'relationType'),
                                      alias: null,
                                      arguments: [],
                                      directives: [],
                                      selectionSet: null)
                                ]))
                          ]))
                    ])),
                FieldNode(
                    name: NameNode(value: 'recommendations'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'data'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FragmentSpreadNode(
                                name: NameNode(value: 'AnimeItemFields'),
                                directives: []),
                            FieldNode(
                                name: NameNode(value: 'recommendationPivot'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: SelectionSetNode(selections: [
                                  FieldNode(
                                      name: NameNode(value: 'rating'),
                                      alias: null,
                                      arguments: [],
                                      directives: [],
                                      selectionSet: null)
                                ]))
                          ]))
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'AnimeItemFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Anime'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'animeType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'rating'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'coverImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'large'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ])),
          FieldNode(
              name: NameNode(value: 'coverColor'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'bannerImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'GetAnimeRelations';

  @override
  final GetAnimeRelationsArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  GetAnimeRelations$Query parse(Map<String, dynamic> json) =>
      GetAnimeRelations$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetEpisodePageInfoArguments extends JsonSerializable with EquatableMixin {
  GetEpisodePageInfoArguments(
      {@required this.animeId,
      @required this.perPage,
      @required this.episodeNumber});

  @override
  factory GetEpisodePageInfoArguments.fromJson(Map<String, dynamic> json) =>
      _$GetEpisodePageInfoArgumentsFromJson(json);

  final String animeId;

  final int perPage;

  final int episodeNumber;

  @override
  List<Object> get props => [animeId, perPage, episodeNumber];
  @override
  Map<String, dynamic> toJson() => _$GetEpisodePageInfoArgumentsToJson(this);
}

class GetEpisodePageInfoQuery extends GraphQLQuery<GetEpisodePageInfo$Query,
    GetEpisodePageInfoArguments> {
  GetEpisodePageInfoQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetEpisodePageInfo'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'animeId')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'perPage')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'episodeNumber')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'episodePageLocator'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'episodeNumber'),
                    value:
                        VariableNode(name: NameNode(value: 'episodeNumber'))),
                ArgumentNode(
                    name: NameNode(value: 'animeId'),
                    value: VariableNode(name: NameNode(value: 'animeId'))),
                ArgumentNode(
                    name: NameNode(value: 'perPage'),
                    value: VariableNode(name: NameNode(value: 'perPage')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'page'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'hasMorePages'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'GetEpisodePageInfo';

  @override
  final GetEpisodePageInfoArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  GetEpisodePageInfo$Query parse(Map<String, dynamic> json) =>
      GetEpisodePageInfo$Query.fromJson(json);
}

class GetFeaturedQuery
    extends GraphQLQuery<GetFeatured$Query, JsonSerializable> {
  GetFeaturedQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetFeatured'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'featured'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'GetFeatured';

  @override
  List<Object> get props => [document, operationName];
  @override
  GetFeatured$Query parse(Map<String, dynamic> json) =>
      GetFeatured$Query.fromJson(json);
}

class GetGenresQuery extends GraphQLQuery<GetGenres$Query, JsonSerializable> {
  GetGenresQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetGenres'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'genres'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'GenreFields'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'GenreFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Genre'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'GetGenres';

  @override
  List<Object> get props => [document, operationName];
  @override
  GetGenres$Query parse(Map<String, dynamic> json) =>
      GetGenres$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetSubscriptionsArguments extends JsonSerializable with EquatableMixin {
  GetSubscriptionsArguments({this.first, this.page});

  @override
  factory GetSubscriptionsArguments.fromJson(Map<String, dynamic> json) =>
      _$GetSubscriptionsArgumentsFromJson(json);

  final int first;

  final int page;

  @override
  List<Object> get props => [first, page];
  @override
  Map<String, dynamic> toJson() => _$GetSubscriptionsArgumentsToJson(this);
}

class GetSubscriptionsQuery
    extends GraphQLQuery<GetSubscriptions$Query, GetSubscriptionsArguments> {
  GetSubscriptionsQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'GetSubscriptions'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'first')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'page')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'me'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'subscriptions'),
                    alias: null,
                    arguments: [
                      ArgumentNode(
                          name: NameNode(value: 'first'),
                          value: VariableNode(name: NameNode(value: 'first'))),
                      ArgumentNode(
                          name: NameNode(value: 'page'),
                          value: VariableNode(name: NameNode(value: 'page')))
                    ],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'paginatorInfo'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FieldNode(
                                name: NameNode(value: 'total'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'lastPage'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'hasMorePages'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'currentPage'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null)
                          ])),
                      FieldNode(
                          name: NameNode(value: 'data'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FragmentSpreadNode(
                                name: NameNode(value: 'AnimeItemFields'),
                                directives: [])
                          ]))
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'AnimeItemFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Anime'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'animeType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'rating'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'coverImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'large'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ])),
          FieldNode(
              name: NameNode(value: 'coverColor'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'bannerImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'GetSubscriptions';

  @override
  final GetSubscriptionsArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  GetSubscriptions$Query parse(Map<String, dynamic> json) =>
      GetSubscriptions$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class IsSubscribedToArguments extends JsonSerializable with EquatableMixin {
  IsSubscribedToArguments({@required this.animeId});

  @override
  factory IsSubscribedToArguments.fromJson(Map<String, dynamic> json) =>
      _$IsSubscribedToArgumentsFromJson(json);

  final String animeId;

  @override
  List<Object> get props => [animeId];
  @override
  Map<String, dynamic> toJson() => _$IsSubscribedToArgumentsToJson(this);
}

class IsSubscribedToQuery
    extends GraphQLQuery<IsSubscribedTo$Query, IsSubscribedToArguments> {
  IsSubscribedToQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'IsSubscribedTo'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'animeId')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'isUserSubscribedTo'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'animeId'),
                    value: VariableNode(name: NameNode(value: 'animeId')))
              ],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'IsSubscribedTo';

  @override
  final IsSubscribedToArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  IsSubscribedTo$Query parse(Map<String, dynamic> json) =>
      IsSubscribedTo$Query.fromJson(json);
}

class AnimeItemModelGeneratorQuery
    extends GraphQLQuery<AnimeItemModelGenerator$Query, JsonSerializable> {
  AnimeItemModelGeneratorQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'AnimeItemModelGenerator'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'anime'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'AnimeItemFields'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'AnimeItemFields'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'Anime'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'animeType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'rating'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'coverImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'large'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ])),
          FieldNode(
              name: NameNode(value: 'coverColor'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'bannerImage'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'AnimeItemModelGenerator';

  @override
  List<Object> get props => [document, operationName];
  @override
  AnimeItemModelGenerator$Query parse(Map<String, dynamic> json) =>
      AnimeItemModelGenerator$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SubscribeToArguments extends JsonSerializable with EquatableMixin {
  SubscribeToArguments({@required this.animeId});

  @override
  factory SubscribeToArguments.fromJson(Map<String, dynamic> json) =>
      _$SubscribeToArgumentsFromJson(json);

  final String animeId;

  @override
  List<Object> get props => [animeId];
  @override
  Map<String, dynamic> toJson() => _$SubscribeToArgumentsToJson(this);
}

class SubscribeToMutation
    extends GraphQLQuery<SubscribeTo$Mutation, SubscribeToArguments> {
  SubscribeToMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'SubscribeTo'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'animeId')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'subscribeTo'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'animeId'),
                    value: VariableNode(name: NameNode(value: 'animeId')))
              ],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'SubscribeTo';

  @override
  final SubscribeToArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  SubscribeTo$Mutation parse(Map<String, dynamic> json) =>
      SubscribeTo$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class UnsubscribeFromArguments extends JsonSerializable with EquatableMixin {
  UnsubscribeFromArguments({@required this.animeId});

  @override
  factory UnsubscribeFromArguments.fromJson(Map<String, dynamic> json) =>
      _$UnsubscribeFromArgumentsFromJson(json);

  final String animeId;

  @override
  List<Object> get props => [animeId];
  @override
  Map<String, dynamic> toJson() => _$UnsubscribeFromArgumentsToJson(this);
}

class UnsubscribeFromMutation
    extends GraphQLQuery<UnsubscribeFrom$Mutation, UnsubscribeFromArguments> {
  UnsubscribeFromMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'UnsubscribeFrom'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'animeId')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'unsubscribeFrom'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'animeId'),
                    value: VariableNode(name: NameNode(value: 'animeId')))
              ],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'UnsubscribeFrom';

  @override
  final UnsubscribeFromArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  UnsubscribeFrom$Mutation parse(Map<String, dynamic> json) =>
      UnsubscribeFrom$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class UploadFcmTokenArguments extends JsonSerializable with EquatableMixin {
  UploadFcmTokenArguments({@required this.token, this.oldToken});

  @override
  factory UploadFcmTokenArguments.fromJson(Map<String, dynamic> json) =>
      _$UploadFcmTokenArgumentsFromJson(json);

  final String token;

  final String oldToken;

  @override
  List<Object> get props => [token, oldToken];
  @override
  Map<String, dynamic> toJson() => _$UploadFcmTokenArgumentsToJson(this);
}

class UploadFcmTokenMutation
    extends GraphQLQuery<UploadFcmToken$Mutation, UploadFcmTokenArguments> {
  UploadFcmTokenMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'UploadFcmToken'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'token')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'oldToken')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'registerFcmToken'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'token'),
                    value: VariableNode(name: NameNode(value: 'token'))),
                ArgumentNode(
                    name: NameNode(value: 'oldToken'),
                    value: VariableNode(name: NameNode(value: 'oldToken')))
              ],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'UploadFcmToken';

  @override
  final UploadFcmTokenArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  UploadFcmToken$Mutation parse(Map<String, dynamic> json) =>
      UploadFcmToken$Mutation.fromJson(json);
}
