import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  const UserDetailsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final userDetails = await _userService.getUserDetails(widget.userId);
    setState(() {
      _userDetails = userDetails?.toJson(); // Convert User object to JSON for display
      _isLoading = false;
    });
  } catch (error) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load user details: $error')),
    );
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'User Profile',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Color(0xFF4E65FF),
    ),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _userDetails == null
            ? Center(child: Text('User details not found'))
            : Center( // Center content in the middle of the page
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _userDetails?['photo'] != null
                            ? NetworkImage(_userDetails!['photo'])
                            : null,
                        child: _userDetails?['photo'] == null
                            ? Icon(Icons.person, size: 60)
                            : null,
                      ),
                      SizedBox(height: 20),
                      _buildDetailRow('Full Name', '${_userDetails?['nom'] ?? ''} ${_userDetails?['prenom'] ?? ''}'),
                      _buildDetailRow('Email', _userDetails?['email'] ?? ''),
                      _buildDetailRow('Date of Birth', _userDetails?['date_de_naissance'] ?? 'N/A'),
                      _buildDetailRow('Gender', _userDetails?['genre'] ?? 'N/A'),
                      _buildDetailRow('Phone Number', _userDetails?['numero_telephone'] ?? 'N/A'),
                      _buildDetailRow('Address', _userDetails?['adresse'] ?? 'N/A'),
                      _buildDetailRow('Institution', _userDetails?['institution'] ?? 'N/A'),
                    ],
                  ),
                ),
              ),
  );
}




 Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Center align both label and value
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4), // Space between label and value
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}


}