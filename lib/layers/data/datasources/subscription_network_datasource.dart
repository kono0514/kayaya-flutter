import '../../../core/paged_list.dart';
import '../models/anime_model.dart';

abstract class SubscriptionNetworkDatasource {
  Future<PagedList<AnimeModel>> fetchSubscriptions(int page);
  Future<bool> subscribe(String id);
  Future<bool> unsubscribe(String id);
  Future<bool> fetchIsSubscribed(String id);
}
