import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenteesListScreen extends StatefulWidget {
  const MenteesListScreen({super.key});

  @override
  State<MenteesListScreen> createState() => _MenteesListScreenState();
}

class _MenteesListScreenState extends State<MenteesListScreen> {
  List<Map<String, dynamic>> acceptedMentees =
      []; // Holds accepted mentees' data
  String? userId; // Store the mentor's userId

  @override
  void initState() {
    super.initState();
    _getUserId(); // Fetch the userId from SharedPreferences
  }

  // Fetch the userId from SharedPreferences
  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(
          'userId'); // Assuming 'userId' is saved in SharedPreferences
    });

    if (userId != null) {
      _fetchAcceptedMentees(); // Fetch accepted mentees after getting the userId
    }
  }

  // Fetch the accepted mentees from your backend
  Future<void> _fetchAcceptedMentees() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.193.174:3000/api/requests/mentor/accepted?userId=$userId'), // Pass userId in the URL
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          acceptedMentees = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print("Failed to fetch accepted mentees: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching accepted mentees: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Mentees'),
        backgroundColor: Colors.teal,
      ),
      body: acceptedMentees.isEmpty
          ? const Center(
              child: Text(
                'No accepted mentees found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: acceptedMentees.length,
              itemBuilder: (context, index) {
                final mentee = acceptedMentees[index];

                final menteeFirstName =
                    mentee['mentee']['firstName'] ?? 'Unknown';
                final menteeLastName =
                    mentee['mentee']['lastName'] ?? 'Unknown';
                final menteeName = '$menteeFirstName $menteeLastName';

                final menteeEmail = mentee['mentee']['email'] ?? 'Unknown';
                final menteeSlot = mentee['slot'] ?? 'No Slot Selected';

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(menteeName),
                    subtitle: Text('$menteeEmail\nSlot: $menteeSlot'),
                  ),
                );
              },
            ),
    );
  }
}