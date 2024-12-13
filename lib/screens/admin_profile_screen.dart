import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'edit_profile_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  User? _adminProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminProfile();
  }

  void _fetchAdminProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userService = UserService();

    try {
      // Assuming the logged-in user's ID is available in the auth provider
      final userId = authProvider.user?.id;
      if (userId != null) {
        final user = await userService.getUserDetails(userId);
        setState(() {
          _adminProfile = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching admin profile: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
  icon: Icon(Icons.edit),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen()),
    );
  },
)
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _adminProfile == null
              ? Center(child: Text('Unable to load profile'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: _adminProfile!.photo != null
                              ? NetworkImage(_adminProfile!.photo!)
                              : null,
                          child: _adminProfile!.photo == null
                              ? Icon(Icons.person, size: 70)
                              : null,
                        ),
                        SizedBox(height: 16),

                        // Name
                        Text(
                          '${_adminProfile!.prenom} ${_adminProfile!.nom}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Role
                        Text(
                          _adminProfile!.role.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 24),

                        // Profile Details
                        _buildProfileSection(),

                        // Logout Button
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            await authProvider.logout();
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 81, 80, 80),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'change account',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileDetailRow(
              icon: Icons.email,
              label: 'Email',
              value: _adminProfile!.email,
            ),
            Divider(),
            _buildProfileDetailRow(
              icon: Icons.phone,
              label: 'Phone',
              value: _adminProfile!.numeroTelephone ?? 'Not provided',
            ),
            Divider(),
            _buildProfileDetailRow(
              icon: Icons.cake,
              label: 'Date of Birth',
              value: _adminProfile!.dateDeNaissance ?? 'Not provided',
            ),
            Divider(),
            _buildProfileDetailRow(
              icon: Icons.location_on,
              label: 'Address',
              value: _adminProfile!.adresse ?? 'Not provided',
            ),
            Divider(),
            _buildProfileDetailRow(
              icon: Icons.work,
              label: 'Institution',
              value: _adminProfile!.institution ?? 'Not provided',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}