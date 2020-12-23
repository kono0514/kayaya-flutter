import 'package:meta/meta.dart';

import '../../../codegen/graphql_anilist_api.graphql.dart' as gen_anilist;
import '../../../codegen/graphql_api.graphql.dart' as gen;
import '../../domain/entities/detail.dart';
import 'genre_model.dart';

class DetailModel extends Detail {
  const DetailModel({
    @required String id,
    @required String description,
    DateTime startDate,
    int episodes,
    int duration,
    YoutubeTrailerModel trailer,
    List<ScoreDistributionModel> scoreDistribution,
    List<GenreModel> genres,
  }) : super(
          id: id,
          description: description,
          startDate: startDate,
          episodes: episodes,
          duration: duration,
          trailer: trailer,
          scoreDistribution: scoreDistribution,
          genres: genres,
        );

  factory DetailModel.fromGraphQL(gen.AnimeDetailsFieldsMixin graphql) {
    DateTime _date;
    if (graphql.anilist.startDate != null) {
      _date = DateTime(
        graphql.anilist.startDate.year,
        graphql.anilist.startDate.month,
        graphql.anilist.startDate.day,
      );
    }

    final _trailer = YoutubeTrailerModel.fromGraphQL(graphql.anilist.trailer);

    List<ScoreDistributionModel> _scoreDistribution;
    if (graphql.anilist.stats?.scoreDistribution != null) {
      _scoreDistribution = graphql.anilist.stats.scoreDistribution
          .map(
            (e) => ScoreDistributionModel.fromGraphQL(e),
          )
          .toList();
    }

    return DetailModel(
      id: graphql.id,
      description: graphql.description,
      startDate: _date,
      episodes: graphql.anilist.episodes,
      duration: graphql.anilist.duration,
      trailer: _trailer,
      scoreDistribution: _scoreDistribution,
      genres: graphql.genres.map((e) => GenreModel.fromGraphQL(e)).toList(),
    );
  }
}

class YoutubeTrailerModel extends YoutubeTrailer {
  const YoutubeTrailerModel(
    String url,
    String thumbnail,
  ) : super(url, thumbnail);

  factory YoutubeTrailerModel.fromGraphQL(
      gen_anilist.GraphqlAnilistApi$Query$Media$MediaTrailer graphql) {
    if (graphql == null || graphql.site != 'youtube') return null;

    return YoutubeTrailerModel(
      'https://youtube.com/watch?v=${graphql.id}',
      graphql.thumbnail,
    );
  }
}

class ScoreDistributionModel extends ScoreDistribution {
  const ScoreDistributionModel(int score, int amount) : super(score, amount);

  factory ScoreDistributionModel.fromGraphQL(
      gen_anilist.GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution
          graphql) {
    return ScoreDistributionModel(graphql.score, graphql.amount);
  }
}
