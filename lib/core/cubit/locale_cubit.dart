import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/core/services/shared_preferences_service.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final sps = GetIt.I<SharedPreferencesService>();

  LocaleCubit() : super(LocaleState(null));

  void resolveLocale() async {
    // Get the user's chosen locale from SharedPreferences
    // Fallback to 'en'
    String languageCode = sps.languageCode ?? 'en';
    emit(LocaleState(languageCode));
  }

  void changeLocale(String locale) async {
    await sps.setLanguage(locale);
    emit(LocaleState(locale));
  }
}
