import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../codegen/graphql_api.graphql.dart';
import '../../core/usecase.dart';
import '../../env_config.dart';
import '../../layers/domain/usecases/authentication/is_logged_in_usecase.dart';
import '../utils/utils.dart';
import 'preferences_service.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin _localNotification;
  FirebaseMessaging _firebaseMessaging;

  NotificationService() {
    _localNotification = FlutterLocalNotificationsPlugin();
    _firebaseMessaging = FirebaseMessaging();
  }

  void configure({
    MessageHandler onMessage,
    Future<dynamic> Function(String) onSelectNotification,
  }) {
    _localNotification.initialize(
      const InitializationSettings(
        AndroidInitializationSettings('@mipmap/ic_launcher'),
        IOSInitializationSettings(),
      ),
      onSelectNotification: onSelectNotification,
    );
    _firebaseMessaging.configure(
      // When app is in foreground
      onMessage: onMessage,
      // When app is in background
      onBackgroundMessage: backgroundMessageHandler,
    );
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      final IsLoggedInUsecase isLoggedIn = GetIt.I();
      final _result = await isLoggedIn(NoParams());
      if (_result.isRight() && _result.getOrElse(() => false)) {
        uploadCurrentFcmToken(token: newToken);
      }
    });
  }

  Future<void> uploadCurrentFcmToken({String token}) async {
    if (EnvironmentConfig.isWarmupMode) return;

    final PreferencesService pref = GetIt.I();
    final GraphQLClient graphql = GetIt.I();

    final newToken = token ?? await _firebaseMessaging.getToken();
    final oldToken = pref.currentSavedFcmToken;
    if (oldToken != newToken) {
      debugPrint('Uploading firebase messaging token: $newToken');
      final args = UploadFcmTokenArguments(token: newToken, oldToken: oldToken);
      final result = await graphql.mutate(
        MutationOptions(
          document: UploadFcmTokenMutation().document,
          variables: args.toJson(),
        ),
      );

      if (result.hasException) {
        throw result.exception;
      }

      pref.saveCurrentFcmToken(newToken);
    }
  }

  Future<void> showSubscriptionNotification(Notification notification) async {
    String largeIconPath;

    if (notification.image != null) {
      try {
        largeIconPath = await downloadFile(notification.image);
      } catch (e) {
        debugPrint(
            'Failed to download notification image ${notification.image}');
      }
    }
    await _localNotification.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        AndroidNotificationDetails(
          '1',
          'Subscriptions',
          'When a new episode is released',
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation: const MediaStyleInformation(),
          importance: Importance.High,
        ),
        const IOSNotificationDetails(),
      ),
      payload: notification.route,
    );
  }

  void showUpdateNotification(Notification notification) {
    _localNotification.show(
      5,
      notification.title,
      notification.body,
      const NotificationDetails(
        AndroidNotificationDetails(
          '2',
          'New update',
          "When there's a new update available",
          importance: Importance.High,
        ),
        IOSNotificationDetails(),
      ),
    );
  }

  void showNormalNotification(Notification notification) {
    _localNotification.show(
      notification.id,
      notification.title,
      notification.body,
      const NotificationDetails(
        AndroidNotificationDetails(
            'fcm_fallback_notification_channel', 'Miscellaneous', ''),
        IOSNotificationDetails(),
      ),
    );
  }

  void showChannelNotification(Notification notification) {
    if (notification.channel == null) return;

    _localNotification.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        AndroidNotificationDetails(
          notification.channel.id,
          notification.channel.name,
          notification.channel.description ?? '',
          importance: Importance(notification.channel.importance),
        ),
        const IOSNotificationDetails(),
      ),
    );
  }
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  final NotificationService _service = NotificationService();

  if (!message.containsKey('data')) return;
  final Notification notification =
      Notification.fromJson(message['data'] as Map<String, dynamic>);

  if (notification.type == NotificationType.subscription) {
    _service.showSubscriptionNotification(notification);
  } else if (notification.type == NotificationType.update) {
    _service.showUpdateNotification(notification);
  } else if (notification.type == NotificationType.channel) {
    _service.showChannelNotification(notification);
  } else if (notification.type == NotificationType.normal) {
    _service.showNormalNotification(notification);
  }
}

enum NotificationType {
  subscription,
  update,
  normal,
  channel,
}

const _$NotificationTypeEnumMap = {
  NotificationType.subscription: 'subscription',
  NotificationType.update: 'update',
  NotificationType.normal: 'normal',
  NotificationType.channel: 'channel',
};

class Notification {
  final int id;
  final String title;
  final String body;
  final String image;
  final NotificationChannel channel;
  final NotificationType type;
  final String route;

  Notification.fromJson(Map<String, dynamic> json)
      : id = int.tryParse(json['id'] as String) ?? 0,
        title = json['title'] as String,
        body = json['body'] as String,
        image = json['image'] as String,
        channel = json['channel'] == null
            ? null
            : NotificationChannel.fromJson(
                json['channel'] as Map<String, dynamic>,
              ),
        type = _$enumDecodeNullable(
          _$NotificationTypeEnumMap,
          json['type'],
          unknownValue: NotificationType.normal,
        ),
        route = json['route'] as String;
}

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final int importance;

  NotificationChannel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        description = json['description'] as String,
        importance = int.tryParse(json['importance'] as String) ?? 3;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}
