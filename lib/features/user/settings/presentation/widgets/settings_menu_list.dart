import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_menu_item_widget.dart';

class SettingsMenuList extends StatelessWidget {
  const SettingsMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItemWidget(
          title: AppStrings.profilePersonalData,
          icon: Icons.person_outline,
          onTap: () => context.push(RouteNames.profile),
        ),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(
          title: AppStrings.favoritesTitle,
          icon: Icons.favorite_outline,
          onTap: () => context.push(RouteNames.favorites),
        ),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(
          title: AppStrings.notificationsTitle,
          icon: Icons.notifications_outlined,
          onTap: () => context.push(RouteNames.notifications),
        ),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(
          title: AppStrings.profileChangePassword,
          icon: Icons.lock_outline,
          onTap: () => context.push(RouteNames.changePassword),
        ),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(
          title: AppStrings.profileHelpSupport,
          icon: Icons.help_outline,
        ),
        AppSizes.p12.verticalSpace,
        ProfileMenuItemWidget(
          title: AppStrings.profileAboutApp,
          icon: Icons.info_outline,
        ),
      ],
    );
  }
}
