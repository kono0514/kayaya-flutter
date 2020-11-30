import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AnimeDetails extends Equatable {
  final String id;
  final String description;
  final bool subscribed;
  final DateTime startDate;
  final int episodes;
  final int duration;
  final YoutubeTrailer trailer;
  final List<ScoreDistribution> scoreDistribution;

  AnimeDetails({
    @required this.id,
    @required this.description,
    @required this.subscribed,
    this.startDate,
    this.episodes,
    this.duration,
    this.trailer,
    this.scoreDistribution,
  });

  @override
  List<Object> get props => [
        id,
        description,
        subscribed,
        startDate,
        episodes,
        duration,
        trailer,
        scoreDistribution,
      ];
}

class YoutubeTrailer {
  final String url;
  final String thumbnail;

  YoutubeTrailer(this.url, this.thumbnail);
}

class ScoreDistribution {
  final int score;
  final int amount;

  ScoreDistribution(this.score, this.amount);
}
