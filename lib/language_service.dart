import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static SharedPreferences _preferences;
  static LanguageService _instance;

  LanguageService._internal();

  static Future<LanguageService> get instance async {
    if (_instance == null) {
      _instance = LanguageService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  Future<void> setLanguage(String languageCode) async =>
      await _preferences.setString('languageCode', languageCode);

  String get languageCode => _preferences.getString('languageCode');
}
