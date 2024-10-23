import 'package:admin/notice.dart';
import 'package:flutter/material.dart';
import 'notice.dart';
import 'members.dart';
import 'managemembers.dart';
import 'complaints.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard',style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2E2E2E), // Match the gradient start color
      ),
      body: Container(
        // Apply gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E2E2E), Color(0xFF121212)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildAdminTile(
              title: 'Members',
              icon: Icons.group,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MembersPage()),
                ); // Navigate to the Members page
              },
            ),
            _buildAdminTile(
              title: 'Notices',
              icon: Icons.announcement,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoticesPage()),
                ); // Navigate to the Notices page
              },
            ),
            _buildAdminTile(
              title: 'Manage Members',
              icon: Icons.manage_accounts,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageMembersPage()),
                ); // Navigate to the Manage Members page
              },
            ),
            _buildAdminTile(
              title: 'Complaints',
              icon: Icons.feedback,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminComplaintsPage()),
                ); // Navigate to the Complaints page
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build admin tiles
  Widget _buildAdminTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        color: Color(0xFF1E1E1E), // Dark card background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.white), // Icon color
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white), // Text color
            ),
          ],
        ),
      ),
    );
  }
}
