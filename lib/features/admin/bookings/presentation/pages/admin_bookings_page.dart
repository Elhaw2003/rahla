import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_states.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_booking_card.dart';

class AdminBookingsPage extends StatefulWidget {
  final String? initialTripFilter;

  const AdminBookingsPage({super.key, this.initialTripFilter});

  @override
  State<AdminBookingsPage> createState() => _AdminBookingsPageState();
}

class _AdminBookingsPageState extends State<AdminBookingsPage> {
  final ScrollController _scrollController = ScrollController();

  static const _filterStatuses = ['all', 'pending', 'approved', 'rejected'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final initialTrip = widget.initialTripFilter;
    if (initialTrip != null && initialTrip.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<AdminBookingCubit>().selectTrip(initialTrip);
      });
    }
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
      context.read<AdminBookingCubit>().loadMore();
    }
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

  String _cardStatus(String status) {
    if (status == 'approved') return 'accepted';
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBookingCubit, AdminBookingStates>(
      listener: (context, state) {
        if (state is AdminBookingError) {
          AppSnackbar.showError(context: context, message: state.error);
        }
      },
      builder: (context, state) {
        final pendingCount = state is AdminBookingSuccess
            ? state.pendingBookingsCount
            : 0;
        final acceptedCount = state is AdminBookingSuccess
            ? state.approvedBookingsCount
            : 0;
        final rejectedCount = state is AdminBookingSuccess
            ? state.rejectedBookingsCount
            : 0;
        final allCount = state is AdminBookingSuccess ? state.total : 0;
        final selectedFilterIndex = state is AdminBookingSuccess
            ? _filterStatuses.indexOf(state.status)
            : 0;

        final filterTabs = [
          '${AppStrings.bookingsFilterAll} ($allCount)',
          '${AppStrings.adminFilterPending} ($pendingCount)',
          '${AppStrings.adminFilterAccepted} ($acceptedCount)',
          '${AppStrings.adminFilterRejected} ($rejectedCount)',
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(
              AppStrings.adminBookingRequestsTitle,
              style: AppTextStyles.titleLarge,
            ),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  if (pendingCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: AppColors.error,
                        child: Text(
                          '$pendingCount',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: _buildBody(
              context,
              state,
              filterTabs,
              selectedFilterIndex < 0 ? 0 : selectedFilterIndex,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AdminBookingStates state,
    List<String> filterTabs,
    int selectedFilterIndex,
  ) {
    if (state is AdminBookingLoading || state is AdminBookingInitial) {
      return const AppLoading();
    }

    if (state is AdminBookingError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.error,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.p16),
              AppButton(
                text: 'إعادة المحاولة',
                onPressed: () =>
                    context.read<AdminBookingCubit>().getAdminBookings(),
              ),
            ],
          ),
        ),
      );
    }

    if (state is! AdminBookingSuccess) {
      return const SizedBox.shrink();
    }

    final tripOptions = [
      AppStrings.adminFilterAllTrips,
      ...state.data.bookings.map((booking) => booking.trip.title).toSet(),
    ];
    final selectedTrip = tripOptions.contains(state.filterTrip)
        ? state.filterTrip
        : AppStrings.adminFilterAllTrips;
    final bookings = state.filteredBookings;

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Row(
              children: List.generate(
                filterTabs.length,
                (index) => _buildFilterTab(
                  label: filterTabs[index],
                  isSelected: selectedFilterIndex == index,
                  onTap: () {
                    context.read<AdminBookingCubit>().selectStatus(
                      _filterStatuses[index],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p8,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.filter_alt_outlined,
                size: 20.r,
                color: AppColors.primary,
              ),
              AppSizes.p8.horizontalSpace,
              Text(
                'تصفية حسب الرحلة:',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSizes.p12.horizontalSpace,
              Container(
                height: 38.h,
                padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedTrip,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20.r,
                      color: AppColors.primary,
                    ),
                    items: tripOptions.map((trip) {
                      return DropdownMenuItem<String>(
                        value: trip,
                        child: Text(
                          trip,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<AdminBookingCubit>().selectTrip(val);
                      }
                    },
                  ),
                ),
              ).expanded(),
            ],
          ),
        ),
        bookings.isEmpty
            ? Text(
                AppStrings.favoritesEmpty,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).center().expanded()
            : ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.all(AppSizes.p20),
                itemCount: bookings.length + (state.isLoading ? 1 : 0),
                separatorBuilder: (context, index) =>
                    AppSizes.p16.verticalSpace,
                itemBuilder: (context, index) {
                  if (index >= bookings.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.p16),
                      child: const AppLoading(),
                    );
                  }

                  final booking = bookings[index];
                  return AdminBookingCard(
                    customerName: booking.user.fullName,
                    customerEmail: booking.user.email,
                    customerPhone: booking.user.phone,
                    tripTitle: booking.trip.title,
                    tripDates: _formatDates(
                      booking.trip.startDate,
                      booking.trip.endDate,
                    ),
                    totalAmount: _formatPrice(booking.totalPrice),
                    passengersCount: '${booking.numberOfSeats} بالغ',
                    tripImage: _imageUrl(booking.trip.coverImage),
                    status: _cardStatus(booking.status),
                    onAccept: () {},
                    onReject: () {},
                  );
                },
              ).expanded(),
      ],
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
