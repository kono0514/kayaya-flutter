import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../../core/services/preferences_service.dart';

part 'updater_state.dart';

@Injectable()
class UpdaterCubit extends Cubit<UpdaterState> {
  final PreferencesService pref;

  UpdaterCubit({@required this.pref}) : super(UpdaterUninitialized());

  int get theme {
    switch (pref.themeMode) {
      case 'system':
        return 0;
      case 'light':
        return 1;
      case 'dark':
        return 2;
      default:
        return 0;
    }
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
