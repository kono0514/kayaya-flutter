import 'dart:convert';
import 'package:kayaya_flutter/codegen/graphql_anilist_api.graphql.dart';

GraphqlAnilistApi$Query$Media
    fromGraphQLAnilistMediaToDartGraphqlAnilistApi$Query$Media(
            String anilistMediaString) =>
        GraphqlAnilistApi$Query$Media.fromJson(json.decode(anilistMediaString));
String fromDartGraphqlAnilistApi$Query$MediaToGraphQLAnilistMedia(
        GraphqlAnilistApi$Query$Media anilistMedia) =>
    json.encode(anilistMedia.toJson());
