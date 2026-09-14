import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_logout_button.dart';
import 'package:travel_app/features/user/settings/presentation/widgets/settings_menu_list.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.settingsTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          children: [
            const SettingsMenuList(),
            AppSizes.p32.verticalSpace,
            const ProfileLogoutButton(),
            AppSizes.p32.verticalSpace,
          ],
        ),
      ),
    );
  }
}
