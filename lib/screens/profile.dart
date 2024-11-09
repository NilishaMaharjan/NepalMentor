import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MentorProfilePage extends StatefulWidget {
  final String userId;

  const MentorProfilePage({super.key, required this.userId});

  @override
  State<MentorProfilePage> createState() => _MentorProfilePageState();
}

class _MentorProfilePageState extends State<MentorProfilePage> {
  late Future<Map<String, dynamic>> mentorData;

  // List to store the timetable with editable slots and availability
  List<Map<String, dynamic>> editableTimetable = [
    {'time': '09:00 AM - 10:00 AM', 'available': true},
    {'time': '10:00 AM - 11:00 AM', 'available': false},
    {'time': '11:00 AM - 12:00 PM', 'available': true},
    {'time': '01:00 PM - 02:00 PM', 'available': true},
    // Add more time slots as needed
  ];

  @override
  void initState() {
    super.initState();
    mentorData = fetchMentorData(widget.userId);
  }

  // Function to toggle availability for each time slot
  void updateAvailability(int index) {
    setState(() {
      editableTimetable[index]['available'] = !editableTimetable[index]['available'];
    });
  }

  // Function to update time for a specific slot
  void updateTime(int index, String newTime) {
    setState(() {
      editableTimetable[index]['time'] = newTime;
    });
  }

  Future<Map<String, dynamic>> fetchMentorData(String userId) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.15:3000/api/mentors/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load mentor data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Profile'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: mentorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final mentor = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),  // Increased padding for better spacing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image and Name
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/default.png'),
                    ),
                    const SizedBox(width: 20),  // Slightly increased spacing
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${mentor['firstName']} ${mentor['lastName'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 24,  // Slightly reduced font size for the name
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,  // Changed to black color
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            mentor['jobTitle'] ?? 'No title',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              Text(
                                ' ${mentor['rating'] ?? 'N/A'} (${mentor['reviewsCount'] ?? '0'} reviews)',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),  // Increased space between sections

                // 1. Skills Section
                const Text(
                  'Skills:',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,  // Increased horizontal spacing between skills
                  runSpacing: 10,  // Increased vertical spacing between skills
                  children: (mentor['skills'] as List<dynamic>? ?? []).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color for each skill box
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        boxShadow:const  [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ], // Subtle shadow for depth
                        border: Border.all(
                          color: Colors.teal, // Border color
                          width: 1.5, // Border width
                        ),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Colors.teal, // Text color to match design
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),  // Increased space between sections

                // 2. Qualifications Section
                if (mentor['qualifications'] != null) ...[
                  const Text(
                    'Qualifications:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mentor['qualifications'],
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                ],

                // 3. Bio Section
                if (mentor['bio'] != null) ...[
                  const Text(
                    'Bio:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mentor['bio'],
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                ],

                // 4. Location Section
                if (mentor['location'] != null) ...[
                  const Text(
                    'Location:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mentor['location'],
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                ],

                // 5. Timetable Section (Presented as a Table)
                const SizedBox(height: 24),  // Space before Timetable
                const Text(
                  'Timetable:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 6),
                Table(
                  // No table border is applied
                  children: [
                    // Timetable rows without header
                    for (int index = 0; index < editableTimetable.length; index++)
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                controller: TextEditingController(text: editableTimetable[index]['time']),
                                onChanged: (newTime) {
                                  updateTime(index, newTime);
                                },
                                decoration: InputDecoration(
                                  border:const OutlineInputBorder(),
                                  labelText: 'Time Slot ${index + 1}',
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: () => updateAvailability(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: editableTimetable[index]['available'] ? Colors.green : Colors.red,
                                ),
                                child: Text(editableTimetable[index]['available'] ? 'Available' : 'Unavailable'),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 24),  // Space after Timetable
              ],
            ),
          );
        },
      ),
    );
  }
}
