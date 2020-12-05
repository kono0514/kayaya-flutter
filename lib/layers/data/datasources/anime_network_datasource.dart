import '../../../core/paged_list.dart';
import '../../domain/entities/anime_filter.dart';
import '../models/anime_model.dart';
import '../models/genre_model.dart';

abstract class AnimeNetworkDatasource {
  Future<String> fetchFeatured();
  Future<List<GenreModel>> fetchGenres();
  Future<PagedList<AnimeModel>> fetchAnimes(int page, Filter filter);
}
