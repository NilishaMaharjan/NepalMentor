import 'package:flutter/material.dart';
import 'profile.dart'; // Import the profile.dart page

class MathsPage extends StatelessWidget {
  const MathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors'),
        backgroundColor: Colors.teal, // Header color changed to teal
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          MentorCard(
            name: 'Shubha Acharya',
            role: 'Maths Specialist with 5 years experience',
            rating: 4.9,
            reviews: 20,
            skills: ['Algebra', 'Calculus', 'Geometry'],
            price: 3000,
            imageUrl: 'assets/shubha.png',
            isAvailable: true,
          ),
          MentorCard(
            name: 'Nilisha Maharjan',
            role: 'Maths Teacher for Grades 7-10',
            rating: 4.9,
            reviews: 12,
            skills: ['Trigonometry', 'Statistics', 'Arithmetic'],
            price: 2600,
            imageUrl: 'assets/nili.png',
            isAvailable: false,
          ),
          MentorCard(
            name: 'Sanjeeta Acharya',
            role: 'Maths Teacher for Grades 7-10',
            rating: 4.8,
            reviews: 15,
            skills: ['Probability', 'Graphs', 'Functions'],
            price: 2500,
            imageUrl: 'assets/sanjeeta.png',
            isAvailable: false,
          ),
        ],
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
  final double rating;
  final int reviews;
  final List<String> skills;
  final int price;
  final String imageUrl;
  final bool isAvailable;

  const MentorCard({
    super.key,
    required this.name,
    required this.role,
    required this.rating,
    required this.reviews,
    required this.skills,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Added elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40, // Kept the radius for visual preference
                  backgroundImage: AssetImage(imageUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isAvailable ? 'Available' : 'Unavailable',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
