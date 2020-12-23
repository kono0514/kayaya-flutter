import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'genre.dart';

class Anime extends Equatable {
  final String id;
  final String name;
  final AnimeType type;
  final int rating;
  final String coverImage;
  final String coverColor;
  final String bannerImage;
  final List<Genre> genres;

  const Anime({
    @required this.id,
    this.name,
    this.type,
    this.rating,
    this.coverImage,
    this.coverColor,
    this.bannerImage,
    this.genres,
  });

  Anime copyWith({
    String id,
    String name,
    AnimeType type,
    int rating,
    String coverImage,
    String coverColor,
    String bannerImage,
    List<Genre> genres,
  }) {
    return Anime(
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

  bool get isSeries => type == AnimeType.series;
  bool get isMovie => type == AnimeType.movie;

  @override
  List<Object> get props =>
      [id, name, type, rating, coverImage, coverColor, bannerImage, genres];
}

enum AnimeType {
  series,
  movie,
}
