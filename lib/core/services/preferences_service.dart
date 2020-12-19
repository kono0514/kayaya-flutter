import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

class _PrefKeys {
  static const String themeMode = 'themeMode';
  static const String languageCode = 'languageCode';
  static const String searchHistory = 'searchHistory';
  static const String currentFcmToken = 'currentFcmToken';
}

abstract class PreferencesDatasource {
  dynamic read(String key, {dynamic defaultValue});
  Future<void> write(String key, dynamic value);
  Future<void> remove(String key);
}

@Injectable(as: PreferencesDatasource)
class HivePreferencesDatasource implements PreferencesDatasource {
  final Box hiveBox;

  HivePreferencesDatasource({@Named('preferencesBox') @required this.hiveBox});

  @override
  dynamic read(String key, {dynamic defaultValue}) {
    return hiveBox.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> remove(String key) {
    return hiveBox.delete(key);
  }

  @override
  Future<void> write(String key, dynamic value) {
    return hiveBox.put(key, value);
  }
}

@Injectable()
class PreferencesService {
  final PreferencesDatasource dataSource;

  PreferencesService({@required this.dataSource});

  Future<void> setThemeMode(String themeMode) =>
      dataSource.write(_PrefKeys.themeMode, themeMode);

  String get themeMode =>
      dataSource.read(_PrefKeys.themeMode, defaultValue: 'dark');

  Future<void> setLanguage(String languageCode) =>
      dataSource.write(_PrefKeys.languageCode, languageCode);

  String get languageCode =>
      dataSource.read(_PrefKeys.languageCode, defaultValue: 'mn');

  Future<void> addSearchHistory(String query) async {
    List<String> _history =
        dataSource.read(_PrefKeys.searchHistory, defaultValue: <String>[]);
    if (_history.length >= 20) {
      _history = _history.getRange(0, 20);
    }

    _history.removeWhere((element) => element == query);
    _history.insert(0, query);
    await dataSource.write(_PrefKeys.searchHistory, _history);
  }

  Future<void> clearSearchHistory() =>
      dataSource.remove(_PrefKeys.searchHistory);

  List<String> get searchHistory =>
      dataSource.read(_PrefKeys.searchHistory, defaultValue: <String>[]);

  Future<void> saveCurrentFcmToken(String token) =>
      dataSource.write(_PrefKeys.currentFcmToken, token);

  String get currentSavedFcmToken => dataSource.read(_PrefKeys.currentFcmToken);
}
