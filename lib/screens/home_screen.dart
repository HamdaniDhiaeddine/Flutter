import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import '../services/user_service.dart';
import 'create_room_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  int _totalUsers = 0;
  int _activeRooms = 0;
  int _bannedUsers = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final users = await _userService.getAllStudents();
      final roomProvider = Provider.of<RoomProvider>(context, listen: false);
      await roomProvider.fetchRooms();

      setState(() {
        _totalUsers = users.length;
        _bannedUsers = users.where((user) => user.isBanned).length;
        _activeRooms = roomProvider.rooms.length;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: const Color(0xFF4E65FF),
            title: Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout, size: 30),
                onPressed: () async {
                  await authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF4E65FF),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      
                      // Dashboard Quick Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard(
                            icon: Icons.people,
                            title: 'Total Users',
                            value: '$_totalUsers', // Replace with actual user count
                            color: Colors.blue,
                          ),
                          _buildStatCard(
                            icon: Icons.room,
                            title: 'Total Rooms',
                            value: '$_activeRooms', // Replace with actual room count
                            color: Colors.purple,
                          ),
                          _buildStatCard(
                            icon: Icons.block,
                            title: 'Banned Users',
                            value: '$_bannedUsers', // Replace with actual banned user count
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionCard(
                        icon: Icons.add,
                        title: 'Create Room',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CreateRoomScreen()),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.block,
                        title: 'Manage Users',
                        onTap: () {
                          // This will be handled by bottom navigation in MainScreen
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          // TODO: Implement settings page
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recent Activity Section
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildActivityList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: [
        _buildActivityItem(
          icon: Icons.add_circle,
          title: 'New Room Created',
          subtitle: 'Study Group Room',
          time: '2 hours ago',
        ),
        _buildActivityItem(
          icon: Icons.block,
          title: 'User Banned',
          subtitle: 'John Doe',
          time: '4 hours ago',
        ),
        _buildActivityItem(
          icon: Icons.person_add,
          title: 'New User Registered',
          subtitle: 'Jane Smith',
          time: '6 hours ago',
        ),
      ],
    );
  }

  Widget _buildActivityItem({

    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}