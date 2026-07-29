import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:travel_app/core/networking/internet_checker/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connection;

  NetworkInfoImpl(this.connection);
  @override
  Future<bool> get isConnected async => await connection.hasInternetAccess;
}
