import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/dashboard/data/repo/admin_dashboard_repo.dart';
import 'package:travel_app/features/admin/dashboard/presentation/cubit/admin_dashboard_states.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardStates> {
  final DashboardRepo _dashboardRepo;

  AdminDashboardCubit({required DashboardRepo dashboardRepo})
    : _dashboardRepo = dashboardRepo,
      super(AdminDashboardInitial());

  Future<void> getAdminStats() async {
    emit(AdminDashboardLoading());
    final result = await _dashboardRepo.getAdminStats();
    result.fold(
      (failure) => emit(AdminDashboardFailure(message: failure.message)),
      (stats) => emit(AdminDashboardSuccess(adminStats: stats)),
    );
  }
}
