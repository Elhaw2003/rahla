import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';

abstract class CategoriesStates extends Equatable {
  const CategoriesStates();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesStates {
  const CategoriesInitial();
  @override
  List<Object?> get props => [];
}

class CategoriesLoading extends CategoriesStates {
  const CategoriesLoading();
  @override
  List<Object?> get props => [];
}

class CategoriesSuccess extends CategoriesStates {
  final List<CategoryModel> categories;

  const CategoriesSuccess({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoriesFailure extends CategoriesStates {
  final String message;

  const CategoriesFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
