// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
part 'graphql_anilist_api.graphql.g.dart';

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaTitle with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaTitle();

  factory GraphqlAnilistApi$Query$Media$MediaTitle.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaTitleFromJson(json);

  String romaji;

  String english;

  String native;

  String userPreferred;

  @override
  List<Object> get props => [romaji, english, native, userPreferred];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaTitleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$FuzzyDate with EquatableMixin {
  GraphqlAnilistApi$Query$Media$FuzzyDate();

  factory GraphqlAnilistApi$Query$Media$FuzzyDate.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$FuzzyDateFromJson(json);

  int year;

  int month;

  int day;

  @override
  List<Object> get props => [year, month, day];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$FuzzyDateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaTrailer with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaTrailer();

  factory GraphqlAnilistApi$Query$Media$MediaTrailer.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaTrailerFromJson(json);

  String id;

  String site;

  String thumbnail;

  @override
  List<Object> get props => [id, site, thumbnail];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaTrailerToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaCoverImage with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaCoverImage();

  factory GraphqlAnilistApi$Query$Media$MediaCoverImage.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaCoverImageFromJson(json);

  String extraLarge;

  String large;

  String medium;

  String color;

  @override
  List<Object> get props => [extraLarge, large, medium, color];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaCoverImageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaTag with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaTag();

  factory GraphqlAnilistApi$Query$Media$MediaTag.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaTagFromJson(json);

  int id;

  String name;

  @override
  List<Object> get props => [id, name];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaTagToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$StudioConnection$Studio
    with EquatableMixin {
  GraphqlAnilistApi$Query$Media$StudioConnection$Studio();

  factory GraphqlAnilistApi$Query$Media$StudioConnection$Studio.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$StudioConnection$StudioFromJson(json);

  String name;

  @override
  List<Object> get props => [name];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$StudioConnection$StudioToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$StudioConnection with EquatableMixin {
  GraphqlAnilistApi$Query$Media$StudioConnection();

  factory GraphqlAnilistApi$Query$Media$StudioConnection.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$StudioConnectionFromJson(json);

  List<GraphqlAnilistApi$Query$Media$StudioConnection$Studio> nodes;

  @override
  List<Object> get props => [nodes];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$StudioConnectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media
    with EquatableMixin {
  GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media();

  factory GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$MediaFromJson(
          json);

  int id;

  @override
  List<Object> get props => [id];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$MediaToJson(
          this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation
    with EquatableMixin {
  GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation();

  factory GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$RecommendationConnection$RecommendationFromJson(
          json);

  int rating;

  GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation$Media
      mediaRecommendation;

  @override
  List<Object> get props => [rating, mediaRecommendation];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$RecommendationConnection$RecommendationToJson(
          this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$RecommendationConnection
    with EquatableMixin {
  GraphqlAnilistApi$Query$Media$RecommendationConnection();

  factory GraphqlAnilistApi$Query$Media$RecommendationConnection.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$RecommendationConnectionFromJson(json);

  List<GraphqlAnilistApi$Query$Media$RecommendationConnection$Recommendation>
      nodes;

  @override
  List<Object> get props => [nodes];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$RecommendationConnectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media
    with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media();

  factory GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$MediaFromJson(
          json);

  int id;

  @override
  List<Object> get props => [id];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$MediaToJson(
          this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge
    with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge();

  factory GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdgeFromJson(json);

  int id;

  @JsonKey(unknownEnumValue: MediaRelation.artemisUnknown)
  MediaRelation relationType;

  GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge$Media node;

  @override
  List<Object> get props => [id, relationType, node];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdgeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaConnection with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaConnection();

  factory GraphqlAnilistApi$Query$Media$MediaConnection.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaConnectionFromJson(json);

  List<GraphqlAnilistApi$Query$Media$MediaConnection$MediaEdge> edges;

  @override
  List<Object> get props => [edges];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaConnectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution
    with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution();

  factory GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistributionFromJson(
          json);

  int score;

  int amount;

  @override
  List<Object> get props => [score, amount];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistributionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media$MediaStats with EquatableMixin {
  GraphqlAnilistApi$Query$Media$MediaStats();

  factory GraphqlAnilistApi$Query$Media$MediaStats.fromJson(
          Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$Media$MediaStatsFromJson(json);

  List<GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution>
      scoreDistribution;

  @override
  List<Object> get props => [scoreDistribution];
  Map<String, dynamic> toJson() =>
      _$GraphqlAnilistApi$Query$Media$MediaStatsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query$Media with EquatableMixin {
  GraphqlAnilistApi$Query$Media();

  factory GraphqlAnilistApi$Query$Media.fromJson(Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$Query$MediaFromJson(json);

  int id;

  int idMal;

  GraphqlAnilistApi$Query$Media$MediaTitle title;

  @JsonKey(unknownEnumValue: MediaType.artemisUnknown)
  MediaType type;

  @JsonKey(unknownEnumValue: MediaFormat.artemisUnknown)
  MediaFormat format;

  @JsonKey(unknownEnumValue: MediaStatus.artemisUnknown)
  MediaStatus status;

  String description;

  GraphqlAnilistApi$Query$Media$FuzzyDate startDate;

  GraphqlAnilistApi$Query$Media$FuzzyDate endDate;

  @JsonKey(unknownEnumValue: MediaSeason.artemisUnknown)
  MediaSeason season;

  int seasonYear;

  @Deprecated('')
  int seasonInt;

  int episodes;

  int duration;

  String countryOfOrigin;

  String hashtag;

  GraphqlAnilistApi$Query$Media$MediaTrailer trailer;

  GraphqlAnilistApi$Query$Media$MediaCoverImage coverImage;

  String bannerImage;

  List<String> genres;

  List<String> synonyms;

  int averageScore;

  int meanScore;

  int popularity;

  int trending;

  int favourites;

  List<GraphqlAnilistApi$Query$Media$MediaTag> tags;

  GraphqlAnilistApi$Query$Media$StudioConnection studios;

  bool isAdult;

  GraphqlAnilistApi$Query$Media$RecommendationConnection recommendations;

  String siteUrl;

  GraphqlAnilistApi$Query$Media$MediaConnection relations;

  GraphqlAnilistApi$Query$Media$MediaStats stats;

  @override
  List<Object> get props => [
        id,
        idMal,
        title,
        type,
        format,
        status,
        description,
        startDate,
        endDate,
        season,
        seasonYear,
        seasonInt,
        episodes,
        duration,
        countryOfOrigin,
        hashtag,
        trailer,
        coverImage,
        bannerImage,
        genres,
        synonyms,
        averageScore,
        meanScore,
        popularity,
        trending,
        favourites,
        tags,
        studios,
        isAdult,
        recommendations,
        siteUrl,
        relations,
        stats
      ];
  Map<String, dynamic> toJson() => _$GraphqlAnilistApi$Query$MediaToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApi$Query with EquatableMixin {
  GraphqlAnilistApi$Query();

  factory GraphqlAnilistApi$Query.fromJson(Map<String, dynamic> json) =>
      _$GraphqlAnilistApi$QueryFromJson(json);

  @JsonKey(name: 'Media')
  GraphqlAnilistApi$Query$Media media;

  @override
  List<Object> get props => [media];
  Map<String, dynamic> toJson() => _$GraphqlAnilistApi$QueryToJson(this);
}

enum MediaType {
  @JsonValue('ANIME')
  anime,
  @JsonValue('MANGA')
  manga,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum MediaFormat {
  @JsonValue('TV')
  tv,
  @JsonValue('TV_SHORT')
  tvShort,
  @JsonValue('MOVIE')
  movie,
  @JsonValue('SPECIAL')
  special,
  @JsonValue('OVA')
  ova,
  @JsonValue('ONA')
  ona,
  @JsonValue('MUSIC')
  music,
  @JsonValue('MANGA')
  manga,
  @JsonValue('NOVEL')
  novel,
  @JsonValue('ONE_SHOT')
  oneShot,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum MediaStatus {
  @JsonValue('FINISHED')
  finished,
  @JsonValue('RELEASING')
  releasing,
  @JsonValue('NOT_YET_RELEASED')
  notYetReleased,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('HIATUS')
  hiatus,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum MediaSeason {
  @JsonValue('WINTER')
  winter,
  @JsonValue('SPRING')
  spring,
  @JsonValue('SUMMER')
  summer,
  @JsonValue('FALL')
  fall,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum MediaRelation {
  @JsonValue('ADAPTATION')
  adaptation,
  @JsonValue('PREQUEL')
  prequel,
  @JsonValue('SEQUEL')
  sequel,
  @JsonValue('PARENT')
  parent,
  @JsonValue('SIDE_STORY')
  sideStory,
  @JsonValue('CHARACTER')
  character,
  @JsonValue('SUMMARY')
  summary,
  @JsonValue('ALTERNATIVE')
  alternative,
  @JsonValue('SPIN_OFF')
  spinOff,
  @JsonValue('OTHER')
  other,
  @JsonValue('SOURCE')
  source,
  @JsonValue('COMPILATION')
  compilation,
  @JsonValue('CONTAINS')
  contains,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}

@JsonSerializable(explicitToJson: true)
class GraphqlAnilistApiArguments extends JsonSerializable with EquatableMixin {
  GraphqlAnilistApiArguments({this.id});

  @override
  factory GraphqlAnilistApiArguments.fromJson(Map<String, dynamic> json) =>
      _$GraphqlAnilistApiArgumentsFromJson(json);

  final int id;

  @override
  List<Object> get props => [id];
  @override
  Map<String, dynamic> toJson() => _$GraphqlAnilistApiArgumentsToJson(this);
}

class GraphqlAnilistApiQuery
    extends GraphQLQuery<GraphqlAnilistApi$Query, GraphqlAnilistApiArguments> {
  GraphqlAnilistApiQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: null,
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'id')),
              type:
                  NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'Media'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'id'),
                    value: VariableNode(name: NameNode(value: 'id'))),
                ArgumentNode(
                    name: NameNode(value: 'type'),
                    value: EnumValueNode(name: NameNode(value: 'ANIME')))
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
                    name: NameNode(value: 'idMal'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'title'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'romaji'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'english'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'native'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'userPreferred'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ])),
                FieldNode(
                    name: NameNode(value: 'type'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'format'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'status'),
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
                    name: NameNode(value: 'startDate'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'year'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'month'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'day'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ])),
                FieldNode(
                    name: NameNode(value: 'endDate'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'year'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'month'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'day'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ])),
                FieldNode(
                    name: NameNode(value: 'season'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'seasonYear'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'seasonInt'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'episodes'),
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
                    name: NameNode(value: 'countryOfOrigin'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'hashtag'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'trailer'),
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
                          name: NameNode(value: 'site'),
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
                    ])),
                FieldNode(
                    name: NameNode(value: 'coverImage'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'extraLarge'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'large'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'medium'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'color'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ])),
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
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'synonyms'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'averageScore'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'meanScore'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'popularity'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'trending'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'favourites'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'tags'),
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
                          selectionSet: null)
                    ])),
                FieldNode(
                    name: NameNode(value: 'studios'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'nodes'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FieldNode(
                                name: NameNode(value: 'name'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null)
                          ]))
                    ])),
                FieldNode(
                    name: NameNode(value: 'isAdult'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'recommendations'),
                    alias: null,
                    arguments: [
                      ArgumentNode(
                          name: NameNode(value: 'sort'),
                          value: EnumValueNode(
                              name: NameNode(value: 'RATING_DESC')))
                    ],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'nodes'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FieldNode(
                                name: NameNode(value: 'rating'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'mediaRecommendation'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: SelectionSetNode(selections: [
                                  FieldNode(
                                      name: NameNode(value: 'id'),
                                      alias: null,
                                      arguments: [],
                                      directives: [],
                                      selectionSet: null)
                                ]))
                          ]))
                    ])),
                FieldNode(
                    name: NameNode(value: 'siteUrl'),
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
                          name: NameNode(value: 'edges'),
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
                                name: NameNode(value: 'relationType'),
                                alias: null,
                                arguments: [
                                  ArgumentNode(
                                      name: NameNode(value: 'version'),
                                      value: IntValueNode(value: '2'))
                                ],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'node'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: SelectionSetNode(selections: [
                                  FieldNode(
                                      name: NameNode(value: 'id'),
                                      alias: null,
                                      arguments: [],
                                      directives: [],
                                      selectionSet: null)
                                ]))
                          ]))
                    ])),
                FieldNode(
                    name: NameNode(value: 'stats'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'scoreDistribution'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(selections: [
                            FieldNode(
                                name: NameNode(value: 'score'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null),
                            FieldNode(
                                name: NameNode(value: 'amount'),
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
  final String operationName = 'graphql_anilist_api';

  @override
  final GraphqlAnilistApiArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  GraphqlAnilistApi$Query parse(Map<String, dynamic> json) =>
      GraphqlAnilistApi$Query.fromJson(json);
}
