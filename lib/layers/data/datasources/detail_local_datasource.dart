import '../models/detail_model.dart';

abstract class DetailLocalDatasource {
  Future<DetailModel> fetchDetail(String id);
  Future<void> cacheDetail(
    DetailModel detail, {
    Duration duration = const Duration(seconds: 60),
  });
}
