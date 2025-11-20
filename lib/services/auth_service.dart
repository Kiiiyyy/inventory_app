import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/auth_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<bool> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/login'),
      headers: ApiConfig.headers,
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(json.decode(response.body));
      
      if (loginResponse.success && loginResponse.data != null) {
        await _saveToken(loginResponse.data!.token);
        await _saveUser(loginResponse.data!.user);
        return true;
      }
    }
    return false;
  }

  Future<bool> logout() async {
  final token = await getToken();
  if (token != null) {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/logout'),
        headers: {
          ...ApiConfig.headers,
          'Authorization': 'Bearer $token',
        },
      );

      await _clearAuthData();
      
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      // Even if API call fails, clear local data
      await _clearAuthData();
    }
  }
  await _clearAuthData();
  return true;
}

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}