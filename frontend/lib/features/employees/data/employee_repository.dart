import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_config.dart';
import '../models/employee.dart';

class EmployeeRepository {
  EmployeeRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  Uri get _employeesUri => Uri.parse('$employeeApiBaseUrl/verinite/EMS/employees');

  Future<List<Employee>> getEmployees() async {
    final response = await _client.get(_employeesUri, headers: await _headers());
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('The server returned an invalid employee list.');
    }
    return decoded
        .map((item) => Employee.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Employee> createEmployee(Employee employee) async {
    final response = await _client.post(
      _employeesUri.replace(path: '${_employeesUri.path}/create-employee'),
      headers: await _headers(),
      body: jsonEncode(employee.toRequestJson()),
    );
    _ensureSuccess(response);
    return Employee.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Employee> updateEmployee(Employee employee) async {
    final response = await _client.put(
      _employeesUri.replace(path: '${_employeesUri.path}/${employee.id}'),
      headers: await _headers(),
      body: jsonEncode(employee.toRequestJson()),
    );
    _ensureSuccess(response);
    return Employee.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteEmployee(int id) async {
    final response = await _client.delete(
      _employeesUri.replace(path: '${_employeesUri.path}/$id'),
      headers: await _headers(),
    );
    _ensureSuccess(response);
  }

  Future<Map<String, String>> _headers() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('access_token');
    final tokenType = preferences.getString('token_type') ?? 'Bearer';
    if (token == null || token.isEmpty) {
      throw Exception('Your session has expired. Please sign in again.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': '$tokenType $token',
    };
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    String message = 'Employee request failed (${response.statusCode}).';
    if (response.body.isNotEmpty) {
      try {
        final body = jsonDecode(response.body);
        if (body is Map) {
          message = (body['message'] ?? body['error'] ?? message).toString();
        }
      } on FormatException {
        message = response.body;
      }
    }
    throw Exception(message);
  }

  void dispose() => _client.close();
}