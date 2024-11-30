import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'primary.dart';
import 'secondary.dart';
import 'session_history.dart'; // Import the session_history.dart page
import 'my_mentors.dart'; // Import the my_mentors.dart page
import 'profile_edit.dart'; // Import the profile_edit.dart page

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  File? _profileImage;
  final Color themeColor = const Color.fromARGB(255, 47, 161, 150);

  int _selectedIndex = 0; // Tracks the selected index for BottomNavigationBar

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          _selectedIndex == 0
              ? 'Learning Dashboard'
              : _selectedIndex == 1
                  ? 'My Community'
                  : _selectedIndex == 2
                      ? 'My Learning'
                      : _selectedIndex == 3
                          ? 'Notifications'
                          : 'Profile', // Title updates based on the selected tab
        ),
        leading: _selectedIndex == 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0; // Go back to the main dashboard
                  });
                },
              )
            : null, // No leading icon on the main page
      ),
      body: _selectedIndex == 0
          ? _buildLearningDashboard()
          : _selectedIndex == 1
              ? _buildBlankPage()
              : _selectedIndex == 2
                  ? _buildBlankPage() // My Learning blank for now
                  : _selectedIndex == 3
                      ? _buildBlankPage() // Notifications blank for now
                      : _buildProfile(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups), label: 'My Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildLearningDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showImageSourceDialog(context),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: _profileImage != null
                        ? ClipOval(
                            child: Image.file(
                              _profileImage!,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 35,
                            color: themeColor,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Username!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '"Learning is a treasure that will follow its \n  owner everywhere."',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/dashboard.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Choose your level',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap:
                  true, // Ensures the grid takes only as much height as needed
              physics:
                  const NeverScrollableScrollPhysics(), // Disables GridView scrolling
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrimaryLevelPage(),
                    ),
                  ),
                  child: _buildLevelCard('Primary', Icons.school),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondaryLevelPage(),
                    ),
                  ),
                  child: _buildLevelCard('Secondary', Icons.auto_stories),
                ),
                _buildLevelCard('Diploma', Icons.menu_book),
                _buildLevelCard('CTEVT', Icons.library_books),
                _buildLevelCard('Bachelor', Icons.school_outlined),
                _buildLevelCard('Masters', Icons.workspace_premium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlankPage() {
    return Center(
      child: Text(
        'This page is under development.',
        style: TextStyle(fontSize: 18, color: themeColor),
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Setting',
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
          _buildProfileOption(Icons.payment, 'Payment History'),
          const SizedBox(height: 20),
          _buildLogoutButton(),
        ],
      ),
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

  Widget _buildProfileOption(IconData icon, String title,
      [void Function()? onTap]) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildLevelCard(String level, IconData icon) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: themeColor),
          const SizedBox(height: 10),
          Text(
            level,
            style: const TextStyle(fontSize: 16, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }
}
