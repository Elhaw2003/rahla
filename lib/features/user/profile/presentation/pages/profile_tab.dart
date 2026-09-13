import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_states.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_error_view.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_header.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_loading_view.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_logout_button.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_menu_list.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileCubit>().getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.profileTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.push(RouteNames.notifications),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () => context.push(RouteNames.settings),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const ProfileLoadingView();
          }

          if (state is ProfileFailure) {
            return ProfileErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().getUserProfile(),
            );
          }

          if (state is ProfileSuccess) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p24),
              child: Column(
                children: [
                  ProfileHeader(user: state.user),
                  AppSizes.p32.verticalSpace,
                  const ProfileMenuList(),
                  AppSizes.p32.verticalSpace,
                  const ProfileLogoutButton(),
                  AppSizes.p32.verticalSpace,
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
