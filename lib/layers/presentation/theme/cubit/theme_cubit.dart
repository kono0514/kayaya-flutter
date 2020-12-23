import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/preferences_service.dart';

part 'theme_state.dart';

@Injectable()
class ThemeCubit extends Cubit<ThemeState> {
  final PreferencesService pref;

  ThemeCubit({@required this.pref}) : super(const ThemeState(ThemeMode.light));

  void resolveTheme() {
    switch (pref.themeMode) {
      case 'system':
        emit(const ThemeState(ThemeMode.system));
        break;
      case 'light':
        emit(const ThemeState(ThemeMode.light));
        break;
      case 'dark':
        emit(const ThemeState(ThemeMode.dark));
        break;
      default:
        emit(const ThemeState(ThemeMode.dark));
        break;
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    switch (themeMode) {
      case ThemeMode.system:
        await pref.setThemeMode('system');
        break;
      case ThemeMode.light:
        await pref.setThemeMode('light');
        break;
      case ThemeMode.dark:
        await pref.setThemeMode('dark');
        break;
      default:
        await pref.setThemeMode('system');
        break;
    }
    emit(ThemeState(themeMode));
  }
}
