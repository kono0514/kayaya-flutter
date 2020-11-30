import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart' as gen;
import 'package:meta/meta.dart';

import '../entity/anime.dart';
import '../entity/genre.dart';

class AnimeModel extends Anime {
  AnimeModel({
    @required String id,
    @required String name,
    @required AnimeType type,
    @required int rating,
    @required String coverImage,
    @required String coverColor,
    @required String banner,
    @required List<Genre> genres,
  }) : super(
          id: id,
          name: name,
          type: type,
          rating: rating,
          coverImage: coverImage,
          coverColor: coverColor,
          banner: banner,
          genres: genres,
        );

  factory AnimeModel.fromGraphQL(gen.BrowseAnimes$Query$Animes$Data graphql) {
    final _type = graphql.animeType == gen.AnimeType.movie
        ? AnimeType.movie
        : AnimeType.series;

    return AnimeModel(
      id: graphql.id,
      name: graphql.name,
      type: _type,
      rating: graphql.rating,
      coverImage: graphql.coverImage.large,
      coverColor: graphql.coverColor,
      banner: graphql.bannerImage,
      genres: graphql.genres.map((e) => Genre(id: e.id, name: e.name)),
    );
  }
}
