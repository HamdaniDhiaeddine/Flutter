import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../providers/room_provider.dart';

class RoomDetailsScreen extends StatefulWidget {
  final String roomId;

  const RoomDetailsScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  _RoomDetailsScreenState createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  Room? _room;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRoomDetails();
  }

  Future<void> _fetchRoomDetails() async {
    try {
      final roomService = RoomService();
      final room = await roomService.getRoomDetails(widget.roomId);
      
      setState(() {
        _room = room;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load room details';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Room Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF4E65FF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchRoomDetails,
                        child: Text('Retry'),
                      )
                    ],
                  ),
                )
              : _room != null
                  ? SingleChildScrollView(
                      padding: EdgeInsets.all(120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRoomInfoCard(),
                          SizedBox(height: 16),
                          _buildParticipantsSection(),
                        ],
                      ),
                    )
                  : Center(child: Text('No room details found')),
    );
  }

  Widget _buildRoomInfoCard() {
    final creatorName = _room?.createdBy != null
        ? "${_room!.createdBy!['nom']} ${_room!.createdBy!['prenom']}"
        : "Unknown Creator";

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _room!.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E65FF),
              ),
            ),
            SizedBox(height: 8),
            _buildDetailRow(
              icon: Icons.people_outline,
              label: 'Participants',
              value: '${_room!.participantsCount}/${_room!.capacity}',
            ),
            _buildDetailRow(
              icon: Icons.lock_outline,
              label: 'Type',
              value: _room!.type.toUpperCase(),
            ),
            _buildDetailRow(
              icon: Icons.person,
              label: 'Created By',
              value: creatorName,
            ),
            if (_room!.subject != null)
              _buildDetailRow(
                icon: Icons.subject,
                label: 'Subject',
                value: _room!.subject!,
              ),
            _buildDetailRow(
              icon: Icons.date_range,
              label: 'Created At',
              value: _room!.createdAt.toString().split(' ')[0],
            ),
            _buildDetailRow(
              icon: _room!.videoSessionActive 
                  ? Icons.videocam 
                  : Icons.videocam_off,
              label: 'Video Session',
              value: _room!.videoSessionActive ? 'Active' : 'Not Active',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4E65FF)),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participants',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E65FF),
              ),
            ),
            SizedBox(height: 8),
            // TODO: Implement participant list view
            // This will require updating the backend to return participant details
            Center(
              child: Text(
                'Participant list coming soon',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}