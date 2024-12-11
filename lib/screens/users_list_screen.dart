import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'user_details_screen.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF4E65FF),
      ),
      body: userProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: userProvider.fetchUsers,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    key: ValueKey(user.id),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        '${user.nom} ${user.prenom}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserDetailsScreen(userId: user.id),
                          ),
                        );
                      },
                      trailing: _buildToggleBanButton(user, userProvider),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildToggleBanButton(User user, UserProvider userProvider) {
    return InkWell(
      onTap: () async {
        if (user.isBanned) {
          await userProvider.unbanUser(user.id);
        } else {
          await userProvider.banUser(user.id);
        }
        // Explicitly refresh the user list after ban/unban operation
        await userProvider.fetchUsers();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: user.isBanned ? Colors.green : Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              user.isBanned ? Icons.check : Icons.block,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              user.isBanned ? 'Unban' : 'Ban',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}