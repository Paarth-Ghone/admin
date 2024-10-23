import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'manage_notices_page.dart'; // Import the ManageNoticesPage

class NoticesPage extends StatefulWidget {
  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  // Function to add a notice to the database
  Future<void> _addNotice() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://test-tuk7.onrender.com/addnotices'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _titleController.text,
        'description': _descriptionController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notice added successfully!'),
      ));
      _titleController.clear();
      _descriptionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add notice'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notice',style: TextStyle(color: Colors.white)),
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
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Notice Title',
                labelStyle: TextStyle(color: Colors.white), // Label color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Focus border color
                ),
              ),
              style: TextStyle(color: Colors.white), // Text color
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white), // Label color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Focus border color
                ),
              ),
              maxLines: 4,
              style: TextStyle(color: Colors.white), // Text color
            ),
            SizedBox(height: 16.0),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _addNotice,
              child: Text('Add Notice'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF6200EE), // Text color
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Manage Notices page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageNoticesPage()),
                );
              },
              child: Text('View/Delete Notices'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF6200EE), // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
