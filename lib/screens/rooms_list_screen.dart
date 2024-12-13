import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';
import '../screens/create_room_screen.dart';
import '../screens/room_details_screen.dart';

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
                : GridView.builder(
                    padding: EdgeInsets.all(75),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      crossAxisSpacing: 75,
                      mainAxisSpacing: 75,
                    ),
                    itemCount: roomProvider.rooms.length,
                    itemBuilder: (context, index) {
                      final room = roomProvider.rooms[index];
                      final creatorName = room.createdBy != null
                          ? "${room.createdBy!['nom']} ${room.createdBy!['prenom']}"
                          : "Unknown Creator";

                      return _RoomGridCard(
                        room: room,
                        creatorName: creatorName,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomDetailsScreen(roomId: room.id),
                            ),
                          );
                        },
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

class _RoomGridCard extends StatelessWidget {
  final dynamic room;
  final String creatorName;
  final VoidCallback onTap;

  const _RoomGridCard({
    Key? key,
    required this.room,
    required this.creatorName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Type Icon
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  room.type == 'public' ? Icons.public : Icons.lock,
                  color: Color(0xFF4E65FF),
                  size: 24,
                ),
              ),
              
              // Room Name
              Text(
                room.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 8),
              
              // Participants
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${room.participantsCount}/${room.capacity}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // Creator Info
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      creatorName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              Spacer(),
              
              // Video Session Status
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  room.videoSessionActive 
                      ? Icons.videocam 
                      : Icons.videocam_off,
                  color: room.videoSessionActive 
                      ? Colors.green 
                      : Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}