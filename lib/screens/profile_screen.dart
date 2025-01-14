import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Image and Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: AssetImage(
                        'assets/images/Avatar.png',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Antonio Renders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '@pixup.antonio',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Menu Items
              _buildMenuItem(Icons.person_outline, 'My Profile'),
              _buildMenuItem(Icons.notifications_outlined, 'Notification'),
              _buildMenuItem(Icons.history, 'History'),
              _buildMenuItem(Icons.card_membership, 'My Subscription'),
              _buildMenuItem(Icons.settings_outlined, 'Setting'),
              _buildMenuItem(Icons.help_outline, 'Help'),
              _buildMenuItem(Icons.logout, 'Logout'),
              const SizedBox(
                  height: 20), //space before the bottom navigation bar
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
