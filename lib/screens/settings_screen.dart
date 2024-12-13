import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart'; 
import '../providers/notification_provider.dart'; 

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
            actions: [
              IconButton(
                icon: Icon(Icons.logout, size: 30),
                onPressed: () async {
                  await authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
      ),
      body: ListView(
        children: [
          // Theme Settings
          _buildSettingsSection(
            title: 'Appearance',
            children: [
              _buildSwitchListTile(
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark themes',
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),

          // Notification Settings
          _buildSettingsSection(
            title: 'Notifications',
            children: [
              _buildSwitchListTile(
                title: 'Push Notifications',
                subtitle: 'Receive room and activity updates',
                value: notificationProvider.areNotificationsEnabled,
                onChanged: (bool value) {
                  notificationProvider.toggleNotifications();
                },
              ),
              _buildSwitchListTile(
                title: 'Email Notifications',
                subtitle: 'Get email alerts for important events',
                value: notificationProvider.areEmailNotificationsEnabled,
                onChanged: (bool value) {
                  notificationProvider.toggleEmailNotifications();
                },
              ),
            ],
          ),

          // Account Settings
          _buildSettingsSection(
            title: 'Account',
            children: [
              _buildListTile(
                title: 'Change Password',
                subtitle: 'Update your account password',
                icon: Icons.lock_outline,
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
              _buildListTile(
                title: 'Deactivate Account',
                subtitle: 'Temporarily disable your account',
                icon: Icons.delete_outline,
                onTap: () {
                  _showDeactivateAccountDialog(context);
                },
              ),
            ],
          ),

          // Privacy Settings
          /*_buildSettingsSection(
            title: 'Privacy',
            children: [
              _buildSwitchListTile(
                title: 'Profile Visibility',
                subtitle: 'Allow others to view your profile',
                value: authProvider.currentUser?.isProfilePublic ?? false,
                onChanged: (bool value) {
                  // Implement profile visibility toggle
                },
              ),
            ],
          ),*/

          // About Section
          _buildSettingsSection(
            title: 'About',
            children: [
              _buildListTile(
                title: 'App Version',
                subtitle: '1.0.0',
                icon: Icons.info_outline,
                onTap: null,
              ),
              _buildListTile(
                title: 'Privacy Policy',
                subtitle: 'Review our data handling practices',
                icon: Icons.policy_outlined,
                onTap: () {
                  // TODO: Implement privacy policy viewer
                },
              ),
            ],
          ),

          
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password change logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password change feature coming soon!')),
              );
            },
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showDeactivateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deactivate Account'),
        content: Text(
          'Are you sure you want to deactivate your account? '
          'This action can be reversed by logging in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // TODO: Implement account deactivation logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account deactivation feature coming soon!')),
              );
            },
            child: Text('Deactivate'),
          ),
        ],
      ),
    );
  }
}