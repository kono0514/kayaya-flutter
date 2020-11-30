import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../services/preferences_service.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final pref = GetIt.I<PreferencesService>();

  LocaleCubit() : super(LocaleState('en'));

  void resolveLocale() async {
    String languageCode = pref.languageCode;
    emit(LocaleState(languageCode));
  }

  void changeLocale(String locale) async {
    await pref.setLanguage(locale);
    emit(LocaleState(locale));
  }
}
