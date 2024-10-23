import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageNoticesPage extends StatefulWidget {
  @override
  _ManageNoticesPageState createState() => _ManageNoticesPageState();
}

class _ManageNoticesPageState extends State<ManageNoticesPage> {
  List<dynamic> notices = [];

  @override
  void initState() {
    super.initState();
    _fetchNotices(); // Fetch existing notices when the page loads
  }

  // Function to fetch notices from the database
  Future<void> _fetchNotices() async {
    final response = await http.get(Uri.parse('https://test-tuk7.onrender.com/notices'));

    if (response.statusCode == 200) {
      setState(() {
        notices = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load notices'),
      ));
    }
  }

  // Function to delete a notice
  Future<void> _deleteNotice(String id) async {
    final response = await http.delete(Uri.parse('https://test-tuk7.onrender.com/notices/$id'));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notice deleted successfully!'),
      ));
      _fetchNotices(); // Refresh the notices after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete notice'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Notices',style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2E2E2E),
        // Match the gradient start color
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
        child: Column(
          children: [
            Expanded(
              child: notices.isEmpty
                  ? Center(child: Text('No notices found', style: TextStyle(color: Colors.white))) // Adjusted text color
                  : ListView.builder(
                itemCount: notices.length,
                itemBuilder: (context, index) {
                  final notice = notices[index];
                  return Card( // Use a card to match the style
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Color(0xFF1C1C1C), // Card background color
                    child: ListTile(
                      title: Text(notice['title'], style: TextStyle(color: Colors.white)), // Adjusted text color
                      subtitle: Text(notice['description'], style: TextStyle(color: Colors.grey)), // Adjusted text color
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Delete icon color
                        onPressed: () {
                          _deleteNotice(notice['_id']); // Call the delete function
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
