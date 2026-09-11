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
import 'package:travel_app/features/admin/trips/data/repo/admin_trip_manager_repo.dart';
import 'package:travel_app/features/admin/trips/data/repo/admin_trips_repo.dart';
import 'package:travel_app/features/admin/trips/data/repo/categories_repo.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trip_manager_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trips_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_cubit.dart';
import 'package:travel_app/features/admin/bookings/data/repo/admin_booking_repo.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';
import 'package:travel_app/core/services/google_service.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/explore/data/repo/explore_repo.dart';
import 'package:travel_app/features/user/explore/data/repo/explore_repo_implementation.dart';
import 'package:travel_app/features/user/explore/presentation/cubit/explore_cubit.dart';
import 'package:travel_app/features/user/home/data/repo/home_repo.dart';
import 'package:travel_app/features/user/home/data/repo/home_repo_implementation.dart';
import 'package:travel_app/features/user/home/presentation/cubit/home_cubit.dart';

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
  getIt.registerLazySingleton<GoogleService>(() => GoogleService());
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      apiConsumer: getIt<ApiConsumer>(),
      secureStorage: getIt<SecureStorageCaching>(),
    ),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      authRepo: getIt<AuthRepo>(),
      googleService: getIt<GoogleService>(),
    ),
  );

  // Features - Admin Dashboard
  getIt.registerLazySingleton<DashboardRepo>(
    () => DashboardRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<AdminDashboardCubit>(
    () => AdminDashboardCubit(dashboardRepo: getIt<DashboardRepo>()),
  );

  // Features - Admin Trips
  getIt.registerLazySingleton<AdminTripsRepo>(
    () => AdminTripsRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<AdminTripsCubit>(
    () => AdminTripsCubit(adminTripsRepo: getIt<AdminTripsRepo>()),
  );

  // Features - Categories
  getIt.registerLazySingleton<CategoriesRepo>(
    () => CategoriesRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(categoriesRepo: getIt<CategoriesRepo>()),
  );

  // Features - Admin Trip Manager (add / update / delete)
  getIt.registerLazySingleton<AdminTripManagerRepo>(
    () => AdminTripManagerRepoImpl(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<AdminTripManagerCubit>(
    () => AdminTripManagerCubit(
      adminTripManagerRepo: getIt<AdminTripManagerRepo>(),
    ),
  );

  // Features - Admin Bookings
  getIt.registerLazySingleton<AdminBookingRepo>(
    () => AdminBookingRepo(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<AdminBookingCubit>(
    () => AdminBookingCubit(adminBookingRepo: getIt<AdminBookingRepo>()),
  );

  // Features - User Home
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImplementation(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(homeRepo: getIt<HomeRepo>()),
  );

  // Features - User Explore
  getIt.registerLazySingleton<ExploreRepo>(
    () => ExploreRepoImplementation(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerFactory<ExploreCubit>(
    () => ExploreCubit(exploreRepo: getIt<ExploreRepo>()),
  );
}
