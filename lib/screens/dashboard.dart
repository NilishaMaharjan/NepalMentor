import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'primary.dart';
import 'secondary.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const PersistentBottomNavigation();
  }
}

class PersistentBottomNavigation extends StatefulWidget {
  const PersistentBottomNavigation({super.key});

  @override
  State<PersistentBottomNavigation> createState() =>
      _PersistentBottomNavigationState();
}

class _PersistentBottomNavigationState
    extends State<PersistentBottomNavigation> {
  int _selectedIndex = 0; // Tracks the selected index for BottomNavigationBar
  File? _profileImage;
  File? _learningPhoto;
  final Color themeColor = const Color.fromARGB(255, 47, 161, 150);

  // Method for picking an image
  Future<void> _pickImage(ImageSource source,
      {bool isLearningPhoto = false}) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        if (isLearningPhoto) {
          _learningPhoto = File(pickedImage.path);
        } else {
          _profileImage = File(pickedImage.path);
        }
      });
    }
  }

  // List of pages
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildLearningDashboard(),
      _buildSearch(),
      _buildBlankPage("My Learning"),
      _buildBlankPage("Notifications"),
      _buildProfile(),
    ]);
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
                  ? 'Search'
                  : _selectedIndex == 2
                      ? 'My Learning'
                      : _selectedIndex == 3
                          ? 'Notifications'
                          : 'Profile', // Title updates based on the selected tab
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
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
    return Column(
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '"Learning is a treasure that will follow its \n  owner everywhere."',
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () => _showImageSourceDialog(context, isLearningPhoto: true),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _learningPhoto != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _learningPhoto!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Center(
                      child: Text(
                        'Tap to upload a photo',
                        style: TextStyle(fontSize: 16, color: themeColor),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Choose your level',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
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
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search, color: themeColor),
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBlankPage(String title) {
    return Center(
      child: Text(
        '$title page is under development.',
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
            'Account Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildProfileOption(Icons.person, 'My Profile'),
          _buildProfileOption(Icons.history, 'Session History'),
          _buildProfileOption(Icons.star_border, 'My Mentors'),
          _buildProfileOption(Icons.payment, 'Payment History'),
          _buildProfileOption(Icons.settings, 'Settings'),
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

  Widget _buildProfileOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label),
      onTap: () {},
    );
  }

  Widget _buildLevelCard(String level, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: themeColor),
          const SizedBox(height: 10),
          Text(
            level,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context,
      {bool isLearningPhoto = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera,
                    isLearningPhoto: isLearningPhoto);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery,
                    isLearningPhoto: isLearningPhoto);
              },
            ),
          ],
        );
      },
    );
  }
}
