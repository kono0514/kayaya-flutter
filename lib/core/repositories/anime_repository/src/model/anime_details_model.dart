import 'package:kayaya_flutter/codegen/graphql_api.graphql.dart' as gen;
import 'package:meta/meta.dart';

import '../entity/anime_details.dart';

class AnimeDetailsModel extends AnimeDetails {
  AnimeDetailsModel({
    @required String id,
    @required String description,
    @required bool subscribed,
    DateTime startDate,
    int episodes,
    int duration,
    YoutubeTrailer trailer,
    List<ScoreDistribution> scoreDistribution,
  }) : super(
          id: id,
          description: description,
          subscribed: subscribed,
          startDate: startDate,
          episodes: episodes,
          duration: duration,
          trailer: trailer,
          scoreDistribution: scoreDistribution,
        );

  factory AnimeDetailsModel.fromGraphQL(
      gen.GetAnimeDetailsFull$Query$Anime graphql) {
    var _date;
    if (graphql.anilist.startDate != null) {
      _date = DateTime(
        graphql.anilist.startDate.year,
        graphql.anilist.startDate.month,
        graphql.anilist.startDate.day,
      );
    }

    var _trailer;
    if (graphql.anilist.trailer != null &&
        graphql.anilist.trailer.site == 'youtube') {
      _trailer = YoutubeTrailer(
        'https://youtube.com/watch?v=${graphql.anilist.trailer.id}',
        graphql.anilist.trailer.thumbnail,
      );
    }

    List<ScoreDistribution> _scoreDistribution;
    if (graphql.anilist.stats?.scoreDistribution != null) {
      _scoreDistribution = graphql.anilist.stats.scoreDistribution
          .map(
            (e) => ScoreDistribution(e.score, e.amount),
          )
          .toList();
    }

    return AnimeDetailsModel(
      id: graphql.id,
      description: graphql.description,
      subscribed: graphql.subscribed,
      startDate: _date,
      episodes: graphql.anilist.episodes,
      duration: graphql.anilist.duration,
      trailer: _trailer,
      scoreDistribution: _scoreDistribution,
    );
  }
}
