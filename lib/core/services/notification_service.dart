import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:travel_app/core/di/dependency_injection.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/services/local_notification_service.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';

class NotificationService {
  NotificationService({
    required this.secureStorage,
    required this.localNotificationService,
  });

  final SecureStorageCaching secureStorage;
  final LocalNotificationService localNotificationService;

  Future<void> init() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    if (granted) {
      await localNotificationService.initialize();
    }

    debugPrint(
      granted
          ? 'NotificationService: permission granted'
          : 'NotificationService: permission not granted',
    );

    // iOS needs APNS before FCM token is available.
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.getAPNSToken();
    }

    final fcmToken = await getFcmToken();
    if (fcmToken.isNotEmpty) {
      await sendTokenToBackend(fcmToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(sendTokenToBackend);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title =
          message.notification?.title ??
          message.data['title']?.toString() ??
          '';
      final body =
          message.notification?.body ?? message.data['body']?.toString() ?? '';

      localNotificationService.showNotification(
        title: title,
        body: body,
        id: message.messageId,
        payload: message.data['bookingId']?.toString(),
      );
    });
  }

  static Future<String> getFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('NotificationService: FCM Token: $fcmToken');
      return fcmToken?.trim() ?? '';
    } catch (e) {
      debugPrint('NotificationService: failed to get FCM token: $e');
      return '';
    }
  }

  Future<void> sendTokenToBackend(String fcmToken) async {
    final token = fcmToken.trim();
    if (token.isEmpty) return;

    try {
      final isLoggedIn = await secureStorage.isLoggedIn();
      if (!isLoggedIn) return;
      if (!getIt.isRegistered<AuthRepo>()) return;

      await getIt<AuthRepo>().registerFcmToken(fcmToken: token);
      debugPrint('NotificationService: FCM token sent to backend');
    } catch (e) {
      debugPrint('NotificationService: failed to send FCM token: $e');
    }
  }
}
