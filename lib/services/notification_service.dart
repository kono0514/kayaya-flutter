import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kayaya_flutter/utils/graphql_client.dart';
import 'package:kayaya_flutter/models/notification.dart';
import 'package:kayaya_flutter/repositories/aniim_repository.dart';
import 'package:kayaya_flutter/services/shared_preferences_service.dart';
import 'package:kayaya_flutter/utils/utils.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService.private(
      FlutterLocalNotificationsPlugin(), FirebaseMessaging());
  final FlutterLocalNotificationsPlugin _localNotification;
  final FirebaseMessaging _firebaseMessaging;

  factory NotificationService() => _instance;

  NotificationService.private(FlutterLocalNotificationsPlugin localNotification,
      FirebaseMessaging firebaseMessaging)
      : _localNotification = localNotification,
        _firebaseMessaging = firebaseMessaging;

  void configure({
    MessageHandler onMessage,
    Function(String) onSelectNotification,
  }) {
    _localNotification.initialize(
      InitializationSettings(
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
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      uploadCurrentFcmToken(token: newToken);
    });
  }

  void uploadCurrentFcmToken({token}) async {
    var newToken = token ?? await _firebaseMessaging.getToken();
    print('Uploading firebase messaging token: $newToken');
    final oldToken = SharedPreferencesService.instance.currentSavedFcmToken;
    if (oldToken != newToken) {
      await AniimRepository().uploadFcmToken(newToken, oldToken: oldToken);
      SharedPreferencesService.instance.saveCurrentFcmToken(newToken);
    }
  }

  void showSubscriptionNotification(Notification notification) async {
    var largeIconPath;

    if (notification.image != null) {
      try {
        largeIconPath = await downloadFile(notification.image);
      } catch (e) {
        print(e);
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
          styleInformation: MediaStyleInformation(),
          importance: Importance.High,
        ),
        IOSNotificationDetails(),
      ),
      payload: notification.route,
    );
  }

  void showUpdateNotification(Notification notification) {
    _localNotification.show(
      5,
      notification.title,
      notification.body,
      NotificationDetails(
        AndroidNotificationDetails(
          '2',
          'New update',
          'When there\'s a new update available',
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
      NotificationDetails(
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
        IOSNotificationDetails(),
      ),
    );
  }
}

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  print('Received message in background');
  print(message);
  NotificationService _service = NotificationService();

  if (!message.containsKey('data')) return;
  final Notification notification =
      Notification.fromJson(Map.from(message['data']));

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
