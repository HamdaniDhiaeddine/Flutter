import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  bool _areNotificationsEnabled = true;
  bool _areEmailNotificationsEnabled = false;

  NotificationProvider() {
    _loadNotificationPreferences();
  }

  bool get areNotificationsEnabled => _areNotificationsEnabled;
  bool get areEmailNotificationsEnabled => _areEmailNotificationsEnabled;

  void _loadNotificationPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _areNotificationsEnabled = prefs.getBool('pushNotifications') ?? true;
    _areEmailNotificationsEnabled = prefs.getBool('emailNotifications') ?? false;
    notifyListeners();
  }

  void toggleNotifications() async {
    _areNotificationsEnabled = !_areNotificationsEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', _areNotificationsEnabled);
    notifyListeners();
  }

  void toggleEmailNotifications() async {
    _areEmailNotificationsEnabled = !_areEmailNotificationsEnabled;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emailNotifications', _areEmailNotificationsEnabled);
    notifyListeners();
  }
}