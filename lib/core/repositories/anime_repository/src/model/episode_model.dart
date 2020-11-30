import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart' as gen;
import 'package:meta/meta.dart';

import '../entity/episode.dart';
import '../entity/release.dart';
import '../model/release_model.dart';

class EpisodeModel extends Episode {
  EpisodeModel({
    @required String id,
    @required String title,
    @required int number,
    @required List<Release> releases,
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
      thumbnail: graphql.thumbnail,
    );
  }
}
