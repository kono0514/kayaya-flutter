import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'anime.dart';

class AnimeRelation extends Equatable {
  final List<AnimeRelated> related;
  final List<AnimeRecommendation> recommendations;

  AnimeRelation({
    @required this.related,
    @required this.recommendations,
  });

  @override
  List<Object> get props => [related, recommendations];
}

class AnimeRelated extends Equatable {
  final String relatedType;
  final Anime anime;

  AnimeRelated({
    @required this.relatedType,
    @required this.anime,
  });

  @override
  List<Object> get props => [relatedType, anime];
}

class AnimeRecommendation extends Equatable {
  final int rating;
  final Anime anime;

  AnimeRecommendation({
    @required this.rating,
    @required this.anime,
  });

  @override
  List<Object> get props => [rating, anime];
}
