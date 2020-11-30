import 'package:kayaya_flutter/core/entity/paged_list.dart';
import 'package:meta/meta.dart';

import '../entity/anime.dart';
import '../entity/anime_details.dart';
import '../entity/genre.dart';
import '../entity/episode.dart';

abstract class AnimeRepository {
  Future<PagedList<Anime>> getAnimes({
    int page = 1,
    FilterOrderBy orderBy = FilterOrderBy.recent,
    FilterType type = FilterType.all,
    List<Genre> genres = const [],
  });

  Future<AnimeDetails> getAnimeDetails({
    @required String id,
  });

  Future<List<Genre>> getGenres();

  Future<PagedList<Episode>> getEpisodes({
    @required String id,
    int page = 1,
    SortDirection sort = SortDirection.asc,
  });
}

enum FilterOrderBy {
  recent,
  alpha_asc,
  alpha_desc,
  rating_asc,
  rating_desc,
}

enum FilterType {
  all,
  movie,
  series,
}

enum SortDirection {
  asc,
  desc,
}
