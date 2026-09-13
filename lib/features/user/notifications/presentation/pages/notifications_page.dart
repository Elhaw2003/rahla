import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/notifications/data/models/notification_model.dart';
import 'package:travel_app/features/user/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:travel_app/features/user/notifications/presentation/cubit/notifications_states.dart';
import 'package:travel_app/features/user/notifications/presentation/widgets/notification_list_card.dart';
import 'package:travel_app/features/user/notifications/presentation/widgets/notifications_empty_error.dart';
import 'package:travel_app/features/user/notifications/presentation/widgets/notifications_shimmer_loading.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NotificationsCubit>().getNotifications();
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
      context.read<NotificationsCubit>().loadMoreNotifications();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<NotificationsCubit>().getNotifications();
  }

  void _onNotificationTap(NotificationModel notification) {
    if (notification.isRead || notification.id.isEmpty) return;

    context.read<NotificationsCubit>().markNotificationAsRead(notification.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsCubit, NotificationsStates>(
      listenWhen: (_, current) =>
          current is NotificationsMarkNotificationAsReadErrorStates ||
          current is NotificationsMarkAllNotificationsAsReadErrorStates,
      listener: (context, state) {
        if (state is NotificationsMarkNotificationAsReadErrorStates) {
          AppSnackbar.showError(context: context, message: state.message);
        } else if (state
            is NotificationsMarkAllNotificationsAsReadErrorStates) {
          AppSnackbar.showError(context: context, message: state.message);
        }
      },
      child: Scaffold(
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
            AppStrings.notificationsTitle,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsStates>(
              buildWhen: (_, current) =>
                  current is NotificationsSuccessStates ||
                  current is NotificationsLoadingStates ||
                  current is NotificationsInitialStates,
              builder: (context, state) {
                final hasUnread =
                    state is NotificationsSuccessStates &&
                    state.unreadCount > 0;
                if (!hasUnread) return const SizedBox.shrink();

                return TextButton(
                  onPressed: () => context
                      .read<NotificationsCubit>()
                      .markAllNotificationsAsRead(),
                  child: Text(
                    'قراءة الكل',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsStates>(
          buildWhen: (_, current) =>
              current is NotificationsLoadingStates ||
              current is NotificationsSuccessStates ||
              current is NotificationsErrorStates ||
              current is NotificationsInitialStates,
          builder: (context, state) {
            if (state is NotificationsLoadingStates ||
                state is NotificationsInitialStates) {
              return const NotificationsShimmerLoading();
            }

            if (state is NotificationsErrorStates) {
              return NotificationsErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<NotificationsCubit>().getNotifications(),
              );
            }

            if (state is NotificationsSuccessStates) {
              final items = state.notifications;
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.secondary,
                child: items.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 120),
                          NotificationsEmptyView(),
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
                        itemCount: items.length + (state.isLoadingMore ? 1 : 0),
                        separatorBuilder: (_, _) => AppSizes.p12.verticalSpace,
                        itemBuilder: (context, index) {
                          if (index >= items.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.p12,
                              ),
                              child: const AppLoading(size: 28),
                            );
                          }

                          final notification = items[index];
                          final canTap = !notification.isRead;
                          return NotificationListCard(
                            notification: notification,
                            onTap: canTap
                                ? () => _onNotificationTap(notification)
                                : null,
                          );
                        },
                      ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
