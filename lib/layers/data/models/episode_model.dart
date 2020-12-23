import 'package:meta/meta.dart';

import '../../../codegen/graphql_api.graphql.dart' as gen;
import '../../domain/entities/episode.dart';
import 'release_model.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    @required String id,
    @required String title,
    @required int number,
    @required List<ReleaseModel> releases,
    String thumbnail,
  }) : super(
          id: id,
          title: title,
          number: number,
          releases: releases,
          thumbnail: thumbnail,
        );

  factory EpisodeModel.fromGraphQL(
      gen.GetAnimeEpisodes$Query$Episodes$Data graphql) {
    final _releases =
        graphql.releases.map((e) => ReleaseModel.fromGraphQL(e)).toList();

    return EpisodeModel(
        id: graphql.id,
        title: graphql.title,
        number: graphql.number,
        releases: _releases,
        thumbnail: graphql.thumbnail);
  }
}
