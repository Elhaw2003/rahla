import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/features/user/home/presentation/pages/tabs/bookings_tab.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_states.dart';
import 'package:travel_app/features/user/profile/presentation/pages/profile_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/notifications_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeTab(),
    NotificationsTab(),
    BookingsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesStates>(
      listenWhen: (_, current) =>
          current is FavoritesToggleSuccess ||
          current is FavoritesToggleFailure,
      listener: (context, state) {
        if (state is FavoritesToggleSuccess) {
          AppSnackbar.showSuccess(
            context: context,
            message: state.message,
            actionLabel: state.isFavorite ? AppStrings.viewAll : null,
            onAction: state.isFavorite
                ? () => context.push(RouteNames.favorites)
                : null,
          );
        } else if (state is FavoritesToggleFailure) {
          AppSnackbar.showError(context: context, message: state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(index: _currentIndex, children: _pages),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: AppStrings.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_outlined),
              activeIcon: const Icon(Icons.notifications),
              label: AppStrings.navNotifications,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark_outline),
              activeIcon: const Icon(Icons.bookmark),
              label: AppStrings.navBookings,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: AppStrings.homeNavMore,
            ),
          ],
        ),
      ),
    );
  }
}
