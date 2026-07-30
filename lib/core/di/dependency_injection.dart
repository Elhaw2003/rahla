import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/dio_consumer.dart';
import 'package:travel_app/core/networking/dio_factory.dart';
import 'package:travel_app/core/networking/internet_checker/network_info.dart';
import 'package:travel_app/core/networking/internet_checker/network_info_impl.dart';
import 'package:travel_app/features/admin/dashboard/data/repo/admin_dashboard_repo.dart';
import 'package:travel_app/features/admin/dashboard/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // External
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<InternetConnection>(() => InternetConnection());

  // Core - Cache
  getIt.registerLazySingleton<SecureStorageCaching>(
    () => SecureStorageCaching(getIt<FlutterSecureStorage>()),
  );

  // Core - Network
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<InternetConnection>()),
  );
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.createDio(getIt<SecureStorageCaching>()),
  );
  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(
      dio: getIt<Dio>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Features - Auth
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      apiConsumer: getIt<ApiConsumer>(),
      secureStorage: getIt<SecureStorageCaching>(),
    ),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authRepo: getIt<AuthRepo>()),
  );

  // Features - Admin Dashboard
  getIt.registerLazySingleton<DashboardRepo>(
    () => DashboardRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<AdminDashboardCubit>(
    () => AdminDashboardCubit(dashboardRepo: getIt<DashboardRepo>()),
  );
}
