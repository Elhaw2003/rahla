import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';
import 'package:travel_app/features/user/user_booking/presentation/cubit/user_booking_cubit.dart';
import 'package:travel_app/features/user/user_booking/presentation/cubit/user_booking_states.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/user_booking_list_card.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/user_bookings_empty_error.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/user_bookings_filters.dart';
import 'package:travel_app/features/user/user_booking/presentation/widgets/user_bookings_shimmer_loading.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final ScrollController _scrollController = ScrollController();
  UserBookingsFilter _filter = UserBookingsFilter.all;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UserBookingCubit>().getUserBookings();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UserBookingCubit>().loadMoreUserBookings();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<UserBookingCubit>().getUserBookings();
  }

  List<UserBookingModel> _filtered(List<UserBookingModel> bookings) {
    switch (_filter) {
      case UserBookingsFilter.all:
        return bookings;
      case UserBookingsFilter.approved:
        return bookings.where((b) => b.status == 'approved').toList();
      case UserBookingsFilter.pending:
        return bookings.where((b) => b.status == 'pending').toList();
      case UserBookingsFilter.cancelled:
        return bookings
            .where((b) => b.status == 'cancelled' || b.status == 'rejected')
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.p16,
              AppSizes.p16,
              AppSizes.p16,
              AppSizes.p8,
            ),
            child: Text(
              AppStrings.bookingsTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          UserBookingsFilters(
            selected: _filter,
            onSelected: (value) => setState(() => _filter = value),
          ),
          AppSizes.p8.verticalSpace,
          Expanded(
            child: BlocBuilder<UserBookingCubit, UserBookingStates>(
              buildWhen: (previous, current) =>
                  current is UserBookingLoadingStates ||
                  current is UserBookingSuccessStates ||
                  current is UserBookingErrorStates ||
                  current is UserBookingInitialStates,
              builder: (context, state) {
                if (state is UserBookingLoadingStates ||
                    state is UserBookingInitialStates) {
                  return const UserBookingsShimmerLoading();
                }

                if (state is UserBookingErrorStates) {
                  return UserBookingsErrorView(
                    message: state.message,
                    onRetry: () =>
                        context.read<UserBookingCubit>().getUserBookings(),
                  );
                }

                if (state is UserBookingSuccessStates) {
                  final bookings = _filtered(state.userBookingsList);
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.secondary,
                    child: bookings.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 120),
                              UserBookingsEmptyView(),
                            ],
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              AppSizes.p16,
                              AppSizes.p8,
                              AppSizes.p16,
                              AppSizes.p24,
                            ),
                            itemCount:
                                bookings.length + (state.isLoadingMore ? 1 : 0),
                            separatorBuilder: (_, _) =>
                                AppSizes.p12.verticalSpace,
                            itemBuilder: (context, index) {
                              if (index >= bookings.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSizes.p12,
                                  ),
                                  child: const AppLoading(size: 28),
                                );
                              }
                              final booking = bookings[index];
                              return UserBookingListCard(
                                booking: booking,
                                onTap: () {
                                  if (booking.id.isEmpty) return;
                                  context.push(
                                    RouteNames.bookingDetailsPath(booking.id),
                                  );
                                },
                              );
                            },
                          ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
