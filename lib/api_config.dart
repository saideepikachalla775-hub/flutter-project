import 'package:flutter/foundation.dart';

String get apiBaseUrl {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2/plastic_api';
  }

  return 'http://localhost/plastic_api';
}
