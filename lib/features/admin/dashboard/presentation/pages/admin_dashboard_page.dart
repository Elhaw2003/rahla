import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/dashboard/data/models/admin_dashboard_stats_model.dart';
import 'package:travel_app/features/admin/dashboard/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:travel_app/features/admin/dashboard/presentation/cubit/admin_dashboard_states.dart';
import 'package:travel_app/features/admin/dashboard/presentation/widgets/admin_stat_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  String _formatNumber(num value) {
    return NumberFormat('#,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.adminDashboardTitle,
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.adminSwitchUserMode,
            icon: const Icon(Icons.swap_horiz, color: AppColors.primary),
            onPressed: () => context.go(RouteNames.home),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<AdminDashboardCubit, AdminDashboardStates>(
          listener: (context, state) {
            if (state is AdminDashboardFailure) {
              AppSnackbar.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            if (state is AdminDashboardLoading ||
                state is AdminDashboardInitial) {
              return const AppLoading();
            }

            if (state is AdminDashboardFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.p24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSizes.p16.verticalSpace,
                      AppButton(
                        text: 'إعادة المحاولة',
                        onPressed: () =>
                            context.read<AdminDashboardCubit>().getAdminStats(),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is AdminDashboardSuccess) {
              final data = state.adminStats.data;
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<AdminDashboardCubit>().getAdminStats(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(AppSizes.p20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildWelcomeCard(),
                      AppSizes.p20.verticalSpace,
                      Text(
                        AppStrings.adminOverview,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p12.verticalSpace,
                      _buildStatsGrid(context, data),
                      AppSizes.p24.verticalSpace,
                      Text(
                        AppStrings.adminQuickActions,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p12.verticalSpace,
                      _buildManagementSection(context),
                      AppSizes.p24.verticalSpace,
                      AppButton.outlined(
                        text: AppStrings.adminSwitchUserMode,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                        ),
                        onPressed: () => context.go(RouteNames.home),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Icon(
              Icons.admin_panel_settings,
              size: 32.r,
              color: Colors.white,
            ),
          ),
          AppSizes.p16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.adminWelcomeMessage,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSizes.p4.verticalSpace,
              Text(
                AppStrings.adminDashboardTitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, AdminStatsData? data) {
    final totalTrips = data?.trips?.totalActiveTrips ?? 0;
    final totalBookings = data?.bookings?.totalBookings ?? 0;
    final pendingBookings = data?.bookings?.pendingBookings ?? 0;
    final totalRevenue = data?.financials?.totalRevenue ?? 0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.p12,
      mainAxisSpacing: AppSizes.p12,
      childAspectRatio: 1.2,
      children: [
        AdminStatCard(
          title: AppStrings.adminTotalTrips,
          value: _formatNumber(totalTrips),
          icon: Icons.card_travel,
          color: AppColors.primary,
          onTap: () => context.push(RouteNames.adminTrips),
        ),
        AdminStatCard(
          title: AppStrings.adminTotalBookings,
          value: _formatNumber(totalBookings),
          icon: Icons.confirmation_number_outlined,
          color: Colors.purple,
          onTap: () => context.push(RouteNames.adminBookings),
        ),
        AdminStatCard(
          title: AppStrings.adminPendingBookings,
          value: _formatNumber(pendingBookings),
          icon: Icons.hourglass_empty,
          color: Colors.orange,
          onTap: () => context.push(RouteNames.adminBookings),
        ),
        AdminStatCard(
          title: AppStrings.adminTotalRevenue,
          value: '${_formatNumber(totalRevenue)} ${AppStrings.currencyEGP}',
          icon: Icons.attach_money,
          color: Colors.green,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildManagementSection(BuildContext context) {
    return Column(
      children: [
        _buildActionTile(
          context,
          title: AppStrings.adminAddTripTitle,
          subtitle: 'إضافة رحلة جديدة للبرنامج وتحديد التفاصيل والأسعار',
          icon: Icons.add_circle_outline,
          color: AppColors.primary,
          onTap: () => context.push(RouteNames.addTrip),
        ),
        AppSizes.p12.verticalSpace,
        _buildActionTile(
          context,
          title: AppStrings.adminTripsTitle,
          subtitle: 'عرض وتعديل وتفعيل أو تعطيل الرحلات المتاحة',
          icon: Icons.list_alt,
          color: Colors.blue,
          onTap: () => context.push(RouteNames.adminTrips),
        ),
        AppSizes.p12.verticalSpace,
        _buildActionTile(
          context,
          title: AppStrings.adminBookingRequestsTitle,
          subtitle: 'مراجعة طلبات الحجز وقبولها أو رفضها',
          icon: Icons.fact_check_outlined,
          color: Colors.orange,
          onTap: () => context.push(RouteNames.adminBookings),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            AppSizes.p16.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSizes.p4.verticalSpace,
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ).expanded(),
            Icon(Icons.chevron_right, color: AppColors.textHint, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
