import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../screens/create_room_screen.dart';

class RoomsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Room Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF4E65FF),
      ),
      body: FutureBuilder(
        future: Provider.of<RoomProvider>(context, listen: false).initializeRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load rooms. Please try again.'));
          }

          final roomProvider = Provider.of<RoomProvider>(context);
          return RefreshIndicator(
            onRefresh: roomProvider.fetchRooms,
            child: roomProvider.rooms.isEmpty
                ? Center(child: Text('No rooms found'))
                : ListView.builder(
                    itemCount: roomProvider.rooms.length,
                    itemBuilder: (context, index) {
                      final room = roomProvider.rooms[index];
                      final creatorName = room.createdBy != null
    ? "${room.createdBy!['nom']} ${room.createdBy!['prenom']}"
    : "Unknown Creator";


                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            room.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${room.type} · ${room.participantsCount} participants\nCreated by: $creatorName',
                          ),
                          leading: Icon(
                            room.type == 'public' ? Icons.public : Icons.lock,
                            color: Color(0xFF4E65FF),
                          ),
                          trailing: Icon(Icons.arrow_forward, color: Color(0xFF4E65FF)),
                          onTap: () {
                            // Navigate to room details or perform other actions
                          },
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateRoomScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create Room',
        backgroundColor: Color(0xFF4E65FF),
      ),
    );
  }
}
