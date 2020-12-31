import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../../core/services/preferences_service.dart';
import '../../../../env_config.dart';

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
        // debug: true,
        isWifiOnly: false,
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
      url: EnvironmentConfig.updateServerEndpoint,
      theme: theme,
      locale: Intl.getCurrentLocale(),
    );
  }

  void resetErrors() {
    if (state is UpdaterUninitialized) return;

    emit(UpdaterInitial());
  }
}
