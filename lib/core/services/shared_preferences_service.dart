import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String darkModeEnabled = 'darkModeEnabled';
  static const String languageCode = 'languageCode';
  static const String searchHistory = 'searchHistory';
  static const String currentFcmToken = 'currentFcmToken';
}

class SharedPreferencesService {
  SharedPreferences _preferences;

  SharedPreferencesService();

  Future<SharedPreferencesService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> setLanguage(String languageCode) async =>
      await _preferences.setString(SharedPrefKeys.languageCode, languageCode);

  String get languageCode =>
      _preferences.getString(SharedPrefKeys.languageCode);

  Future<void> setDarkModeInfo(bool isDarkModeEnabled) async {
    if (isDarkModeEnabled == null) {
      // Follow system settings
      await _preferences.remove(SharedPrefKeys.darkModeEnabled);
    } else {
      await _preferences.setBool(
          SharedPrefKeys.darkModeEnabled, isDarkModeEnabled);
    }
  }

  bool get isDarkModeEnabled =>
      _preferences.getBool(SharedPrefKeys.darkModeEnabled);

  Future<void> addSearchHistory(String query) async {
    List<String> _history = searchHistory?.toList() ?? [];
    if (_history.length >= 20) {
      _history = _history.getRange(0, 20);
    }

    _history.removeWhere((element) => element == query);
    _history.insert(0, query);
    await _preferences.setStringList(SharedPrefKeys.searchHistory, _history);
  }

  Future<void> clearSearchHistory() async {
    await _preferences.remove(SharedPrefKeys.searchHistory);
  }

  List<String> get searchHistory =>
      _preferences.getStringList(SharedPrefKeys.searchHistory);

  Future<void> saveCurrentFcmToken(String token) async {
    await _preferences.setString(SharedPrefKeys.currentFcmToken, token);
  }

  String get currentSavedFcmToken =>
      _preferences.getString(SharedPrefKeys.currentFcmToken);
}
