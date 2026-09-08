import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/bookings/data/models/admin_booking_model.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_booking_card.dart';

class AdminBookingsList extends StatelessWidget {
  final List<AdminBookingModel> bookings;
  final bool isLoadingMore;
  final String approveLoadingId;
  final String rejectLoadingId;
  final ScrollController scrollController;

  const AdminBookingsList({
    super.key,
    required this.bookings,
    required this.isLoadingMore,
    required this.approveLoadingId,
    required this.rejectLoadingId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Text(
        AppStrings.favoritesEmpty,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ).center().expanded();
    }

    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.all(AppSizes.p20),
      itemCount: bookings.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => AppSizes.p16.verticalSpace,
      itemBuilder: (context, index) {
        if (index >= bookings.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.p16),
            child: const AppLoading(),
          );
        }

        final booking = bookings[index];
        return AdminBookingCard(
          bookingId: booking.id,
          customerName: booking.user.fullName,
          customerEmail: booking.user.email,
          customerPhone: booking.user.phone,
          customerImage: _imageUrl(booking.user.profileImage),
          tripTitle: booking.trip.title,
          tripDates: _formatDates(
            booking.trip.startDate,
            booking.trip.endDate,
          ),
          tripDuration: _formatDuration(
            booking.trip.startDate,
            booking.trip.endDate,
          ),
          totalAmount: _formatPrice(booking.totalPrice),
          passengersCount: '${booking.numberOfSeats} بالغ',
          tripImage: _imageUrl(booking.trip.coverImage),
          status: _cardStatus(booking.status),
          bookingNumber: _shortBookingNumber(booking.id),
          requestDate: _formatRequestDate(booking.createdAt),
          customerNotes: booking.notes,
          origin: booking.trip.origin,
          destination: booking.trip.destination,
          isApproveLoading: approveLoadingId == booking.id,
          isRejectLoading: rejectLoadingId == booking.id,
          onAccept: () {
            context.read<AdminBookingCubit>().approveBooking(booking.id);
          },
          onReject: () {
            context.read<AdminBookingCubit>().rejectBooking(booking.id);
          },
        );
      },
    ).expanded();
  }

  String _imageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  String _formatPrice(num price) {
    return '${NumberFormat('#,###').format(price)} ${AppStrings.currencyEGP}';
  }

  String _formatDates(DateTime start, DateTime end) {
    final format = DateFormat('d MMM yyyy', 'ar');
    return '${format.format(start)} - ${format.format(end)}';
  }

  String _formatDuration(DateTime start, DateTime end) {
    final days = end.difference(start).inDays.abs();
    if (days <= 1) return '1 يوم / 1 ليلة';
    return '$days أيام / ${days - 1} ليلة';
  }

  String _formatRequestDate(DateTime date) {
    return DateFormat('d MMMM yyyy - hh:mm a', 'ar').format(date.toLocal());
  }

  String _shortBookingNumber(String id) {
    if (id.isEmpty) return '';
    final short = id.length > 8 ? id.substring(id.length - 8) : id;
    return '#${short.toUpperCase()}';
  }

  String _cardStatus(String status) {
    if (status == 'approved') return 'accepted';
    return status;
  }
}
