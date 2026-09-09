import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_session.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8081',
);

class AuthRepository {
  Future<LoginSession> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/verinite/EMS/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    Map<String, dynamic> body = {};
    if (response.body.isNotEmpty) {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        (body['message'] ?? body['error'] ?? 'Login failed.').toString(),
      );
    }

    final session = LoginSession.fromJson(body);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('access_token', session.accessToken);
    await preferences.setString('refresh_token', session.refreshToken);
    await preferences.setString('token_type', session.tokenType);
    return session;
  }

  Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('access_token');
    await preferences.remove('refresh_token');
    await preferences.remove('token_type');
  }
}
