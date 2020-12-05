import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/paged_list.dart';
import '../entities/anime.dart';
import '../entities/anime_relation.dart';
import '../entities/detail.dart';
import '../entities/episode.dart';

abstract class DetailRepository {
  Future<Either<Failure, Detail>> getDetail(String id);
  Future<Either<Failure, Tuple2<Anime, Detail>>> getDetailWithAnime(String id);
  Future<Either<Failure, AnimeRelation>> getRelations(String id);
  Future<Either<Failure, PagedList<Episode>>> getEpisodes({
    @required String id,
    int page = 1,
    String sortOrder = 'asc',
  });
}
