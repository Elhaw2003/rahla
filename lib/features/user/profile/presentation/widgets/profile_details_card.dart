import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_detail_row.dart';

class ProfileDetailsCard extends StatelessWidget {
  final UserResponseModel user;

  const ProfileDetailsCard({super.key, required this.user});

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final date = DateTime.tryParse(raw);
    if (date == null) return raw;
    return DateFormat('d MMMM yyyy', 'ar').format(date.toLocal());
  }

  String _providerLabel(String? provider) {
    switch (provider?.toLowerCase()) {
      case 'google':
        return AppStrings.profileProviderGoogle;
      case 'local':
      case 'email':
        return AppStrings.profileProviderEmail;
      default:
        return provider?.isNotEmpty == true ? provider! : '—';
    }
  }

  String _roleLabel(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return AppStrings.profileRoleAdmin;
      case 'user':
        return AppStrings.profileRoleUser;
      default:
        return role?.isNotEmpty == true ? role! : '—';
    }
  }

  String _shortId(String? id) {
    if (id == null || id.isEmpty) return '—';
    if (id.length <= 10) return id;
    return '${id.substring(0, 6)}…${id.substring(id.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.profileDetailsSection,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSizes.p12.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p8,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.r16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              ProfileDetailRow(
                icon: Icons.email_outlined,
                label: AppStrings.emailLabel,
                value: user.email ?? '',
              ),
              const Divider(height: 1, color: AppColors.border),
              ProfileDetailRow(
                icon: Icons.phone_outlined,
                label: AppStrings.phoneLabel,
                value: user.phone ?? '',
              ),
              const Divider(height: 1, color: AppColors.border),
              ProfileDetailRow(
                icon: Icons.badge_outlined,
                label: AppStrings.profileRoleLabel,
                value: _roleLabel(user.role),
              ),
              const Divider(height: 1, color: AppColors.border),
              ProfileDetailRow(
                icon: Icons.login_outlined,
                label: AppStrings.profileProviderLabel,
                value: _providerLabel(user.authProvider),
              ),
              const Divider(height: 1, color: AppColors.border),
              ProfileDetailRow(
                icon: Icons.calendar_today_outlined,
                label: AppStrings.profileJoinedAt,
                value: _formatDate(user.createdAt),
              ),
              const Divider(height: 1, color: AppColors.border),
              ProfileDetailRow(
                icon: Icons.update_outlined,
                label: AppStrings.profileUpdatedAt,
                value: _formatDate(user.updatedAt),
              ),
              const Divider(height: 1, color: AppColors.border),
              ProfileDetailRow(
                icon: Icons.fingerprint_outlined,
                label: AppStrings.profileAccountId,
                value: _shortId(user.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
