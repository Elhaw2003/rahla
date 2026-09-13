import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/notifications/data/models/notification_model.dart';

class NotificationListCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationListCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData get _icon {
    if (notification.isBooking) return Icons.confirmation_number_outlined;
    if (notification.isPromo) return Icons.local_offer_outlined;
    return Icons.notifications_outlined;
  }

  Color get _accent {
    if (notification.isBooking) return AppColors.primary;
    if (notification.isPromo) return AppColors.secondary;
    return AppColors.info;
  }

  String get _timeLabel {
    final raw = notification.createdAt;
    if (raw == null || raw.isEmpty) return '';
    final date = DateTime.tryParse(raw)?.toLocal();
    if (date == null) return notification.formattedCreatedAt;

    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} ي';
    return notification.formattedCreatedAt;
  }

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;

    return Material(
      color: unread
          ? AppColors.secondary.withValues(alpha: 0.06)
          : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        side: BorderSide(
          color: unread
              ? AppColors.secondary.withValues(alpha: 0.25)
              : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: unread ? onTap : null,
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _accent, size: 22.sp),
              ),
              AppSizes.p12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title.isEmpty
                                ? 'إشعار'
                                : notification.title,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: unread
                                  ? FontWeight.w800
                                  : FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSizes.p8.horizontalSpace,
                        Text(
                          _timeLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    if (notification.body.isNotEmpty) ...[
                      AppSizes.p4.verticalSpace,
                      Text(
                        notification.body,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (notification.type.isNotEmpty) ...[
                      AppSizes.p8.verticalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.r8),
                        ),
                        child: Text(
                          notification.isBooking
                              ? 'حجز'
                              : notification.isPromo
                              ? 'عرض'
                              : notification.type,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: _accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (unread) ...[
                AppSizes.p8.horizontalSpace,
                Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(top: 6.h),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
