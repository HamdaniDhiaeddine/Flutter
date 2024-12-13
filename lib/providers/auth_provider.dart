import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class AuthProvider with ChangeNotifier {
  String? _authToken;
  User? _user;

  String? get authToken => _authToken;
  User? get user => _user;

  bool get isAuthenticated => _authToken != null;

  Future<void> loadAuthToken() async {
    final token = await AuthService().getStoredToken();
    _authToken = token;
    
    // If token exists, try to fetch user details
    if (token != null) {
      await fetchUserProfile();
    }
    
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final token = await AuthService().login(email, password);
    if (token != null) {
      _authToken = token;
      
      // Fetch user profile after successful login
      await fetchUserProfile();
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> fetchUserProfile() async {
    try {
      // You might need to modify your backend to return the current user's ID during login
      // Or store the user ID when logging in
      final userService = UserService();
      
      // This assumes you have a way to get the current user's ID
      // You might need to adjust this based on your backend implementation
      final storedToken = await AuthService().getStoredToken();
      if (storedToken != null) {
        // Decode the token or use a backend method to extract user ID
        // This is a placeholder and should be replaced with your actual method
        final userId = await AuthService().getCurrentUserId();
        
        if (userId != null) {
          final user = await userService.getUserDetails(userId);
          _user = user;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> logout() async {
    await AuthService().logout();
    _authToken = null;
    _user = null;
    notifyListeners();
  }

  Future<bool> updateUserProfile(User updatedUser) async {
  try {
    // You'll need to implement a method in your UserService to update the profile
    final userService = UserService();
    
    // Call a method to update user profile on the backend
    final success = await userService.updateUserProfile(updatedUser);
    
    if (success) {
      // Update the local user object
      _user = updatedUser;
      notifyListeners();
      return true;
    }
    return false;
  } catch (e) {
    print('Error updating user profile: $e');
    return false;
  }
}
}