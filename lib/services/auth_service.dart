import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:2000/api/users';

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        return token;
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
  // New method to extract user ID from token
  Future<String?> getCurrentUserId() async {
    final token = await getStoredToken();
    if (token != null) {
      try {
        // Decode the JWT token to get the user ID
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        return decodedToken['userId']; // Adjust the key based on your token structure
      } catch (e) {
        print('Error decoding token: $e');
        return null;
      }
    }
    return null;
  }
}
