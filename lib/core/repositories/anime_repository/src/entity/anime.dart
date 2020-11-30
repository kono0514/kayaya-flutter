import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/core/repositories/anime_repository/src/entity/anime_details.dart';
import 'package:meta/meta.dart';

import 'genre.dart';

class Anime extends Equatable {
  final String id;
  final String name;
  final AnimeType type;
  final int rating;
  final String coverImage;
  final String coverColor;
  final String banner;
  final List<Genre> genres;
  final AnimeDetails details;

  Anime({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.rating,
    @required this.coverImage,
    @required this.coverColor,
    @required this.banner,
    @required this.genres,
    this.details,
  });

  Anime copyWith({
    String id,
    String name,
    AnimeType type,
    int rating,
    String coverImage,
    String coverColor,
    String banner,
    List<Genre> genres,
    AnimeDetails details,
  }) {
    return Anime(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      coverImage: coverImage ?? this.coverImage,
      coverColor: coverColor ?? this.coverColor,
      banner: banner ?? this.banner,
      genres: genres ?? this.genres,
      details: details ?? this.details,
    );
  }

  @override
  List<Object> get props =>
      [id, name, type, rating, coverImage, coverColor, banner, genres, details];
}

enum AnimeType {
  movie,
  series,
}
