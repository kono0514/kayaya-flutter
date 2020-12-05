import 'package:dartz/dartz.dart';

import '../../../core/paged_list.dart';
import '../models/anime_model.dart';
import '../models/anime_relation_model.dart';
import '../models/detail_model.dart';
import '../models/episode_model.dart';

abstract class DetailNetworkDatasource {
  Future<DetailModel> fetchDetail(String id);
  Future<Tuple2<AnimeModel, DetailModel>> fetchDetailFull(String id);
  Future<AnimeRelationModel> fetchRelations(String id);
  Future<PagedList<EpisodeModel>> fetchEpisodes(
      String id, int page, String sortOrder);
}
