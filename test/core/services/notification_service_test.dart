import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_app/core/di/dependency_injection.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/services/local_notification_service.dart';
import 'package:travel_app/core/services/notification_service.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';

import 'notification_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SecureStorageCaching>(),
  MockSpec<LocalNotificationService>(),
  MockSpec<AuthRepo>(),
])
void main() {
  late MockSecureStorageCaching secureStorage;
  late MockLocalNotificationService localNotificationService;
  late NotificationService notificationService;

  setUp(() async {
    await getIt.reset();
    secureStorage = MockSecureStorageCaching();
    localNotificationService = MockLocalNotificationService();
    notificationService = NotificationService(
      secureStorage: secureStorage,
      localNotificationService: localNotificationService,
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('sendTokenToBackend', () {
    test('ignores an empty token without checking login state', () async {
      await notificationService.sendTokenToBackend('  ');

      verifyNever(secureStorage.isLoggedIn());
    });

    test('does not send token when user is not logged in', () async {
      when(secureStorage.isLoggedIn()).thenAnswer((_) async => false);

      await notificationService.sendTokenToBackend('fcm-token');

      verify(secureStorage.isLoggedIn()).called(1);
      expect(getIt.isRegistered<AuthRepo>(), isFalse);
    });

    test('does not send token if AuthRepo is not registered', () async {
      when(secureStorage.isLoggedIn()).thenAnswer((_) async => true);

      await notificationService.sendTokenToBackend('fcm-token');

      verify(secureStorage.isLoggedIn()).called(1);
      expect(getIt.isRegistered<AuthRepo>(), isFalse);
    });

    test(
      'sends a trimmed token when logged in and AuthRepo is registered',
      () async {
        final authRepo = MockAuthRepo();
        when(secureStorage.isLoggedIn()).thenAnswer((_) async => true);
        when(
          authRepo.registerFcmToken(fcmToken: 'fcm-token'),
        ).thenAnswer((_) async => const Right(null));
        getIt.registerSingleton<AuthRepo>(authRepo);

        await notificationService.sendTokenToBackend('  fcm-token  ');

        verify(authRepo.registerFcmToken(fcmToken: 'fcm-token')).called(1);
      },
    );
  });
}
