import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_states.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_bookings_app_bar.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_bookings_body.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_bookings_error_view.dart';

class AdminBookingsPage extends StatefulWidget {
  final String? initialTripFilter;

  const AdminBookingsPage({super.key, this.initialTripFilter});

  @override
  State<AdminBookingsPage> createState() => _AdminBookingsPageState();
}

class _AdminBookingsPageState extends State<AdminBookingsPage> {
  final ScrollController _scrollController = ScrollController();
  AdminBookingSuccess? _lastSuccess;

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBookingCubit, AdminBookingStates>(
      listener: (context, state) {
        if (state is AdminBookingSuccess) {
          _lastSuccess = state;
        } else if (state is AdminBookingError) {
          AppSnackbar.showError(context: context, message: state.error);
        } else if (state is AdminBookingApproveError ||
            state is AdminBookingRejectError) {
          final message = state is AdminBookingApproveError
              ? state.error
              : (state as AdminBookingRejectError).error;
          AppSnackbar.showError(context: context, message: message);
          final filter = _lastSuccess?.status ?? 'all';
          context.read<AdminBookingCubit>().selectStatus(filter);
        } else if (state is AdminBookingApproveSuccess) {
          AppSnackbar.showSuccess(
            context: context,
            message: AppStrings.adminAcceptedBanner,
          );
        } else if (state is AdminBookingRejectSuccess) {
          AppSnackbar.showSuccess(
            context: context,
            message: AppStrings.adminRejectedBanner,
          );
        }
      },
      builder: (context, state) {
        if (state is AdminBookingSuccess) {
          _lastSuccess = state;
        }

        final success = state is AdminBookingSuccess ? state : _lastSuccess;
        final approveLoadingId = state is AdminBookingApproveLoading
            ? state.bookingId
            : '';
        final rejectLoadingId = state is AdminBookingRejectLoading
            ? state.bookingId
            : '';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AdminBookingsAppBar(
            pendingCount: success?.pendingBookingsCount ?? 0,
          ),
          body: SafeArea(
            child: _buildBody(
              state: state,
              success: success,
              approveLoadingId: approveLoadingId,
              rejectLoadingId: rejectLoadingId,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody({
    required AdminBookingStates state,
    required AdminBookingSuccess? success,
    required String approveLoadingId,
    required String rejectLoadingId,
  }) {
    if (success == null) {
      if (state is AdminBookingError) {
        return AdminBookingsErrorView(error: state.error);
      }
      return const AppLoading();
    }

    return AdminBookingsBody(
      state: success,
      approveLoadingId: approveLoadingId,
      rejectLoadingId: rejectLoadingId,
      scrollController: _scrollController,
    );
  }
}
