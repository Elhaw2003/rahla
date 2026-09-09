import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/di/dependency_injection.dart';
import 'package:travel_app/features/user/not_found/presentation/pages/not_found_page.dart';
import 'package:travel_app/features/user/splash/presentation/pages/splash_page.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/pages/login_page.dart';
import 'package:travel_app/features/user/auth/presentation/pages/register_page.dart';
import 'package:travel_app/features/user/home/presentation/cubit/home_cubit.dart';
import 'package:travel_app/features/user/home/presentation/pages/home_page.dart';
import 'package:travel_app/features/user/home/presentation/pages/trip_details_page.dart';
import 'package:travel_app/features/user/bookings/presentation/pages/booking_confirmation_page.dart';
import 'package:travel_app/features/user/bookings/presentation/pages/booking_details_page.dart';
import 'package:travel_app/features/user/profile/presentation/pages/profile_page.dart';
import 'package:travel_app/features/user/settings/presentation/pages/settings_page.dart';
import 'package:travel_app/features/admin/dashboard/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:travel_app/features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trip_manager_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trips_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/pages/add_trip_page.dart';
import 'package:travel_app/features/admin/trips/presentation/pages/admin_trips_page.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';
import 'package:travel_app/features/admin/bookings/presentation/pages/admin_bookings_page.dart';
import 'package:travel_app/features/admin/bookings/presentation/pages/admin_booking_details_page.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<HomeCubit>()),
            BlocProvider(create: (_) => getIt<CategoriesCubit>()),
          ],
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: RouteNames.tripDetails,
        name: RouteNames.tripDetails,
        builder: (context, state) => const TripDetailsPage(),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmation,
        name: RouteNames.bookingConfirmation,
        builder: (context, state) => const BookingConfirmationPage(),
      ),
      GoRoute(
        path: RouteNames.bookingDetails,
        name: RouteNames.bookingDetails,
        builder: (context, state) => const BookingDetailsPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AdminDashboardCubit>()..getAdminStats(),
          child: const AdminDashboardPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.adminTrips,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AdminTripsCubit>()..getAdminTrips(),
          child: const AdminTripsPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.adminBookings,
        builder: (context, state) {
          final tripTitle = state.extra as String?;
          return BlocProvider(
            create: (_) => getIt<AdminBookingCubit>()..getAdminBookings(),
            child: AdminBookingsPage(initialTripFilter: tripTitle),
          );
        },
      ),
      GoRoute(
        path: RouteNames.addTrip,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<CategoriesCubit>()..getCategories(),
            ),
            BlocProvider(create: (_) => getIt<AdminTripManagerCubit>()),
          ],
          child: const AddTripPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.adminBookingDetails,
        builder: (context, state) {
          final bookingData = state.extra as Map<String, dynamic>?;
          return AdminBookingDetailsPage(bookingData: bookingData);
        },
      ),
    ],
  );
}
