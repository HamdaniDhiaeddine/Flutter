import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/room_service.dart';
import '../providers/room_provider.dart';

class CreateRoomScreen extends StatefulWidget {
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final RoomService _roomService = RoomService();

  String _name = '';
  String _type = 'public';
  String? _subject;
  int _capacity = 10;
  String? _password;
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        final room = await _roomService.createRoom(
          name: _name,
          type: _type,
          subject: _subject,
          capacity: _capacity,
          password: _type == 'private' ? _password : null,
        );

        if (room != null) {
          // Add room to provider
          await Provider.of<RoomProvider>(context, listen: false).addRoom(room);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Room created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(room);
        } else {
          _showErrorDialog('Failed to create room. Please try again.');
        }
      } catch (e) {
        _showErrorDialog('An error occurred: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4E65FF),
              Color(0xFF8A4FFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Create New Room',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Room Name
                          _buildInputField(
                            label: 'Room Name',
                            icon: Icons.meeting_room_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a room name';
                              }
                              if (value.length < 3) {
                                return 'Room name must be at least 3 characters';
                              }
                              return null;
                            },
                            onSaved: (value) => _name = value!,
                          ),
                          SizedBox(height: 16),

                          // Subject (Optional)
                          _buildInputField(
                            label: 'Subject (Optional)',
                            icon: Icons.subject_rounded,
                            onSaved: (value) => _subject = value,
                          ),
                          SizedBox(height: 16),

                          // Capacity
                          _buildNumberInputField(
                            label: 'Room Capacity',
                            icon: Icons.group_rounded,
                            initialValue: '10',
                            validator: (value) {
                              if (value == null || int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              int capacity = int.parse(value);
                              if (capacity < 2 || capacity > 100) {
                                return 'Capacity must be between 2 and 100';
                              }
                              return null;
                            },
                            onSaved: (value) => _capacity = int.parse(value!),
                          ),
                          SizedBox(height: 32),

                          // Room Type Radio Buttons
                          Text(
                            'Room Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Public'),
                                  value: 'public',
                                  groupValue: _type,
                                  onChanged: (value) {
                                    setState(() {
                                      _type = value.toString();
                                      _password = null;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Private'),
                                  value: 'private',
                                  groupValue: _type,
                                  onChanged: (value) {
                                    setState(() {
                                      _type = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Password Field (Visible for Private Rooms Only)
                          if (_type == 'private')
                            Column(
                              children: [
                                SizedBox(height: 16),
                                _buildInputField(
                                  label: 'Room Password',
                                  icon: Icons.lock_rounded,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password for private rooms';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _password = value,
                                ),
                              ],
                            ),

                          SizedBox(height: 32),

                          // Create Room Button
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF4E65FF),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF4E65FF),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Create Room',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF4E65FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
    );
  }

  Widget _buildNumberInputField({
    required String label,
    required IconData icon,
    required String initialValue,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF4E65FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: TextInputType.number,
      validator: validator,
      onSaved: onSaved,
    );
  }
}