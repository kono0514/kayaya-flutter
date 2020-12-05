import 'package:meta/meta.dart';

import '../../../codegen/graphql_api.graphql.dart' as gen;
import '../../domain/entities/anime.dart';
import 'genre_model.dart';

class AnimeModel extends Anime {
  AnimeModel({
    @required String id,
    String name,
    AnimeType type,
    int rating,
    String coverImage,
    String coverColor,
    String bannerImage,
    List<GenreModel> genres,
  }) : super(
          id: id,
          name: name,
          type: type,
          rating: rating,
          coverImage: coverImage,
          coverColor: coverColor,
          bannerImage: bannerImage,
          genres: genres,
        );

  factory AnimeModel.fromGraphQL(gen.AnimeItemFieldsMixin graphql) {
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
      bannerImage: graphql.bannerImage,
    );
  }

  factory AnimeModel.fromGraphQLWithGenres(
      gen.AnimeItemWithGenresFieldsMixin graphql) {
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
      bannerImage: graphql.bannerImage,
      genres: graphql.genres == null
          ? <GenreModel>[]
          : graphql.genres
              .map((e) => GenreModel(id: e.id, name: e.name))
              .toList(),
    );
  }

  AnimeModel modelCopyWith({
    String id,
    String name,
    AnimeType type,
    int rating,
    String coverImage,
    String coverColor,
    String bannerImage,
    List<GenreModel> genres,
  }) {
    return AnimeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      coverImage: coverImage ?? this.coverImage,
      coverColor: coverColor ?? this.coverColor,
      bannerImage: bannerImage ?? this.bannerImage,
      genres: genres ?? this.genres,
    );
  }
}
