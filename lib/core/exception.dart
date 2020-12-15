class ServerException implements Exception {
  final Exception innerException;

  ServerException(this.innerException);
}

class CacheException implements Exception {
  final Exception innerException;

  CacheException(this.innerException);
}
