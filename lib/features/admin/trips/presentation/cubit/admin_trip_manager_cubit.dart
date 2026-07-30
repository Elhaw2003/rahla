import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/features/admin/trips/data/models/add_trip_request_model.dart';
import 'package:travel_app/features/admin/trips/data/repo/admin_trip_manager_repo.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trip_manager_states.dart';

class AdminTripManagerCubit extends Cubit<AdminTripManagerStates> {
  AdminTripManagerCubit({required AdminTripManagerRepo adminTripManagerRepo})
    : _adminTripManagerRepo = adminTripManagerRepo,
      super(const AdminTripManagerInitial());

  final AdminTripManagerRepo _adminTripManagerRepo;

  Future<void> addTrip(
    CreateTripRequest request, {
    XFile? coverImage,
    List<XFile>? gallery,
  }) async {
    emit(const AdminTripManagerLoading());

    final result = await _adminTripManagerRepo.addTrip(
      request,
      coverImage: coverImage ?? request.coverImage,
      gallery: gallery ?? request.gallery,
    );

    result.fold(
      (failure) => emit(AdminTripManagerFailure(message: failure.message)),
      (response) => emit(AdminTripAddSuccess(response: response)),
    );
  }

  // Future<void> updateTrip(...) async { ... }
  // Future<void> deleteTrip(...) async { ... }
}
