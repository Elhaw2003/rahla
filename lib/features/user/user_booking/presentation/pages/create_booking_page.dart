import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/user_booking/presentation/cubit/user_booking_cubit.dart';
import 'package:travel_app/features/user/user_booking/presentation/cubit/user_booking_states.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/create_booking_bottom_bar.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/create_booking_notes_field.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/create_booking_price_summary.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/create_booking_seats_stepper.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/create_booking_trip_card.dart';

class CreateBookingPage extends StatefulWidget {
  final AdminTripModel trip;

  const CreateBookingPage({super.key, required this.trip});

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final TextEditingController _notesController = TextEditingController();
  late int _seats;

  AdminTripModel get trip => widget.trip;

  int get _maxSeats {
    if (trip.availableSeats <= 0) return 1;
    return trip.availableSeats;
  }

  num get _totalPrice => trip.price * _seats;

  @override
  void initState() {
    super.initState();
    _seats = _maxSeats >= 1 ? 1 : 1;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final tripId = trip.id?.trim() ?? '';
    if (tripId.isEmpty) {
      AppSnackbar.showError(
        context: context,
        message: 'تعذر إتمام الحجز، بيانات الرحلة غير مكتملة',
      );
      return;
    }

    context.read<UserBookingCubit>().createUserBooking(
      tripId: tripId,
      numberOfSeats: _seats,
      notes: _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBookingCubit, UserBookingStates>(
      listenWhen: (_, current) =>
          current is UserBookingCreateSuccessStates ||
          current is UserBookingCreateErrorStates,
      listener: (context, state) {
        if (state is UserBookingCreateSuccessStates) {
          AppSnackbar.showSuccess(context: context, message: state.message);
          final bookingId = state.userBooking.id.trim();
          if (bookingId.isEmpty) {
            context.pop(true);
            return;
          }
          context.pushReplacement(
            RouteNames.bookingDetailsPath(bookingId),
          );
        } else if (state is UserBookingCreateErrorStates) {
          AppSnackbar.showError(context: context, message: state.message);
        }
      },
      buildWhen: (_, current) =>
          current is UserBookingCreateLoadingStates ||
          current is UserBookingCreateSuccessStates ||
          current is UserBookingCreateErrorStates ||
          current is UserBookingInitialStates,
      builder: (context, state) {
        final isLoading = state is UserBookingCreateLoadingStates;

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
              onPressed: isLoading ? null : () => context.pop(),
            ),
            title: Text(
              AppStrings.bookingConfirmationTitle,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSizes.p24,
              AppSizes.p8,
              AppSizes.p24,
              AppSizes.p24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CreateBookingTripCard(trip: trip),
                AppSizes.p24.verticalSpace,
                CreateBookingSeatsStepper(
                  seats: _seats,
                  maxSeats: _maxSeats,
                  pricePerSeat: trip.price,
                  onChanged: (value) => setState(() => _seats = value),
                ),
                AppSizes.p24.verticalSpace,
                CreateBookingNotesField(controller: _notesController),
                AppSizes.p24.verticalSpace,
                CreateBookingPriceSummary(
                  seats: _seats,
                  pricePerSeat: trip.price,
                  totalPrice: _totalPrice,
                ),
                AppSizes.p16.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    AppSizes.p8.horizontalSpace,
                    Expanded(
                      child: Text(
                        '${AppStrings.bookingConfirmationBookingPolicyAgree} ${AppStrings.bookingConfirmationBookingPolicy}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSizes.p24.verticalSpace,
              ],
            ),
          ),
          bottomNavigationBar: CreateBookingBottomBar(
            totalPrice: _totalPrice,
            isLoading: isLoading,
            onConfirm: isLoading ? null : _onConfirm,
          ),
        );
      },
    );
  }
}
