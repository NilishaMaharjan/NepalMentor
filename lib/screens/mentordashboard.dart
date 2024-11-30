import 'dart:convert'; // Required for decoding JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_availability.dart'; // Import the ViewAvailabilityScreen
import 'package:get/get.dart'; // Import GetX for navigation
import 'login.dart'; // Import your Login page (assuming it's named login.dart)
import 'mentees_list_screen.dart';
import 'package:http/http.dart' as http; // Required for API calls

class MentorDashboard extends StatefulWidget {
  const MentorDashboard({super.key});

  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {
  int _selectedIndex = 0;
  String? userId;
  List<String> communitySlots = []; // Holds community slots dynamically
  List<Map<String, dynamic>> menteeRequests =
      []; // Holds mentee requests dynamically

  @override
  void initState() {
    super.initState();
    _getUserId().then((_) {
      _fetchAvailability();
      _fetchMenteeRequests(); // Fetch mentee requests on load
    });
  }

  // Fetch the userId from SharedPreferences
  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  // Fetch mentor's availability slots from backend
  Future<void> _fetchAvailability() async {
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.193.174:3000/api/availability/$userId'), // Update with correct endpoint
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          communitySlots = List<String>.from(data['slots'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching availability: $e");
    }
  }

  // Fetch mentee requests from backend
  Future<void> _fetchMenteeRequests() async {
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.193.174:3000/api/requests/mentor?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          menteeRequests = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print("Failed to fetch mentee requests: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching mentee requests: $e");
    }
  }

  // Update mentee request status (accept/reject)
  Future<void> _updateRequestStatus(String requestId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('http://192.168.193.174:3000/api/requests/$requestId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );
      if (response.statusCode == 200) {
        _fetchMenteeRequests(); // Refresh mentee requests
      } else {
        print("Failed to update request status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating request status: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Logout function
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); // Clear the stored userId

    // Navigate to the login page
    Get.offAll(() => const LoginScreen()); // actual login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _selectedIndex == 0
              ? 'My Community'
              : _selectedIndex == 1
                  ? 'Requests'
                  : _selectedIndex == 2
                      ? 'Profile'
                      : '',
        ),
        backgroundColor: Colors.teal,
      ),
      body: _selectedIndex == 0
          ? _buildHomeScreen()
          : _selectedIndex == 1
              ? _buildMenteeRequests()
              : _selectedIndex == 2
                  ? _buildProfile()
                  : Container(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Build the Home Screen with community slots
  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Mentor!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Manage your community effectively.',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Community',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          if (communitySlots.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No communities available. Please add availability slots.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ...communitySlots.map((slot) => _buildCommunityCard(slot)),
        ],
      ),
    );
  }

  // Build each community card with a modern design
  Widget _buildCommunityCard(String slot) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.teal.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.group,
                size: 28,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community Slot',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    slot,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
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

  // Build Mentee Requests Screen
  Widget _buildMenteeRequests() {
    return menteeRequests.isEmpty
        ? const Center(
            child: Text(
              'No requests found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: menteeRequests.length,
            itemBuilder: (context, index) {
              final request = menteeRequests[index];

              // Access the mentee's first and last name from the populated data
              final menteeFirstName = request['mentee'] != null
                  ? request['mentee']['firstName'] ?? 'Unknown'
                  : 'Unknown';
              final menteeLastName = request['mentee'] != null
                  ? request['mentee']['lastName'] ?? 'Unknown'
                  : 'Unknown';
              final menteeName =
                  '$menteeFirstName $menteeLastName'; // Combine first and last name

              final menteeEmail = request['mentee']['email'] ?? 'Unknown';
          

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(menteeName),
                  subtitle: Text('$menteeEmail'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () =>
                            _updateRequestStatus(request['id'], 'accepted'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () =>
                            _updateRequestStatus(request['id'], 'rejected'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // "Settings" heading at the top
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Setting',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.account_circle, color: Colors.teal),
          title: const Text('My Profile'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.schedule, color: Colors.teal),
          title: const Text('View Availability'),
          onTap: () async {
            await Get.to(() => const ViewAvailabilityScreen());
            _fetchAvailability(); // Refresh community slots on return
          },
        ),
        ListTile(
          leading: const Icon(Icons.star, color: Colors.teal),
          title: const Text('My Mentees'),
          onTap: () async {
            // Navigates to MenteesListScreen
            await Get.to(() => const MenteesListScreen());
          },
        ),
        ListTile(
          leading: const Icon(Icons.payment, color: Colors.teal),
          title: const Text('Payment History'),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: _logout,
        ),
      ],
    );
  }

  void showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }
}
