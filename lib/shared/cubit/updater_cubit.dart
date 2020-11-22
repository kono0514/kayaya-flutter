import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:kayaya_flutter/shared/services/shared_preferences_service.dart';

part 'updater_state.dart';

class UpdaterCubit extends Cubit<UpdaterState> {
  final sps = GetIt.I<SharedPreferencesService>();

  UpdaterCubit() : super(UpdaterUninitialized());

  int get theme {
    final _isDarkModEnabled = sps.isDarkModeEnabled;
    if (_isDarkModEnabled == null) return 0;
    return _isDarkModEnabled ? 2 : 1;
  }

  Future<void> init() async {
    if (Platform.isAndroid) {
      await FlutterXUpdate.init(
        debug: false,
        isPost: false,
        isPostJson: false,
        isWifiOnly: false,
        isAutoMode: false,
        supportSilentInstall: false,
        enableRetry: false,
      );

      FlutterXUpdate.setErrorHandler(
        onUpdateError: (Map<String, dynamic> message) async {
          emit(UpdaterError(message));
        },
      );
    }

    emit(UpdaterInitial());
  }

  void checkForUpdate() {
    if (state is UpdaterUninitialized) return;

    emit(UpdaterInitial());

    FlutterXUpdate.checkUpdate(
      url: 'http://aniim-api.test/v1/update',
      theme: theme,
      locale: Intl.getCurrentLocale(),
    );
  }

  void resetErrors() {
    if (state is UpdaterUninitialized) return;

    emit(UpdaterInitial());
  }
}
