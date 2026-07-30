import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/admin/trips/data/models/add_trip_request_model.dart';
import 'package:travel_app/features/admin/trips/data/models/add_trip_response_model.dart';

abstract class AdminTripManagerRepo {
  Future<Either<Failure, AddTripResponseModel>> addTrip(
    CreateTripRequest request, {
    XFile? coverImage,
    List<XFile>? gallery,
  });
}

class AdminTripManagerRepoImpl implements AdminTripManagerRepo {
  final ApiConsumer _apiConsumer;

  AdminTripManagerRepoImpl({required ApiConsumer apiConsumer})
    : _apiConsumer = apiConsumer;

  @override
  Future<Either<Failure, AddTripResponseModel>> addTrip(
    CreateTripRequest request, {
    XFile? coverImage,
    List<XFile>? gallery,
  }) async {
    try {
      final tripMap = request.toJson();
      final hasCover = coverImage != null && coverImage.path.isNotEmpty;
      final hasGallery = gallery != null && gallery.isNotEmpty;

      late final dynamic requestBody;

      if (hasCover || hasGallery) {
        final formData = FormData();

        tripMap.forEach((key, value) {
          if (value is List || value is Map) {
            formData.fields.add(MapEntry(key, jsonEncode(value)));
          } else {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });

        if (hasCover) {
          formData.files.add(
            MapEntry(
              'coverImage',
              await MultipartFile.fromFile(
                coverImage.path,
                filename: coverImage.name,
              ),
            ),
          );
        }

        if (hasGallery) {
          for (final image in gallery) {
            formData.files.add(
              MapEntry(
                'gallery',
                await MultipartFile.fromFile(image.path, filename: image.name),
              ),
            );
          }
        }

        requestBody = formData;
      } else {
        requestBody = tripMap;
      }

      final response = await _apiConsumer.post(
        EndPoints.addTrip,
        data: requestBody,
      );

      return Right(
        AddTripResponseModel.fromJson(
          Map<String, dynamic>.from(response as Map),
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
