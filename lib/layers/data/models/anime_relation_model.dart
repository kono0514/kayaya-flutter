import 'package:meta/meta.dart';

import '../../../codegen/graphql_api.graphql.dart' as gen;
import '../../domain/entities/anime_relation.dart';
import 'anime_model.dart';

class AnimeRelationModel extends AnimeRelation {
  const AnimeRelationModel({
    @required List<AnimeRelatedModel> related,
    @required List<AnimeRecommendationModel> recommendations,
  }) : super(
          related: related,
          recommendations: recommendations,
        );

  factory AnimeRelationModel.fromGraphQL(
      gen.GetAnimeRelations$Query$Anime graphql) {
    return AnimeRelationModel(
      related: graphql.relations.data
          .map((e) => AnimeRelatedModel.fromGraphQL(e))
          .toList(),
      recommendations: graphql.recommendations.data
          .map((e) => AnimeRecommendationModel.fromGraphQL(e))
          .toList(),
    );
  }
}

class AnimeRelatedModel extends AnimeRelated {
  const AnimeRelatedModel({
    @required String relatedType,
    @required AnimeModel anime,
  }) : super(relatedType: relatedType, anime: anime);

  factory AnimeRelatedModel.fromGraphQL(
      gen.GetAnimeRelations$Query$Anime$Relations$Data graphql) {
    return AnimeRelatedModel(
      relatedType: graphql.relationPivot.relationType,
      anime: AnimeModel.fromGraphQL(graphql),
    );
  }
}

class AnimeRecommendationModel extends AnimeRecommendation {
  const AnimeRecommendationModel({
    @required int rating,
    @required AnimeModel anime,
  }) : super(
          rating: rating,
          anime: anime,
        );

  factory AnimeRecommendationModel.fromGraphQL(
      gen.GetAnimeRelations$Query$Anime$Recommendations$Data graphql) {
    return AnimeRecommendationModel(
      rating: graphql.rating,
      anime: AnimeModel.fromGraphQL(graphql),
    );
  }
}
