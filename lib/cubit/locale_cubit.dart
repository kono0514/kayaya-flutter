import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kayaya_flutter/services/shared_preferences_service.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(null));

  void resolveLocale() async {
    // Get the user's chosen locale from SharedPreferences
    // Fallback to 'en'
    String languageCode =
        SharedPreferencesService.instance.languageCode ?? 'en';
    emit(LocaleState(languageCode));
  }

  void changeLocale(String locale) async {
    final sharedPrefService = SharedPreferencesService.instance;
    await sharedPrefService.setLanguage(locale);
    emit(LocaleState(locale));
  }
}
