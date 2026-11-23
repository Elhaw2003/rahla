import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_app/core/services/local_notification_service.dart';

import 'local_notification_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterLocalNotificationsPlugin>()])
void main() {
  late MockFlutterLocalNotificationsPlugin plugin;
  late LocalNotificationService service;

  setUp(() {
    plugin = MockFlutterLocalNotificationsPlugin();
    service = LocalNotificationService(plugin: plugin);
    when(
      plugin.initialize(settings: anyNamed('settings')),
    ).thenAnswer((_) async => true);
  });

  group('initialize', () {
    test('initializes the plugin only once', () async {
      await service.initialize();
      await service.initialize();

      verify(plugin.initialize(settings: anyNamed('settings'))).called(1);
    });
  });

  group('showNotification', () {
    test('initializes and uses defaults for blank title and body', () async {
      await service.showNotification(
        title: '  ',
        body: '',
        id: '42',
        payload: 'booking-1',
      );

      verify(
        plugin.show(
          id: 42,
          title: 'Rahala',
          body: 'Rahala',
          notificationDetails: anyNamed('notificationDetails'),
          payload: 'booking-1',
        ),
      ).called(1);
      verify(plugin.initialize(settings: anyNamed('settings'))).called(1);
    });

    test('trims title and body and normalizes a negative numeric id', () async {
      await service.showNotification(
        title: '  Trip update  ',
        body: '  Your booking changed  ',
        id: '-17',
      );

      verify(
        plugin.show(
          id: 17,
          title: 'Trip update',
          body: 'Your booking changed',
          notificationDetails: anyNamed('notificationDetails'),
          payload: null,
        ),
      ).called(1);
    });

    test('does not throw when plugin fails to display notification', () async {
      when(
        plugin.show(
          id: 1,
          title: 'Title',
          body: 'Body',
          notificationDetails: anyNamed('notificationDetails'),
          payload: null,
        ),
      ).thenThrow(StateError('plugin failure'));

      await expectLater(
        service.showNotification(title: 'Title', body: 'Body', id: '1'),
        completes,
      );
    });
  });
}
