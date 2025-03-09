import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../conf_ip.dart';

class MyMentorsPage extends StatefulWidget {
  const MyMentorsPage({super.key});

  @override
  MyMentorsPageState createState() => MyMentorsPageState();
}

class MyMentorsPageState extends State<MyMentorsPage> {
  // List to store mentors fetched from the database
  List<Map<String, dynamic>> mentors = [];

  @override
  void initState() {
    super.initState();
    fetchMentors();
  }

  // Function to fetch mentor data from the backend
  Future<void> fetchMentors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/mentors'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Update the state with the list of mentors from the backend
        setState(() {
          mentors = data.map((mentor) {
            return {
              // Ensure these fields are strings, and handle lists properly
              'name': mentor['name'] ?? 'No name available',
              'jobTitle': mentor['jobTitle'] ?? 'No job title available',
              'skills': (mentor['skills'] is List)
                  ? (mentor['skills'] as List)
                      .join(', ') // Convert list to string
                  : mentor['skills'] ??
                      'No skills available', // Fallback if it's null
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load mentors');
      }
    } catch (e) {
      print('Error fetching mentors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Mentors')),
      body: ListView.builder(
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          // Ensure no null values are passed to the widget
          final name = mentor['name'] ?? 'No name available';
          final jobTitle = mentor['jobTitle'] ?? 'No job title available';
          final skills = mentor['skills'] ?? 'No skills available';

          return _buildMentorCard(name, jobTitle, skills);
        },
      ),
    );
  }

  Widget _buildMentorCard(String name, String jobTitle, String skills) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(name),
        subtitle: Text('$jobTitle - $skills'),
        trailing: const Icon(Icons.message),
        onTap: () {
          // You can add functionality to message the mentor
        },
      ),
    );
  }
}
