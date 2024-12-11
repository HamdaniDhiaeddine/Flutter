import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];
  User? _userDetails;
  bool _isLoading = false;

  List<User> get users => _users;
  User? get userDetails => _userDetails;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _userService.getAllStudents();
    } catch (e) {
      print('Error fetching users: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserDetails(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userDetails = await _userService.getUserDetails(userId);
    } catch (e) {
      print('Error fetching user details: $e');
      _userDetails = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> banUser(String userId) async {
  try {
    final success = await _userService.banUser(userId);
    if (success) {
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex].isBanned = true;
        notifyListeners();
      }
    }
  } catch (e) {
    // Handle error silently
  }
}

Future<void> unbanUser(String userId) async {
  try {
    final success = await _userService.unbanUser(userId);
    if (success) {
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex].isBanned = false;
        notifyListeners();
      }
    }
  } catch (e) {
    // Handle error silently
  }
}


}
