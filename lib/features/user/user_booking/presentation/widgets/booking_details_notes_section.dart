import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';

class BookingDetailsNotesSection extends StatelessWidget {
  final UserBookingModel booking;

  const BookingDetailsNotesSection({super.key, required this.booking});

  bool get _hasNotes => booking.notes.trim().isNotEmpty;
  bool get _hasRejection => booking.rejectionReason.trim().isNotEmpty;
  bool get _hasCancellation => booking.cancellationReason.trim().isNotEmpty;

  bool get hasContent => _hasNotes || _hasRejection || _hasCancellation;

  @override
  Widget build(BuildContext context) {
    if (!hasContent) return const SizedBox.shrink();

    return Column(
      children: [
        if (_hasNotes)
          _NoteCard(
            title: 'ملاحظاتك',
            message: booking.notes.trim(),
            icon: Icons.sticky_note_2_outlined,
            accent: AppColors.info,
          ),
        if (_hasRejection) ...[
          if (_hasNotes) AppSizes.p12.verticalSpace,
          _NoteCard(
            title: 'سبب الرفض',
            message: booking.rejectionReason.trim(),
            icon: Icons.cancel_outlined,
            accent: AppColors.error,
          ),
        ],
        if (_hasCancellation) ...[
          if (_hasNotes || _hasRejection) AppSizes.p12.verticalSpace,
          _NoteCard(
            title: 'سبب الإلغاء',
            message: booking.cancellationReason.trim(),
            icon: Icons.block_rounded,
            accent: AppColors.warning,
          ),
        ],
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color accent;

  const _NoteCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 22.sp),
          AppSizes.p12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSizes.p4.verticalSpace,
                Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
