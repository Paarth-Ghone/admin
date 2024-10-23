import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  List<dynamic> members = [];
  List<dynamic> filteredMembers = [];
  String selectedSort = 'Newest Member'; // Default sort option
  String selectedFilter = 'All'; // Default filter option

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
        filteredMembers = members; // Initially, all members are displayed
        _sortMembers(); // Sort members initially
      });
    } else {
      throw Exception('Failed to load members');
    }
  }

  // Function to sort members based on startDate (newest or oldest)
  void _sortMembers() {
    setState(() {
      if (selectedSort == 'Newest Member') {
        filteredMembers.sort((a, b) => b['startDate'].compareTo(a['startDate']));
      } else {
        filteredMembers.sort((a, b) => a['startDate'].compareTo(b['startDate']));
      }
    });
  }

  // Function to filter members based on their plan
  void _filterMembers() {
    setState(() {
      if (selectedFilter == 'All') {
        filteredMembers = members;
      } else {
        filteredMembers = members.where((member) {
          return member['plan'] == selectedFilter;
        }).toList();
      }
      _sortMembers(); // Sort the filtered members
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members',style: TextStyle(color: Colors.white)),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sort By Dropdown
                  DropdownButton<String>(
                    value: selectedSort,
                    dropdownColor: Color(0xFF1C1C1C), // Dropdown background color
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value!;
                        _sortMembers(); // Re-sort the members after selecting sort option
                      });
                    },
                    items: [
                      DropdownMenuItem(child: Text('Newest Member', style: TextStyle(color: Colors.white)), value: 'Newest Member'),
                      DropdownMenuItem(child: Text('Oldest Member', style: TextStyle(color: Colors.white)), value: 'Oldest Member'),
                    ],
                  ),
                  // Filter By Dropdown
                  DropdownButton<String>(
                    value: selectedFilter,
                    dropdownColor: Color(0xFF1C1C1C), // Dropdown background color
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                        _filterMembers(); // Filter the members based on the selected filter
                      });
                    },
                    items: [
                      DropdownMenuItem(child: Text('All', style: TextStyle(color: Colors.white)), value: 'All'),
                      DropdownMenuItem(child: Text('1 Month Membership', style: TextStyle(color: Colors.white)), value: 'Monthly'),
                      DropdownMenuItem(child: Text('6 Months Membership', style: TextStyle(color: Colors.white)), value: '6 Months'),
                      DropdownMenuItem(child: Text('1 Year Membership', style: TextStyle(color: Colors.white)), value: 'Yearly'),
                    ],
                  ),
                ],
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
