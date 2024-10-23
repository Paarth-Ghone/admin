import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminComplaintsPage extends StatefulWidget {
  @override
  _AdminComplaintsPageState createState() => _AdminComplaintsPageState();
}

class _AdminComplaintsPageState extends State<AdminComplaintsPage> {
  List<dynamic> complaints = [];
  final TextEditingController _replyController = TextEditingController();
  String? currentComplaintId;

  // Define your color scheme here
  final Color primaryColor = Color(0xFF2E2E2E); // Background gradient start color
  final Color secondaryColor = Color(0xFF121212); // Background gradient end color
  final Color cardColor = Color(0xFF1E1E1E); // Card background color
  final Color textColor = Colors.white; // Text color
  final Color replyButtonColor = Color(0xFF00FFCB); // Reply button color
  final Color deleteButtonColor = Colors.red; // Delete button color

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    final response = await http.get(Uri.parse('https://test-tuk7.onrender.com/complaints'));

    if (response.statusCode == 200) {
      setState(() {
        complaints = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load complaints'),
      ));
    }
  }

  Future<void> _replyToComplaint(String complaintId) async {
    final response = await http.post(
      Uri.parse('https://test-tuk7.onrender.com/complaints/reply'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'complaintId': complaintId, 'replyText': _replyController.text}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reply sent successfully!'),
      ));
      _replyController.clear();
      _fetchComplaints(); // Refresh the complaints list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send reply'),
      ));
    }
  }

  Future<void> _deleteComplaint(String complaintId) async {
    final response = await http.delete(
      Uri.parse('https://test-tuk7.onrender.com/complaints/$complaintId'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Complaint deleted successfully!'),
      ));
      _fetchComplaints(); // Refresh the complaints list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete complaint'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Complaints',style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor, // Use primary color for the AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: complaints.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            return Card(
              color: cardColor, // Set card background color
              margin: EdgeInsets.all(8.0),
              elevation: 2, // Add some elevation for shadow effect
              child: ListTile(
                title: Text(
                  'Complaint by User: ${complaint['userName']}', // Display userName instead of userId
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0), // Add spacing
                    Text(
                      'Complaint: ${complaint['text']}',
                      style: TextStyle(fontSize: 16.0, color: textColor),
                    ),
                    SizedBox(height: 8.0), // Add spacing between complaint and reply
                    if (complaint['reply'] != null) ...[
                      Text(
                        'Admin Reply: ${complaint['reply']}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14.0),
                      ),
                    ],
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.reply, color: replyButtonColor),
                      onPressed: () {
                        setState(() {
                          currentComplaintId = complaint['_id']; // Store the current complaint ID
                        });
                        _showReplyDialog(complaint['_id']);
                      },
                    ),
                    if (complaint['reply'] != null) // Show delete button only if the complaint has a reply
                      IconButton(
                        icon: Icon(Icons.delete, color: deleteButtonColor),
                        onPressed: () {
                          _deleteComplaint(complaint['_id']);
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showReplyDialog(String complaintId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor, // Set dialog background color
          title: Text('Reply to Complaint', style: TextStyle(color: textColor)),
          content: TextField(
            controller: _replyController,
            decoration: InputDecoration(labelText: 'Your Reply', labelStyle: TextStyle(color: Colors.grey)),
            maxLines: 3,
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _replyToComplaint(complaintId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Send Reply', style: TextStyle(color: replyButtonColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
