import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';

import '../../../../core/services/preferences_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../../env_config.dart';

part 'updater_state.dart';

@Injectable()
class UpdaterCubit extends Cubit<UpdaterState> {
  final PreferencesService pref;
  int buildNumber;

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
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      buildNumber = int.parse(packageInfo.buildNumber);
    } catch (e, s) {
      errorLog(e, s);
    }

    if (Platform.isAndroid) {
      await FlutterXUpdate.init(
        debug: true,
        isWifiOnly: false,
      );

      // AppCenter JSON parsing
      FlutterXUpdate.setCustomParseHandler(onUpdateParse: (String json) async {
        UpdateEntity entity;
        try {
          final _json = jsonDecode(json) as Map<String, dynamic>;
          final _versionCode = int.parse(_json['version'] as String);
          entity = UpdateEntity(
            hasUpdate: _json['enabled'] as bool && _versionCode > buildNumber,
            isForce: _json['mandatory_update'] as bool,
            isIgnorable: false,
            versionCode: _versionCode,
            versionName: _json['short_version'] as String,
            apkMd5: _json['fingerprint'] as String,
            apkSize: ((_json['size'] as int) / 1000).round(),
            downloadUrl: _json['download_url'] as String,
            updateContent: _json['release_notes'] as String,
            showNotification: true,
          );
        } catch (e, s) {
          errorLog(e, s);
        }
        return entity;
      });

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
    if (EnvironmentConfig.appcenterUpdateServerEndpoint == '') return;
    if (buildNumber == null) return;

    emit(UpdaterInitial());

    FlutterXUpdate.checkUpdate(
      url: EnvironmentConfig.appcenterUpdateServerEndpoint,
      isCustomParse: true,
      theme: theme,
      locale: Intl.getCurrentLocale(),
    );
  }

  void resetErrors() {
    if (state is UpdaterUninitialized) return;

    emit(UpdaterInitial());
  }
}
