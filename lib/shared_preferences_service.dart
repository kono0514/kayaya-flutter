import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String darkModeEnabled = 'darkModeEnabled';
  static const String languageCode = 'languageCode';
}

class SharedPreferencesService {
  static SharedPreferences _preferences;
  static SharedPreferencesService _instance;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
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
}
