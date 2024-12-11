import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';

class RoomProvider with ChangeNotifier {
  final RoomService _roomService = RoomService();

  List<Room> _rooms = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRooms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedRooms = await _roomService.getAllRooms();
      _rooms = fetchedRooms;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch rooms';
      _rooms = [];
      print('Error fetching rooms: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Room?> addRoom(Room room) async {
    try {
      // Prevent duplicate rooms
      if (!_rooms.any((existingRoom) => existingRoom.id == room.id)) {
        _rooms.insert(0, room); // Add to the beginning of the list
        notifyListeners();
      }
      return room;
    } catch (e) {
      print('Error adding room: $e');
      return null;
    }
  }

  Future<void> initializeRooms() async {
    if (_rooms.isEmpty) {
      await fetchRooms();
    }
  }
}