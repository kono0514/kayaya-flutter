// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:meta/meta.dart';
import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
import 'package:kayaya_flutter/api/graphql_anilist_api.graphql.dart';
import 'package:kayaya_flutter/api/coercers.dart';
part 'graphql_api.graphql.g.dart';

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$AnimePaginator$PaginatorInfo with EquatableMixin {
  BrowseAnimes$Query$AnimePaginator$PaginatorInfo();

  factory BrowseAnimes$Query$AnimePaginator$PaginatorInfo.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimePaginator$PaginatorInfoFromJson(json);

  int total;

  int lastPage;

  bool hasMorePages;

  int currentPage;

  @override
  List<Object> get props => [total, lastPage, hasMorePages, currentPage];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$AnimePaginator$PaginatorInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$AnimePaginator$Anime$Translatable with EquatableMixin {
  BrowseAnimes$Query$AnimePaginator$Anime$Translatable();

  factory BrowseAnimes$Query$AnimePaginator$Anime$Translatable.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$TranslatableFromJson(json);

  String en;

  String mn;

  @override
  List<Object> get props => [en, mn];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$TranslatableToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage
    with EquatableMixin {
  BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage();

  factory BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImageFromJson(json);

  String large;

  @override
  List<Object> get props => [large];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable
    with EquatableMixin {
  BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable();

  factory BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$Genre$TranslatableFromJson(
          json);

  String en;

  String mn;

  @override
  List<Object> get props => [en, mn];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$Genre$TranslatableToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$AnimePaginator$Anime$Genre with EquatableMixin {
  BrowseAnimes$Query$AnimePaginator$Anime$Genre();

  factory BrowseAnimes$Query$AnimePaginator$Anime$Genre.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$GenreFromJson(json);

  String id;

  BrowseAnimes$Query$AnimePaginator$Anime$Genre$Translatable name;

  @override
  List<Object> get props => [id, name];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$AnimePaginator$Anime$GenreToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$AnimePaginator$Anime with EquatableMixin {
  BrowseAnimes$Query$AnimePaginator$Anime();

  factory BrowseAnimes$Query$AnimePaginator$Anime.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimePaginator$AnimeFromJson(json);

  String id;

  BrowseAnimes$Query$AnimePaginator$Anime$Translatable name;

  @JsonKey(unknownEnumValue: AnimeType.artemisUnknown)
  AnimeType animeType;

  int rating;

  BrowseAnimes$Query$AnimePaginator$Anime$AnimeCoverImage coverImage;

  String coverColor;

  List<BrowseAnimes$Query$AnimePaginator$Anime$Genre> genres;

  @override
  List<Object> get props =>
      [id, name, animeType, rating, coverImage, coverColor, genres];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$AnimePaginator$AnimeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query$AnimePaginator with EquatableMixin {
  BrowseAnimes$Query$AnimePaginator();

  factory BrowseAnimes$Query$AnimePaginator.fromJson(
          Map<String, dynamic> json) =>
      _$BrowseAnimes$Query$AnimePaginatorFromJson(json);

  BrowseAnimes$Query$AnimePaginator$PaginatorInfo paginatorInfo;

  List<BrowseAnimes$Query$AnimePaginator$Anime> data;

  @override
  List<Object> get props => [paginatorInfo, data];
  Map<String, dynamic> toJson() =>
      _$BrowseAnimes$Query$AnimePaginatorToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimes$Query with EquatableMixin {
  BrowseAnimes$Query();

  factory BrowseAnimes$Query.fromJson(Map<String, dynamic> json) =>
      _$BrowseAnimes$QueryFromJson(json);

  BrowseAnimes$Query$AnimePaginator animes;

  @override
  List<Object> get props => [animes];
  Map<String, dynamic> toJson() => _$BrowseAnimes$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnimesHasGenresWhereConditions with EquatableMixin {
  AnimesHasGenresWhereConditions(
      {this.column, this.kw$operator, this.value, this.and, this.or});

  factory AnimesHasGenresWhereConditions.fromJson(Map<String, dynamic> json) =>
      _$AnimesHasGenresWhereConditionsFromJson(json);

  @JsonKey(unknownEnumValue: AnimesHasGenresColumn.artemisUnknown)
  AnimesHasGenresColumn column;

  @JsonKey(unknownEnumValue: SQLOperator.artemisUnknown)
  @JsonKey(name: 'operator')
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
class GetGenres$Query$Genre$Translatable with EquatableMixin {
  GetGenres$Query$Genre$Translatable();

  factory GetGenres$Query$Genre$Translatable.fromJson(
          Map<String, dynamic> json) =>
      _$GetGenres$Query$Genre$TranslatableFromJson(json);

  String en;

  String mn;

  @override
  List<Object> get props => [en, mn];
  Map<String, dynamic> toJson() =>
      _$GetGenres$Query$Genre$TranslatableToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetGenres$Query$Genre with EquatableMixin {
  GetGenres$Query$Genre();

  factory GetGenres$Query$Genre.fromJson(Map<String, dynamic> json) =>
      _$GetGenres$Query$GenreFromJson(json);

  String id;

  GetGenres$Query$Genre$Translatable name;

  @override
  List<Object> get props => [id, name];
  Map<String, dynamic> toJson() => _$GetGenres$Query$GenreToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetGenres$Query with EquatableMixin {
  GetGenres$Query();

  factory GetGenres$Query.fromJson(Map<String, dynamic> json) =>
      _$GetGenres$QueryFromJson(json);

  List<GetGenres$Query$Genre> genres;

  @override
  List<Object> get props => [genres];
  Map<String, dynamic> toJson() => _$GetGenres$QueryToJson(this);
}

enum AnimeType {
  @JsonValue("SERIES")
  series,
  @JsonValue("MOVIE")
  movie,
  @JsonValue("ARTEMIS_UNKNOWN")
  artemisUnknown,
}
enum AnimesHasGenresColumn {
  @JsonValue("ID")
  id,
  @JsonValue("ARTEMIS_UNKNOWN")
  artemisUnknown,
}
enum SQLOperator {
  @JsonValue("EQ")
  eq,
  @JsonValue("NEQ")
  neq,
  @JsonValue("GT")
  gt,
  @JsonValue("GTE")
  gte,
  @JsonValue("LT")
  lt,
  @JsonValue("LTE")
  lte,
  @JsonValue("LIKE")
  like,
  @JsonValue("NOT_LIKE")
  notLike,
  @JsonValue("IN")
  kw$IN,
  @JsonValue("NOT_IN")
  notIn,
  @JsonValue("BETWEEN")
  between,
  @JsonValue("NOT_BETWEEN")
  notBetween,
  @JsonValue("IS_NULL")
  isNull,
  @JsonValue("IS_NOT_NULL")
  isNotNull,
  @JsonValue("ARTEMIS_UNKNOWN")
  artemisUnknown,
}
enum AnimeOrderColumns {
  @JsonValue("ID")
  id,
  @JsonValue("NAME_EN")
  nameEn,
  @JsonValue("NAME_MN")
  nameMn,
  @JsonValue("RATING")
  rating,
  @JsonValue("ANIME_TYPE")
  animeType,
  @JsonValue("CREATED_AT")
  createdAt,
  @JsonValue("ANILIST_DATA_UPDATED_AT")
  anilistDataUpdatedAt,
  @JsonValue("ARTEMIS_UNKNOWN")
  artemisUnknown,
}
enum SortOrder {
  @JsonValue("ASC")
  asc,
  @JsonValue("DESC")
  desc,
  @JsonValue("ARTEMIS_UNKNOWN")
  artemisUnknown,
}

@JsonSerializable(explicitToJson: true)
class BrowseAnimesArguments extends JsonSerializable with EquatableMixin {
  BrowseAnimesArguments(
      {this.first, this.page, this.orderBy, this.hasGenres, this.typeIn});

  factory BrowseAnimesArguments.fromJson(Map<String, dynamic> json) =>
      _$BrowseAnimesArgumentsFromJson(json);

  final int first;

  final int page;

  final List<AnimesOrderByOrderByClause> orderBy;

  final AnimesHasGenresWhereConditions hasGenres;

  final List<AnimeType> typeIn;

  @override
  List<Object> get props => [first, page, orderBy, hasGenres, typeIn];
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
