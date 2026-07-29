class ErrorModel {
  final int statusCode;
  final String message;
  final String? code;
  final List<String> generalErrors;
  final Map<String, List<String>> fieldErrors;

  const ErrorModel({
    required this.statusCode,
    required this.message,
    this.code,
    required this.generalErrors,
    this.fieldErrors = const {},
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    final String mainMessage =
        json['message'] ??
        json['detail'] ??
        json['title'] ??
        'An error occurred';

    final List<String> extractedErrors = [];
    final Map<String, List<String>> extractedFieldErrors = {};

    final errors = json['errors'] ?? json['data'];

    if (errors != null) {
      if (errors is Map) {
        final errorsMap = Map<String, dynamic>.from(errors);
        for (final entry in errorsMap.entries) {
          if (entry.value is List) {
            final values = (entry.value as List)
                .map((e) => e?.toString() ?? '')
                .where((e) => e.isNotEmpty)
                .toList();

            extractedErrors.addAll(values);
            extractedFieldErrors[entry.key] = values;
          } else if (entry.value is String) {
            extractedErrors.add(entry.value);

            extractedFieldErrors[entry.key] = [entry.value];
          }
        }
      } else if (errors is List) {
        extractedErrors.addAll(List<String>.from(errors));
      } else if (errors is String) {
        extractedErrors.add(errors);
      }
    }

    if (extractedErrors.isEmpty && mainMessage.isNotEmpty) {
      extractedErrors.add(mainMessage);
    }

    return ErrorModel(
      statusCode: json['statusCode'] as int? ?? json['status'] as int? ?? 0,
      message: mainMessage,
      code: json['code']?.toString(),
      generalErrors: extractedErrors,
      fieldErrors: extractedFieldErrors,
    );
  }

  String get errorMessage {
    if (generalErrors.isNotEmpty) {
      return generalErrors.first;
    }

    return message;
  }
}
