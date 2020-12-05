import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/error.dart';
import '../../../core/paged_list.dart';
import '../entities/anime.dart';
import '../entities/anime_filter.dart';
import '../entities/genre.dart';

abstract class AnimeRepository {
  Future<Either<Failure, String>> getFeatured();
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, PagedList<Anime>>> getAnimes({
    @required int page,
    Filter filter,
  });
}
