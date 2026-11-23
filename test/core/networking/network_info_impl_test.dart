import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_app/core/networking/internet_checker/network_info_impl.dart';

import 'network_info_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InternetConnection>()])
void main() {
  late MockInternetConnection connection;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    connection = MockInternetConnection();
    networkInfo = NetworkInfoImpl(connection);
  });

  group('NetworkInfoImpl', () {
    test('returns true when internet is available', () async {
      when(connection.hasInternetAccess).thenAnswer((_) async => true);

      expect(await networkInfo.isConnected, isTrue);
      verify(connection.hasInternetAccess).called(1);
    });

    test('returns false when internet is unavailable', () async {
      when(connection.hasInternetAccess).thenAnswer((_) async => false);

      expect(await networkInfo.isConnected, isFalse);
      verify(connection.hasInternetAccess).called(1);
    });
  });
}
