import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _authToken;

  String? get authToken => _authToken;

  bool get isAuthenticated => _authToken != null;

  Future<void> loadAuthToken() async {
    final token = await AuthService().getStoredToken();
    _authToken = token;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final token = await AuthService().login(email, password);
    if (token != null) {
      _authToken = token;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await AuthService().logout();
    _authToken = null;
    notifyListeners();
  }
}
