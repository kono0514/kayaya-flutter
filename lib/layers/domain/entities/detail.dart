import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'genre.dart';

class Detail extends Equatable {
  final String id;
  final String description;
  final DateTime startDate;
  final int episodes;
  final int duration;
  final YoutubeTrailer trailer;
  final List<ScoreDistribution> scoreDistribution;
  final List<Genre> genres;

  Detail({
    @required this.id,
    @required this.description,
    this.startDate,
    this.episodes,
    this.duration,
    this.trailer,
    this.scoreDistribution,
    this.genres,
  });

  @override
  List<Object> get props => [
        id,
        description,
        startDate,
        episodes,
        duration,
        trailer,
        scoreDistribution,
        genres,
      ];
}

class YoutubeTrailer extends Equatable {
  final String url;
  final String thumbnail;

  YoutubeTrailer(this.url, this.thumbnail);

  @override
  List<Object> get props => [url, thumbnail];
}

class ScoreDistribution extends Equatable {
  final int score;
  final int amount;

  ScoreDistribution(this.score, this.amount);

  @override
  List<Object> get props => [score, amount];
}
