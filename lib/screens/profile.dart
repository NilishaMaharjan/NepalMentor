//profile.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'request.dart'; // Import RequestPage

class MentorProfilePage extends StatefulWidget {
  final String userId;

  const MentorProfilePage({super.key, required this.userId});

  @override
  State<MentorProfilePage> createState() => _MentorProfilePageState();
}

class _MentorProfilePageState extends State<MentorProfilePage> {
  late Future<Map<String, dynamic>> mentorData;
  late Future<Map<String, dynamic>?> availabilityData;
  List<Map<String, dynamic>> reviews = []; // To store and display reviews
  String?
      currentUserId; // Store the current user's ID to compare with review owner
  double rating = 0.0; // Track the rating value

  @override
  void initState() {
    super.initState();  
    mentorData = fetchMentorData(widget.userId);
    availabilityData = fetchAvailabilityData(widget.userId);
    currentUserId = "current_user_id"; // Replace with actual user ID logic
  }

  // Function to fetch mentor data
  Future<Map<String, dynamic>> fetchMentorData(String userId) async {
    final response = await http.get(
      Uri.parse('http://192.168.193.174:3000/api/mentors/$userId'),
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
      Uri.parse('http://192.168.193.174:3000/api/availability/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null; // Return null if no availability data
    }
  }

  // Add this method for review submission or editing
  void _showReviewDialog(String mentorId,
      [Map<String, dynamic>? reviewToEdit]) {
    final TextEditingController reviewController =
        TextEditingController(text: reviewToEdit?['review'] ?? '');
    rating = reviewToEdit?['rating'] ?? 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            reviewToEdit == null ? 'Submit Review' : 'Edit Review',
            style: const TextStyle(color: Colors.teal),
          ),
          content: SingleChildScrollView(
            // Added to prevent overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reviewController,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'Describe your experience (optional)',
                    border: const OutlineInputBorder(),
                    hintStyle: const TextStyle(color: Colors.grey),
                    counterText: '${reviewController.text.length}/500',
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final review = {
                  'mentorId': mentorId,
                  'review': reviewController.text,
                  'rating': rating,
                  'userId': currentUserId,
                };
                setState(() {
                  if (reviewToEdit == null) {
                    reviews.add(review);
                  } else {
                    int index = reviews.indexOf(reviewToEdit);
                    if (index != -1) {
                      reviews[index] = review;
                    }
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Submit', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Profile'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([mentorData, availabilityData]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final mentor = snapshot.data![0];
          final availability = snapshot.data![1];

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

                // Skills Section
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

                // Qualifications Section
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

                // Bio Section
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

                // Timetable Section (without borders)
                if (availability != null &&
                    (availability['slots'] as List).isNotEmpty) ...[
                  const Text(
                    'Timetable:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: [
                      for (int index = 0;
                          index < availability['slots'].length;
                          index++) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  availability['slots'][index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestPage(
                                      slot: availability['slots'][index],
                                      mentorId: mentor['_id'],
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.teal,
                              ),
                              child: const Text('Available'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                ] else ...[
                  const Text(
                    'Timetable:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'No availability information.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                ],

                // Reviews Section
                const Text(
                  'Reviews:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 10),
                if (reviews.isEmpty)
                  const Text(
                    'No reviews yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ...reviews.map((review) {
                  return ListTile(
                    title: Text('${review['review']}'),
                    subtitle: Text('Rating: ${review['rating']}/5'),
                    trailing: review['userId'] == currentUserId
                        ? IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.teal,
                            onPressed: () =>
                                _showReviewDialog(mentor['_id'], review),
                          )
                        : null,
                  );
                }).toList(),
                // Button to submit a new review
                ListTile(
                  title: TextButton(
                    onPressed: () => _showReviewDialog(mentor['_id']),
                    child: const Text(
                      'Submit a Review',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
