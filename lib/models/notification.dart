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
            : NotificationChannel.fromJson(json['channel']),
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
