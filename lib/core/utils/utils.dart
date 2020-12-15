import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<String> downloadFile(String url) async {
  final file = await DefaultCacheManager().getSingleFile(url);
  return file.path;
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}
