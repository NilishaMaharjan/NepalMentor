import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile.dart';
import 'dashboard.dart';
import 'session_history.dart'; // Import the session_history.dart page
import 'my_mentors.dart'; // Import the my_mentors.dart page
import 'profile_edit.dart'; // Import Mentor Profile Page

class MathsPage extends StatefulWidget {
  const MathsPage({super.key});

  @override
  MathsPageState createState() => MathsPageState();
}

class MathsPageState extends State<MathsPage> {
  List<dynamic> mentors = [];
  int _selectedIndex = 0; // Keep track of the selected index
  final PageController _pageController = PageController();

  Future<void> fetchMentors(String category, String subject) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.193.174:3000/api/mentors?category=$category&subjects=$subject'),
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
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          // If the current index is not the mentors page, navigate to the mentors page
          setState(() {
            _selectedIndex = 0;
            _pageController.jumpToPage(0);
          });
          return false; // Prevent the default back action
        }
        return true; // Allow normal back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getAppBarTitle(_selectedIndex)),
          backgroundColor: Colors.teal,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            // Main Grade List page (Mentors Page)
            mentors.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: mentors.length,
                    itemBuilder: (context, index) {
                      return MentorCard(
                        name:
                            '${mentors[index]['firstName']} ${mentors[index]['lastName'] ?? 'No last name'}',
                        role: mentors[index]['jobTitle'] ?? 'No role',
                        skills:
                            List<String>.from(mentors[index]['subjects'] ?? []),
                        price: 3000,
                        rating: mentors[index]['rating'] ?? 'N/A', // Rating
                        reviewsCount: mentors[index]['reviewsCount'] ??
                            '0', // Reviews count
                        imageUrl: 'assets/default.png',
                        onViewProfile: () {
                          // Pass the mentor's userId dynamically when navigating to the profile page
                          String mentorId = mentors[index]['user']?['_id'] ??
                              mentors[index]['_id'];
                          print('Mentor data: ${mentors[index]}');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MentorProfilePage(
                                  userId: mentorId), // Pass 'userId' here
                            ),
                          );
                        },
                      );
                    },
                  ),
            // My Communities page
            Scaffold(
              body: _buildBlankPage(),
            ),
            // My Learning placeholder page
            Scaffold(
              body: _buildBlankPage(),
            ),
            // Notifications placeholder page
            Scaffold(
              body: _buildBlankPage(),
            ),
            // Profile page with account management options
            Scaffold(
              body: _buildProfile(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            } else {
              setState(() {
                _selectedIndex = index;
                _pageController.jumpToPage(index);
              });
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.grey, // Always set to grey
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.groups,
                color: _selectedIndex == 1 ? Colors.teal : Colors.grey,
              ),
              label: 'My Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.school,
                color: _selectedIndex == 2 ? Colors.teal : Colors.grey,
              ),
              label: 'My Learning',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: _selectedIndex == 3 ? Colors.teal : Colors.grey,
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: _selectedIndex == 4 ? Colors.teal : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Mentors';
      case 1:
        return 'My Community';
      case 2:
        return 'My Learning';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'Mentors';
    }
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildProfileOption(Icons.person, 'My Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileEditPage()),
            );
          }),
          _buildProfileOption(Icons.history, 'Session History', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SessionHistoryPage()),
            );
          }),
          _buildProfileOption(Icons.star_border, 'My Mentors', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyMentorsPage()),
            );
          }),
          _buildProfileOption(Icons.payment, 'Payment History', () {
            // Add functionality for Payment History
          }),
          const SizedBox(height: 20),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Logout', style: TextStyle(color: Colors.red)),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }

  Widget _buildBlankPage() {
    return const Center(
      child: Text(
        'This page is under development.',
        style: TextStyle(fontSize: 18, color: Colors.teal),
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
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
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
                        ' $rating ($reviewsCount reviews)',
                        style: const TextStyle(fontSize: 16),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
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
