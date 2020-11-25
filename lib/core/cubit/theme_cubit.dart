import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/core/services/shared_preferences_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final sps = GetIt.I<SharedPreferencesService>();

  ThemeCubit() : super(ThemeState(ThemeMode.light));

  void resolveTheme() {
    final isDarkModeEnabled = sps.isDarkModeEnabled;

    if (isDarkModeEnabled == null) {
      emit(ThemeState(ThemeMode.system));
    } else {
      emit(ThemeState(isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light));
    }
  }

  void changeTheme(ThemeMode themeMode) async {
    if (themeMode == ThemeMode.system) {
      await sps.setDarkModeInfo(null);
    } else {
      await sps.setDarkModeInfo(themeMode == ThemeMode.dark ? true : false);
    }

    emit(ThemeState(themeMode));
  }
}
