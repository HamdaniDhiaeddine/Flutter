import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room_model.dart';
import 'auth_service.dart';

class RoomService {
  static const String baseUrl = 'http://localhost:2000/api/rooms';

  Future<List<Room>> getAllRooms() async {
    try {
      final authToken = await AuthService().getStoredToken();
      if (authToken == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/all-rooms'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> roomsJson = responseBody['rooms'] ?? [];
        return roomsJson.map((json) => Room.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch rooms: ${response.body}');
      }
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

  Future<Room?> getRoomDetails(String roomId) async {
    try {
      final authToken = await AuthService().getStoredToken();
      if (authToken == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/roomDetails/$roomId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> roomJson = json.decode(response.body);
        return Room.fromJson(roomJson);
      } else {
        print('Failed to load room details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching room details: $e');
      return null;
    }
  }

  Future<Room?> createRoom({
    required String name,
    required String type,
    String? subject,
    int capacity = 10,
    String? password,
  }) async {
    try {
      final authToken = await AuthService().getStoredToken();
      if (authToken == null) {
        throw Exception("No authentication token found");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/create-room'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'name': name,
          'type': type,
          'subject': subject,
          'capacity': capacity,
          'password': password,
        }),
      );

      print('Create Room Response: ${response.statusCode}');
      print('Create Room Body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> roomJson = json.decode(response.body);
        return Room.fromJson(roomJson);
      } else {
        print('Failed to create room: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating room: $e');
      return null;
    }
  }
}