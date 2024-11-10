import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile.dart'; // Import Mentor Profile Page

class MathsPage extends StatefulWidget {
  const MathsPage({super.key});

  @override
  MathsPageState createState() => MathsPageState();
}

class MathsPageState extends State<MathsPage> {
  List<dynamic> mentors = [];

  Future<void> fetchMentors(String category, String subject) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.15:3000/api/mentors?category=$category&subjects=$subject'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            mentors = json.decode(response.body);
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load mentors. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMentors('Primary', 'Math');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors'),
        backgroundColor: Colors.teal,
      ),
      body: mentors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                return MentorCard(
                  name: '${mentors[index]['firstName']} ${mentors[index]['lastName'] ?? 'No last name'}',
                  role: mentors[index]['jobTitle'] ?? 'No role',
                  skills: List<String>.from(mentors[index]['subjects'] ?? []),
                  price: 3000,
                  rating: mentors[index]['rating'] ?? 'N/A', // Rating
                  reviewsCount: mentors[index]['reviewsCount'] ?? '0', // Reviews count
                  imageUrl: 'assets/default.png',
                  onViewProfile: () {
                    // Pass the mentor's userId dynamically when navigating to the profile page
                    String mentorId = mentors[index]['user']?['_id'] ?? mentors[index]['_id'];
                    print('Mentor data: ${mentors[index]}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MentorProfilePage(userId: mentorId), // Pass 'userId' here
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class MentorCard extends StatelessWidget {
  final String name;
  final String role;
  final List<String> skills;
  final int price;
  final String rating; // Added rating field
  final String reviewsCount; // Added reviewsCount field
  final String imageUrl;
  final VoidCallback onViewProfile;

  const MentorCard({
    super.key,
    required this.name,
    required this.role,
    required this.skills,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(imageUrl),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: skills.map((skill) {
                      return Chip(
                        label: Text(
                          skill,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        backgroundColor: Colors.grey.shade100,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Display the rating and review count
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
<<<<<<< HEAD
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              20, // Increased font size for better visibility
                        ),
                      ),
                      Text(
                        role,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16, // Adjusted font size for the role
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber,
                              size: 18), // Slightly larger star
                          const SizedBox(width: 5),
                          Text('$rating ($reviews reviews)'),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 6, // Spacing between skill badges
                        children: skills.map((skill) {
                          return Chip(
                            label: Text(skill),
                            backgroundColor: Colors.grey
                                .shade50, // Changed badge color to light grey
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 5),
                      Text('Starting from: Rs. $price/month',
                          style: const TextStyle(
                              fontSize: 16)), // Adjusted font size for price
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MentorProfilePage(), // Navigate to MentorProfilePage
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded button
                          ),
                        ),
                        child: const Text(
                          'View Profile',
                          style: TextStyle(color: Colors.white),
                        ),
=======
                        ' $rating ($reviewsCount reviews)',
                        style: const TextStyle(fontSize: 16),
>>>>>>> 8bdcf8f6a494cfd541257ac92b23ef22d5155917
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Starting from: Rs. $price/month',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 13, 13, 13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: onViewProfile,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
