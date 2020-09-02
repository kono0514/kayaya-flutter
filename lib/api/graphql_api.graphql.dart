// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:meta/meta.dart';
import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
import 'package:kayaya_flutter/api/graphql_anilist_api.graphql.dart';
import 'package:kayaya_flutter/api/coercers.dart';
part 'graphql_api.graphql.g.dart';

mixin ListItemAnimeMixin {
  String id;
  ListItemAnimeMixin$Name name;
  @JsonKey(unknownEnumValue: AnimeType.artemisUnknown)
  AnimeType animeType;
  int rating;
  ListItemAnimeMixin$CoverImage coverImage;
  String coverColor;
  String bannerImage;
  List<ListItemAnimeMixin$Genres> genres;
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
class BrowseAnimes$Query$Animes$Data with EquatableMixin, ListItemAnimeMixin {
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
class ListItemAnimeMixin$Name with EquatableMixin {
  ListItemAnimeMixin$Name();

  factory ListItemAnimeMixin$Name.fromJson(Map<String, dynamic> json) =>
      _$ListItemAnimeMixin$NameFromJson(json);

  String en;

  String mn;

  @override
  List<Object> get props => [en, mn];
  Map<String, dynamic> toJson() => _$ListItemAnimeMixin$NameToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ListItemAnimeMixin$CoverImage with EquatableMixin {
  ListItemAnimeMixin$CoverImage();

  factory ListItemAnimeMixin$CoverImage.fromJson(Map<String, dynamic> json) =>
      _$ListItemAnimeMixin$CoverImageFromJson(json);

  String large;

  @override
  List<Object> get props => [large];
  Map<String, dynamic> toJson() => _$ListItemAnimeMixin$CoverImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ListItemAnimeMixin$Genres$Name with EquatableMixin {
  ListItemAnimeMixin$Genres$Name();

  factory ListItemAnimeMixin$Genres$Name.fromJson(Map<String, dynamic> json) =>
      _$ListItemAnimeMixin$Genres$NameFromJson(json);

  String en;

  String mn;

  @override
  List<Object> get props => [en, mn];
  Map<String, dynamic> toJson() => _$ListItemAnimeMixin$Genres$NameToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ListItemAnimeMixin$Genres with EquatableMixin {
  ListItemAnimeMixin$Genres();

  factory ListItemAnimeMixin$Genres.fromJson(Map<String, dynamic> json) =>
      _$ListItemAnimeMixin$GenresFromJson(json);

  String id;

  ListItemAnimeMixin$Genres$Name name;

  @override
  List<Object> get props => [id, name];
  Map<String, dynamic> toJson() => _$ListItemAnimeMixin$GenresToJson(this);
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
class GetAnimeDetails$Query$Anime$Description with EquatableMixin {
  GetAnimeDetails$Query$Anime$Description();

  factory GetAnimeDetails$Query$Anime$Description.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeDetails$Query$Anime$DescriptionFromJson(json);

  String en;

  String mn;

  @override
  List<Object> get props => [en, mn];
  Map<String, dynamic> toJson() =>
      _$GetAnimeDetails$Query$Anime$DescriptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetails$Query$Anime$Relations$RelationPivot with EquatableMixin {
  GetAnimeDetails$Query$Anime$Relations$RelationPivot();

  factory GetAnimeDetails$Query$Anime$Relations$RelationPivot.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeDetails$Query$Anime$Relations$RelationPivotFromJson(json);

  String relationType;

  @override
  List<Object> get props => [relationType];
  Map<String, dynamic> toJson() =>
      _$GetAnimeDetails$Query$Anime$Relations$RelationPivotToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetails$Query$Anime$Relations
    with EquatableMixin, ListItemAnimeMixin {
  GetAnimeDetails$Query$Anime$Relations();

  factory GetAnimeDetails$Query$Anime$Relations.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeDetails$Query$Anime$RelationsFromJson(json);

  GetAnimeDetails$Query$Anime$Relations$RelationPivot relationPivot;

  @override
  List<Object> get props => [
        id,
        name,
        animeType,
        rating,
        coverImage,
        coverColor,
        bannerImage,
        genres,
        relationPivot
      ];
  Map<String, dynamic> toJson() =>
      _$GetAnimeDetails$Query$Anime$RelationsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetails$Query$Anime$Recommendations$RecommendationPivot
    with EquatableMixin {
  GetAnimeDetails$Query$Anime$Recommendations$RecommendationPivot();

  factory GetAnimeDetails$Query$Anime$Recommendations$RecommendationPivot.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeDetails$Query$Anime$Recommendations$RecommendationPivotFromJson(
          json);

  int rating;

  @override
  List<Object> get props => [rating];
  Map<String, dynamic> toJson() =>
      _$GetAnimeDetails$Query$Anime$Recommendations$RecommendationPivotToJson(
          this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetails$Query$Anime$Recommendations
    with EquatableMixin, ListItemAnimeMixin {
  GetAnimeDetails$Query$Anime$Recommendations();

  factory GetAnimeDetails$Query$Anime$Recommendations.fromJson(
          Map<String, dynamic> json) =>
      _$GetAnimeDetails$Query$Anime$RecommendationsFromJson(json);

  GetAnimeDetails$Query$Anime$Recommendations$RecommendationPivot
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
        genres,
        recommendationPivot
      ];
  Map<String, dynamic> toJson() =>
      _$GetAnimeDetails$Query$Anime$RecommendationsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAnimeDetails$Query$Anime with EquatableMixin {
  GetAnimeDetails$Query$Anime();

  factory GetAnimeDetails$Query$Anime.fromJson(Map<String, dynamic> json) =>
      _$GetAnimeDetails$Query$AnimeFromJson(json);

  String id;

  GetAnimeDetails$Query$Anime$Description description;

  @JsonKey(
    fromJson: fromGraphQLAnilistMediaToDartGraphqlAnilistApi$Query$Media,
    toJson: fromDartGraphqlAnilistApi$Query$MediaToGraphQLAnilistMedia,
  )
  GraphqlAnilistApi$Query$Media anilist;

  List<GetAnimeDetails$Query$Anime$Relations> relations;

  List<GetAnimeDetails$Query$Anime$Recommendations> recommendations;

  @override
  List<Object> get props =>
      [id, description, anilist, relations, recommendations];
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

  @override
  List<Object> get props => [id, number, releases];
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
class GetGenres$Query$Genres$Name with EquatableMixin {
  GetGenres$Query$Genres$Name();

  factory GetGenres$Query$Genres$Name.fromJson(Map<String, dynamic> json) =>
      _$GetGenres$Query$Genres$NameFromJson(json);

  String en;

  String mn;

  @override
  List<Object> get props => [en, mn];
  Map<String, dynamic> toJson() => _$GetGenres$Query$Genres$NameToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetGenres$Query$Genres with EquatableMixin {
  GetGenres$Query$Genres();

  factory GetGenres$Query$Genres.fromJson(Map<String, dynamic> json) =>
      _$GetGenres$Query$GenresFromJson(json);

  String id;

  GetGenres$Query$Genres$Name name;

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
  @JsonValue('NAME_EN')
  nameEn,
  @JsonValue('NAME_MN')
  nameMn,
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
                          name: NameNode(value: 'ListItemAnime'),
                          directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'ListItemAnime'),
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
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'en'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'mn'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ])),
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
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'en'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'mn'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ]))
              ]))
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
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'en'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'mn'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ])),
                FieldNode(
                    name: NameNode(value: 'anilist'),
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
                      FragmentSpreadNode(
                          name: NameNode(value: 'ListItemAnime'),
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
                    ])),
                FieldNode(
                    name: NameNode(value: 'recommendations'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'ListItemAnime'),
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
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'ListItemAnime'),
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
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'en'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'mn'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ])),
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
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'en'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'mn'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ]))
              ]))
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
                          ]))
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
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'en'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'mn'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ]))
              ]))
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
