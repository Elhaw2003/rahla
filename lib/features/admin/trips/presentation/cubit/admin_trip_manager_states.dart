import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/trips/data/models/add_trip_response_model.dart';

abstract class AdminTripManagerStates extends Equatable {
  const AdminTripManagerStates();

  @override
  List<Object?> get props => [];
}

class AdminTripManagerInitial extends AdminTripManagerStates {
  const AdminTripManagerInitial();
}

class AdminTripManagerLoading extends AdminTripManagerStates {
  const AdminTripManagerLoading();
}

class AdminTripAddSuccess extends AdminTripManagerStates {
  final AddTripResponseModel response;

  const AdminTripAddSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class AdminTripManagerFailure extends AdminTripManagerStates {
  final String message;

  const AdminTripManagerFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
