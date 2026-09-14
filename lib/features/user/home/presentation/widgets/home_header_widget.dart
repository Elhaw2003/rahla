import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/di/dependency_injection.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_states.dart';

class HomeHeaderWidget extends StatefulWidget {
  const HomeHeaderWidget({super.key});

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  UserResponseModel? _user;
  StreamSubscription<ProfileStates>? _profileSub;

  @override
  void initState() {
    super.initState();
    _loadLocalUser();

    final profileCubit = getIt<ProfileCubit>();
    final current = profileCubit.currentUser;
    if (current != null) {
      _user = current;
    }

    _profileSub = profileCubit.stream.listen((state) {
      if (!mounted) return;
      if (state is ProfileSuccess) {
        setState(() => _user = state.user);
      } else if (state is ProfileUpdateSuccess) {
        setState(() => _user = state.user);
      }
    });
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    super.dispose();
  }

  Future<void> _loadLocalUser() async {
    final userJson = await getIt<SecureStorageCaching>().getUser();
    if (!mounted || userJson == null) return;
    setState(() {
      _user = UserResponseModel.fromJson(userJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.fullName?.trim();
    final imageUrl = _user?.fullProfileImageUrl ?? '';
    final avatarSize = 40.r;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              await context.push(RouteNames.profile);
              if (mounted) await _loadLocalUser();
            },
            borderRadius: BorderRadius.circular(AppSizes.r12),
            child: Row(
              children: [
                ClipOval(
                  child: imageUrl.isNotEmpty
                      ? AppNetworkImage(
                          imageUrl: imageUrl,
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: avatarSize,
                          height: avatarSize,
                          color: AppColors.divider,
                          child: Icon(
                            Icons.person,
                            color: AppColors.textHint,
                            size: 20.sp,
                          ),
                        ),
                ),
                AppSizes.p12.horizontalSpace,
                Expanded(
                  child: Text(
                    name?.isNotEmpty == true ? name! : '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSizes.p8.horizontalSpace,
        InkWell(
          onTap: () => context.push(RouteNames.notifications),
          borderRadius: BorderRadius.circular(AppSizes.r32),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.notifications_none,
              color: AppColors.textPrimary,
              size: 20.sp,
            ),
          ),
        ),
      ],
    ).paddingAll(AppSizes.p16);
  }
}
