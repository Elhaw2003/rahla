import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_states.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_details_card.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_error_view.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_header.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_loading_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileCubit>().getUserProfile();
    });
  }

  UserResponseModel? _userFrom(ProfileStates state) {
    if (state is ProfileSuccess) return state.user;
    if (state is ProfileUpdating) return state.user;
    if (state is ProfileUpdateSuccess) return state.user;
    if (state is ProfileUpdateFailure) return state.user;
    return context.read<ProfileCubit>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.profileTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            tooltip: AppStrings.profileEditAccount,
            onPressed: () => context.push(RouteNames.editProfile),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          final user = _userFrom(state);

          if (user == null &&
              (state is ProfileLoading || state is ProfileInitial)) {
            return const ProfileLoadingView();
          }

          if (user == null && state is ProfileFailure) {
            return ProfileErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().getUserProfile(),
            );
          }

          if (user != null) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p24),
              child: Column(
                children: [
                  ProfileHeader(user: user),
                  AppSizes.p32.verticalSpace,
                  ProfileDetailsCard(user: user),
                  AppSizes.p32.verticalSpace,
                  AppButton(
                    text: AppStrings.profileEditAccount,
                    icon: Icon(Icons.edit_outlined, size: 18.sp, color: Colors.white),
                    onPressed: () => context.push(RouteNames.editProfile),
                  ),
                  AppSizes.p24.verticalSpace,
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
