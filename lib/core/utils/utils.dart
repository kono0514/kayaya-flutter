import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<String> downloadFile(String url) async {
  final file = await DefaultCacheManager().getSingleFile(url);
  return file.path;
}
