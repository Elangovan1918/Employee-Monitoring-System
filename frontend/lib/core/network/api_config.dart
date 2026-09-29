import 'package:flutter/foundation.dart';

const _legacyApiBaseUrl = String.fromEnvironment('API_BASE_URL');
const _authApiBaseUrl = String.fromEnvironment('AUTH_API_BASE_URL');
const _employeeApiBaseUrl = String.fromEnvironment('EMPLOYEE_API_BASE_URL');

String get _localApiHost => !kIsWeb && defaultTargetPlatform == TargetPlatform.android
    ? '10.0.2.2'
    : 'localhost';

String get authApiBaseUrl {
  if (_authApiBaseUrl.isNotEmpty) return _authApiBaseUrl;
  if (_legacyApiBaseUrl.isNotEmpty) return _legacyApiBaseUrl;
  return 'http://$_localApiHost:8081';
}

String get employeeApiBaseUrl {
  if (_employeeApiBaseUrl.isNotEmpty) return _employeeApiBaseUrl;
  return 'http://$_localApiHost:8082';
}