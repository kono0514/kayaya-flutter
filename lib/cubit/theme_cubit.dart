import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/shared_preferences_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeMode.light));

  void resolveTheme() async {
    final isDarkModeEnabled =
        (await SharedPreferencesService.instance).isDarkModeEnabled;

    if (isDarkModeEnabled == null) {
      emit(ThemeState(ThemeMode.system));
    } else {
      emit(ThemeState(isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light));
    }
  }

  void changeTheme(ThemeMode themeMode) async {
    final sharedPrefService = await SharedPreferencesService.instance;

    if (themeMode == ThemeMode.system) {
      await sharedPrefService.setDarkModeInfo(null);
    } else {
      await sharedPrefService
          .setDarkModeInfo(themeMode == ThemeMode.dark ? true : false);
    }

    emit(ThemeState(themeMode));
  }
}