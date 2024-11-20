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
  late Future<Map<String, dynamic>?> availabilityData;

  @override
  void initState() {
    super.initState();
    mentorData = fetchMentorData(widget.userId);
    availabilityData =
        fetchAvailabilityData(widget.userId); // Fetch availability data
  }

  // Function to fetch mentor data
  Future<Map<String, dynamic>> fetchMentorData(String userId) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.108:3000/api/mentors/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load mentor data');
    }
  }

  // Function to fetch availability data (can be null if not available)
  Future<Map<String, dynamic>?> fetchAvailabilityData(String userId) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.108:3000/api/availability/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null; // Return null if no availability data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Profile'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        // Await both mentor and availability data and handle them as a list
        future: Future.wait([mentorData, availabilityData]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          // Snapshot will now contain a List of the data
          final mentor = snapshot.data![0]; // mentor data
          final availability =
              snapshot.data![1]; // availability data (can be null)

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${mentor['firstName']} ${mentor['lastName'] ?? ''}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
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
                const SizedBox(height: 24),

                // 1. Skills Section
                const Text(
                  'Skills:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      (mentor['skills'] as List<dynamic>? ?? []).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.teal,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 2. Qualifications Section
                if (mentor['qualifications'] != null) ...[
                  const Text(
                    'Qualifications:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mentor['location'],
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                ],

                // 5. Timetable Section (Presented as a Table)
                if (availability != null && availability['slots'] != null) ...[
                  const SizedBox(height: 24),
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
                    children: [
                      // Display mentor's slots from the availability data
                      for (int index = 0;
                          index < availability['slots'].length;
                          index++)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  availability['slots']
                                      [index], // Display the time slot
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  onPressed:
                                      null, // Button is disabled (read-only)
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.grey, // Disabled button color
                                  ),
                                  child: const Text('Available'),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ] else if (availability == null) ...[
                  // If no availability data
                  const SizedBox(height: 24),
                  const Text(
                    'No availability information.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
