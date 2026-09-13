import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  static const String _channelId = 'rahala_notifications';
  static const String _channelName = 'Rahala Notifications';
  static const String _channelDescription = 'General notifications from Rahala';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings: settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? id,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      await _plugin.show(
        id: _notificationId(id),
        title: title.trim().isEmpty ? 'Rahala' : title.trim(),
        body: body.trim().isEmpty ? 'Rahala' : body.trim(),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      debugPrint('LocalNotificationService: show failed: $e');
    }
  }

  int _notificationId(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) {
      return Random().nextInt(1 << 30);
    }
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed.abs() % 2147483647;
    return value.hashCode.abs() % 2147483647;
  }
}
