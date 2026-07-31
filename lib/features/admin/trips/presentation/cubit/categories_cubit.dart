import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/trips/data/repo/categories_repo.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_states.dart';

class CategoriesCubit extends Cubit<CategoriesStates> {
  CategoriesCubit({required this._categoriesRepo})
    : super(const CategoriesInitial());

  final CategoriesRepo _categoriesRepo;

  Future<void> getCategories() async {
    emit(const CategoriesLoading());

    final result = await _categoriesRepo.getCategories();
    result.fold(
      (failure) => emit(CategoriesFailure(message: failure.message)),
      (response) {
        final activeCategories = response.data
            .where((category) => category.isActive)
            .toList();
        emit(CategoriesSuccess(categories: activeCategories));
      },
    );
  }
}
