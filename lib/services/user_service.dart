import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  static const String baseUrl = 'http://localhost:2000/api/users';

  Future<List<User>> getAllStudents() async {
    try {
      final authToken = await AuthService().getStoredToken();
      if (authToken == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/get-all-students'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('students')) {
          final List<dynamic> userJson = responseBody['students'];
          return userJson.map((json) => User.fromJson(json)).toList();
        } else {
          print('No students found in the response.');
          return [];
        }
      } else {
        print('Failed to load students: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching students: $e');
      return [];
    }
  }

  Future<bool> unbanUser(String userId) async {
    try {
      final authToken = await AuthService().getStoredToken();
      if (authToken == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/unban/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

print('Unban Response Status Code: ${response.statusCode}');
    print('Unban Response Body: ${response.body}');
      // Check for successful responses (200 or 204)
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error unbanning user: $e');
      return false;
    }
  }

  Future<bool> banUser(String userId) async {
    try {
      final authToken = await AuthService().getStoredToken();
      if (authToken == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/ban/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      // Check for successful responses (200 or 204)
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error banning user: $e');
      return false;
    }
  }
 Future<User?> getUserDetails(String userId) async {
  try {
    final authToken = await AuthService().getStoredToken();
    if (authToken == null) {
      throw Exception("No authentication token found");
    }

    // Make the HTTP GET request
    final response = await http.get(
      Uri.parse('$baseUrl/get-user-details/$userId'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Parse the user object and return
      if (responseBody.containsKey('user')) {
        return User.fromJson(responseBody['user']);
      } else {
        throw Exception('User data not found in response');
      }
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user profile: ${response.body}');
    }
  } catch (e) {
    print('Error fetching user profile: $e');
    return null;
  }
}

}
