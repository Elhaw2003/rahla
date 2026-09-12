import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/user_booking/presentation/cubit/user_booking_cubit.dart';
import 'package:travel_app/features/user/user_booking/presentation/cubit/user_booking_states.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/booking_details_hero.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/booking_details_notes_section.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/booking_details_shimmer.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/booking_details_ticket_card.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/booking_details_trip_section.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/user_bookings_empty_error.dart';

class UserBookingDetailsPage extends StatefulWidget {
  final String bookingId;

  const UserBookingDetailsPage({super.key, required this.bookingId});

  @override
  State<UserBookingDetailsPage> createState() => _UserBookingDetailsPageState();
}

class _UserBookingDetailsPageState extends State<UserBookingDetailsPage> {
  late final UserBookingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<UserBookingCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _cubit.getUserBookingById(widget.bookingId);
    });
  }

  @override
  void dispose() {
    // Restore list success so Home bookings tab stays populated.
    _cubit.restoreBookingsListState();
    super.dispose();
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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.bookingDetailsTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<UserBookingCubit, UserBookingStates>(
        buildWhen: (_, current) =>
            current is UserBookingDetailsLoadingStates ||
            current is UserBookingDetailsSuccessStates ||
            current is UserBookingDetailsErrorStates,
        builder: (context, state) {
          if (state is UserBookingDetailsLoadingStates) {
            return const AppLoading();
          }

          if (state is UserBookingDetailsErrorStates) {
            return UserBookingsErrorView(
              message: state.message,
              onRetry: () => context
                  .read<UserBookingCubit>()
                  .getUserBookingById(widget.bookingId),
            );
          }

          if (state is UserBookingDetailsSuccessStates) {
            final booking = state.booking;
            final notes = BookingDetailsNotesSection(booking: booking);

            return RefreshIndicator(
              color: AppColors.secondary,
              onRefresh: () => context
                  .read<UserBookingCubit>()
                  .getUserBookingById(widget.bookingId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppSizes.p16,
                  AppSizes.p8,
                  AppSizes.p16,
                  AppSizes.p32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BookingDetailsHero(booking: booking),
                    AppSizes.p16.verticalSpace,
                    BookingDetailsTicketCard(booking: booking),
                    AppSizes.p16.verticalSpace,
                    BookingDetailsTripSection(booking: booking),
                    if (notes.hasContent) ...[
                      AppSizes.p16.verticalSpace,
                      notes,
                    ],
                  ],
                ),
              ),
            );
          }

          return const BookingDetailsShimmer();
        },
      ),
    );
  }
}
