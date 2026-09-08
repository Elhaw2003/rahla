import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_states.dart';

class AdminBookingDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const AdminBookingDetailsPage({super.key, this.bookingData});

  @override
  State<AdminBookingDetailsPage> createState() =>
      _AdminBookingDetailsPageState();
}

class _AdminBookingDetailsPageState extends State<AdminBookingDetailsPage> {
  late String _currentStatus;

  Map<String, dynamic> get _data => widget.bookingData ?? const {};

  String _text(String key, [String fallback = '']) {
    final value = _data[key];
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  @override
  void initState() {
    super.initState();
    _currentStatus = _text('status', 'pending');
  }

  @override
  Widget build(BuildContext context) {
    final customerName = _text('customerName', 'محمد أحمد');
    final customerEmail = _text('customerEmail', 'mohamed@example.com');
    final customerPhone = _text('customerPhone', '+20 100 123 4567');
    final customerImage = _text('customerImage');

    final tripTitle = _text('tripTitle', 'شرم الشيخ');
    final tripDates = _text('tripDates', '20 - 22 يونيو 2025');
    final tripDuration = _text('tripDuration', '3 أيام / 2 ليلة');
    final tripImage = _text('tripImage', AppAssets.homeFeatured);
    final origin = _text('origin');
    final destination = _text('destination');

    final bookingNumber = _text('bookingNumber', '#TRP-250620');
    final requestDate = _text('requestDate', '15 يونيو 2025 - 10:30 ص');
    final passengersCount = _text('passengersCount', '2 بالغ');
    final paymentMethod = _text('paymentMethod');
    final totalAmount = _text('totalAmount', '6,000 ج.م');

    final customerNotes = widget.bookingData == null
        ? 'أتمنى توفير سيارة خاصة من وإلى المطار، ويفضل أن يكون الفندق في طابق علوي مع إطلالة مباشرة على البحر.'
        : _text('customerNotes');

    return BlocConsumer<AdminBookingCubit, AdminBookingStates>(
      listener: (context, state) {
        if (state is AdminBookingApproveSuccess) {
          setState(() => _currentStatus = 'accepted');
        } else if (state is AdminBookingRejectSuccess) {
          setState(() => _currentStatus = 'rejected');
        } else if (state is AdminBookingApproveError) {
          AppSnackbar.showError(context: context, message: state.error);
        } else if (state is AdminBookingRejectError) {
          AppSnackbar.showError(context: context, message: state.error);
        }
      },
      builder: (context, state) {
        final bookingId = _text('bookingId');
        final isApproveLoading =
            state is AdminBookingApproveLoading && state.bookingId == bookingId;
        final isRejectLoading =
            state is AdminBookingRejectLoading && state.bookingId == bookingId;
        final isBusy = isApproveLoading || isRejectLoading;

        return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isBusy ? null : () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          AppStrings.adminBookingDetailsTitle,
          style: AppTextStyles.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.p20,
                AppSizes.p16,
                AppSizes.p20,
                AppSizes.p24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBanner(),
                  AppSizes.p20.verticalSpace,
                  _buildSectionHeader(
                    title: AppStrings.adminCustomerDataSection,
                    icon: Icons.person_outline,
                  ),
                  AppSizes.p8.verticalSpace,
                  _buildCustomerCard(
                    name: customerName,
                    email: customerEmail,
                    phone: customerPhone,
                    imageUrl: customerImage,
                  ),
                  AppSizes.p24.verticalSpace,
                  _buildSectionHeader(
                    title: AppStrings.adminTripDataSection,
                    icon: Icons.card_travel_outlined,
                  ),
                  AppSizes.p8.verticalSpace,
                  _buildTripCard(
                    title: tripTitle,
                    duration: tripDuration,
                    dates: tripDates,
                    imagePath: tripImage,
                    origin: origin,
                    destination: destination,
                  ),
                  AppSizes.p24.verticalSpace,
                  _buildSectionHeader(
                    title: AppStrings.adminBookingDetailsSection,
                    icon: Icons.receipt_long_outlined,
                  ),
                  AppSizes.p8.verticalSpace,
                  _buildBookingDetailsCard(
                    bookingNumber: bookingNumber,
                    requestDate: requestDate,
                    passengersCount: passengersCount,
                    paymentMethod: paymentMethod,
                    totalAmount: totalAmount,
                  ),
                  if (customerNotes.isNotEmpty) ...[
                    AppSizes.p24.verticalSpace,
                    _buildSectionHeader(
                      title: AppStrings.adminCustomerNotesSection,
                      icon: Icons.chat_bubble_outline,
                    ),
                    AppSizes.p8.verticalSpace,
                    _buildCustomerNotesCard(notes: customerNotes),
                  ],
                ],
              ),
            ).expanded(),
            _buildBottomActionBar(
              context,
              customerPhone: customerPhone,
              isApproveLoading: isApproveLoading,
              isRejectLoading: isRejectLoading,
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppSizes.r12),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow.withValues(alpha: 0.05),
        blurRadius: 8.r,
        offset: Offset(0, 2.h),
      ),
    ],
  );

  Widget _buildStatusBanner() {
    Color bgColor;
    Color textColor;
    IconData iconData;
    String titleText;
    String descText;

    if (_currentStatus == 'accepted' || _currentStatus == 'approved') {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
      iconData = Icons.check_circle;
      titleText = AppStrings.adminBookingAcceptedTitle;
      descText = AppStrings.adminBookingAcceptedDesc;
    } else if (_currentStatus == 'rejected') {
      bgColor = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFC62828);
      iconData = Icons.cancel;
      titleText = AppStrings.adminBookingRejectedTitle;
      descText = AppStrings.adminBookingRejectedDesc;
    } else {
      bgColor = const Color(0xFFFFF8E1);
      textColor = const Color(0xFFF57F17);
      iconData = Icons.hourglass_top;
      titleText = AppStrings.adminBookingPendingTitle;
      descText = AppStrings.adminBookingPendingDesc;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.p8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: textColor, size: 22.r),
          ),
          AppSizes.p12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.h.verticalSpace,
              Text(
                descText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textColor.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.primary),
        AppSizes.p8.horizontalSpace,
        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard({
    required String name,
    required String email,
    required String phone,
    required String imageUrl,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: _cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(imageUrl),
          AppSizes.p12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (email.isNotEmpty) ...[
                6.h.verticalSpace,
                _buildIconText(Icons.email_outlined, email),
              ],
              if (phone.isNotEmpty) ...[
                4.h.verticalSpace,
                _buildIconText(Icons.phone_outlined, phone),
              ],
            ],
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildAvatar(String imageUrl) {
    return Container(
      width: 56.r,
      height: 56.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 2),
        color: AppColors.background,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.startsWith('http')
          ? AppNetworkImage(
              imageUrl: imageUrl,
              width: 56.r,
              height: 56.r,
              fit: BoxFit.cover,
            )
          : Icon(Icons.person, size: 30.r, color: AppColors.primary).center(),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.r, color: AppColors.textHint),
        6.w.horizontalSpace,
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ).expanded(),
      ],
    );
  }

  Widget _buildTripCard({
    required String title,
    required String duration,
    required String dates,
    required String imagePath,
    required String origin,
    required String destination,
  }) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTripCover(imagePath),
          Padding(
            padding: EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (origin.isNotEmpty || destination.isNotEmpty) ...[
                  AppSizes.p8.verticalSpace,
                  _buildRouteRow(origin, destination),
                ],
                AppSizes.p12.verticalSpace,
                _buildMetaRow(Icons.nightlight_round, duration),
                AppSizes.p8.verticalSpace,
                _buildMetaRow(Icons.calendar_today_outlined, dates),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCover(String imagePath) {
    final height = 148.h;
    Widget image;

    if (imagePath.startsWith('http')) {
      image = AppNetworkImage(
        imageUrl: imagePath,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (imagePath.isNotEmpty) {
      image = Image.asset(
        imagePath,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _coverFallback(height),
      );
    } else {
      image = _coverFallback(height);
    }

    return SizedBox(width: double.infinity, height: height, child: image);
  }

  Widget _coverFallback(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: AppColors.background,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textHint,
        size: 36.r,
      ).center(),
    );
  }

  Widget _buildRouteRow(String origin, String destination) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Row(
        children: [
          Icon(Icons.trip_origin, size: 14.r, color: AppColors.secondary),
          6.w.horizontalSpace,
          Text(
            origin.isEmpty ? '—' : origin,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ).expanded(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p8),
            child: Icon(
              Icons.arrow_forward,
              size: 16.r,
              color: AppColors.primary,
            ),
          ),
          Icon(Icons.place_outlined, size: 14.r, color: AppColors.secondary),
          6.w.horizontalSpace,
          Text(
            destination.isEmpty ? '—' : destination,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ).expanded(),
        ],
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: AppColors.textSecondary),
        AppSizes.p8.horizontalSpace,
        Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ).expanded(),
      ],
    );
  }

  Widget _buildBookingDetailsCard({
    required String bookingNumber,
    required String requestDate,
    required String passengersCount,
    required String paymentMethod,
    required String totalAmount,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: _cardDecoration,
      child: Column(
        children: [
          _buildDetailRow(
            AppStrings.adminBookingNumberLabel,
            bookingNumber,
            isHighlight: true,
          ),
          AppSizes.p12.verticalSpace,
          _buildDetailRow(AppStrings.adminRequestDateLabel, requestDate),
          AppSizes.p12.verticalSpace,
          _buildDetailRow(
            AppStrings.adminPassengersCountLabel,
            passengersCount,
          ),
          if (paymentMethod.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _buildDetailRow(AppStrings.adminPaymentMethodLabel, paymentMethod),
          ],
          AppSizes.p12.verticalSpace,
          const Divider(color: AppColors.divider),
          AppSizes.p8.verticalSpace,
          Row(
            children: [
              Text(
                AppStrings.adminTotalAmountLabel,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p8.horizontalSpace,
              Text(
                totalAmount,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        AppSizes.p12.horizontalSpace,
        Text(
          value,
          textAlign: TextAlign.end,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            color: isHighlight ? AppColors.primary : AppColors.textPrimary,
            height: 1.4,
          ),
        ).expanded(),
      ],
    );
  }

  Widget _buildCustomerNotesCard({required String notes}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: _cardDecoration,
      child: Text(
        notes,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context, {
    required String customerPhone,
    required bool isApproveLoading,
    required bool isRejectLoading,
  }) {
    final bookingId = _text('bookingId');
    final isPending =
        _currentStatus == 'pending' || _currentStatus == 'waiting';
    final isBusy = isApproveLoading || isRejectLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p12,
        AppSizes.p16,
        AppSizes.p16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 10.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isPending) ...[
            _buildActionButton(
              label: AppStrings.adminRejectRequest,
              icon: Icons.close,
              isPrimary: false,
              isLoading: isRejectLoading,
              onPressed: isBusy || bookingId.isEmpty
                  ? null
                  : () {
                      context.read<AdminBookingCubit>().rejectBooking(
                        bookingId,
                      );
                    },
            ).expanded(),
            AppSizes.p12.horizontalSpace,
            _buildActionButton(
              label: AppStrings.adminAcceptRequest,
              icon: Icons.check,
              isPrimary: true,
              isLoading: isApproveLoading,
              onPressed: isBusy || bookingId.isEmpty
                  ? null
                  : () {
                      context.read<AdminBookingCubit>().approveBooking(
                        bookingId,
                      );
                    },
            ).expanded(),
          ] else
            _buildActionButton(
              label: AppStrings.adminContactCustomer,
              icon: Icons.headset_mic_outlined,
              isPrimary: true,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'جاري الاتصال بالعميل على رقم $customerPhone...',
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ).expanded(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    final foreground = isPrimary ? Colors.white : AppColors.error;
    final child = isLoading
        ? SizedBox(
            height: 18.h,
            width: 18.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foreground,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 18.r),
              6.w.horizontalSpace,
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.bold,
                ),
              ).expanded(),
            ],
          );

    if (isPrimary) {
      return SizedBox(
        height: 48.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
          ),
        ),
        child: child,
      ),
    );
  }
}
