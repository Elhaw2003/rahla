import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/dashboard/data/models/admin_dashboard_stats_model.dart';

abstract class AdminDashboardStates extends Equatable {
  const AdminDashboardStates();
  @override
  List<Object?> get props => [];
}

class AdminDashboardInitial extends AdminDashboardStates {}

class AdminDashboardLoading extends AdminDashboardStates {}

class AdminDashboardFailure extends AdminDashboardStates {
  final String message;
  const AdminDashboardFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

class AdminDashboardSuccess extends AdminDashboardStates {
  final AdminDashboardStatsModel adminStats;
  const AdminDashboardSuccess({required this.adminStats});
  @override
  List<Object?> get props => [adminStats];
}
