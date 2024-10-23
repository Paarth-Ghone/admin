import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageMembersPage extends StatefulWidget {
  @override
  _ManageMembersPageState createState() => _ManageMembersPageState();
}

class _ManageMembersPageState extends State<ManageMembersPage> {
  List<dynamic> members = [];
  List<dynamic> filteredMembers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    final response = await http.get(Uri.parse('https://test-tuk7.onrender.com/members'));

    if (response.statusCode == 200) {
      setState(() {
        members = json.decode(response.body);
        filteredMembers = members; // Initially, the filtered list is the same as the full list
      });
    } else {
      throw Exception('Failed to load members');
    }
  }

  Future<void> _removeMembership(String userId) async {
    final response = await http.delete(Uri.parse('https://test-tuk7.onrender.com/members/$userId'));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Membership removed successfully!'),
      ));
      _fetchMembers(); // Refresh the member list after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove membership'),
      ));
    }
  }

  void _filterMembers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredMembers = members; // Show all members if the query is empty
      });
    } else {
      setState(() {
        filteredMembers = members.where((member) {
          final nameLower = member['name'].toLowerCase();
          final emailLower = member['email'].toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower) || emailLower.contains(queryLower);
        }).toList(); // Filter members based on name or email
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Members',style: TextStyle(color: Colors.white)),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  _filterMembers(query); // Call filter function on text change
                },
                decoration: InputDecoration(
                  labelText: 'Search by Name or Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white, // Background for text field
                ),
              ),
            ),
            Expanded(
              child: filteredMembers.isEmpty
                  ? Center(child: Text('No members found', style: TextStyle(color: Colors.white))) // Adjusted text color
                  : ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    color: Color(0xFF1C1C1C), // Card background color
                    child: ListTile(
                      title: Text(member['name'], style: TextStyle(color: Colors.white)), // Adjusted text color
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${member['email']}', style: TextStyle(color: Colors.grey)), // Adjusted text color
                          Text('Plan: ${member['plan']}', style: TextStyle(color: Colors.grey)), // Adjusted text color
                          Text('Price: ₹${member['price']}', style: TextStyle(color: Colors.grey)), // Adjusted text color
                          Text('Start Date: ${member['startDate'].substring(0, 10)}', style: TextStyle(color: Colors.grey)), // Adjusted text color
                          Text('End Date: ${member['endDate'].substring(0, 10)}', style: TextStyle(color: Colors.grey)), // Adjusted text color
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show a confirmation dialog before removing
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm Removal'),
                                content: Text('Are you sure you want to remove this membership?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _removeMembership(member['userId']); // Call the remove function
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text('Remove'),
                                  ),
                                ],
                              );
                            },
                          );
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
