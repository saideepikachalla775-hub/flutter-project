import 'dart:convert';

bool apiResponseSucceeded(Map<String, dynamic> data) {
  final value = data['success'];

  if (value is bool) return value;
  if (value is num) return value == 1;

  return value is String &&
      ['1', 'true', 'success', 'ok'].contains(value.trim().toLowerCase());
}

Map<String, dynamic> parseApiResponse(String responseBody) {
  final trimmed = responseBody.trim();

  if (trimmed.isEmpty) {
    return {
      'success': false,
      'message': 'No response from server',
    };
  }

  try {
    final decoded = jsonDecode(trimmed);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }

    return {
      'success': false,
      'message': 'Invalid server response',
    };
  } on FormatException {
    return {
      'success': false,
      'message': 'Invalid server response',
    };
  }
}
