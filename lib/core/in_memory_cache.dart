import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@singleton
class InMemoryCache {
  Duration defaultDuration = const Duration(seconds: 10);
  Map<String, Map<String, Tuple2<DateTime, dynamic>>> store = {};

  void cache<T>(String key, T value, {Duration duration}) {
    final Type type = T;
    if (!store.containsKey(type.toString())) {
      store[type.toString()] = <String, Tuple2<DateTime, T>>{};
    }
    final expiresAt = DateTime.now().add(duration ?? defaultDuration);
    store[type.toString()][key] = Tuple2<DateTime, T>(expiresAt, value);
    _cleanup();
  }

  /// Read from cache by key.
  /// Returns `null` if expired or not found
  T read<T>(String key) {
    final Type type = T;
    if (store.containsKey(type.toString())) {
      if (store[type.toString()].containsKey(key)) {
        final value = store[type.toString()][key];
        if (value.value1.isAfter(DateTime.now())) {
          return value.value2 as T;
        }
      }
    }
    return null;
  }

  void _cleanup() {
    final now = DateTime.now();
    store.forEach((key, value) {
      if (value.length >= 20) {
        value.removeWhere((k, v) => v.value1.isBefore(now));
      }
    });
  }
}
