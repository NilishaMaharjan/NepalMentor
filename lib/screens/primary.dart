import 'package:flutter/material.dart';
import 'package:nepalmentors/screens/dashboard.dart';
import 'mathsavail.dart';

class PrimaryLevelPage extends StatefulWidget {
  const PrimaryLevelPage({super.key});

  static const gradeSubjects = {
    'Grade 4': [
      'English',
      'Mathematics',
      'Science',
      'Social Studies',
      'Nepali',
      'Computer'
    ],
    'Grade 5': [
      'English',
      'Mathematics',
      'Science',
      'Social Studies',
      'Nepali',
      'Computer'
    ],
    'Grade 6': [
      'English',
      'Mathematics',
      'Science',
      'Social Studies',
      'Nepali',
      'Computer'
    ],
    'Grade 7': [
      'English',
      'Mathematics',
      'Science',
      'Social Studies',
      'Nepali',
      'Computer'
    ],
    'Grade 8': [
      'English',
      'Mathematics',
      'Science',
      'Social Studies',
      'Nepali',
      'Computer',
      'Optional Mathematics',
      'Account'
    ]
  };

  @override
  State<PrimaryLevelPage> createState() => _PrimaryLevelPageState();

  static Widget buildCard(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.teal),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.teal),
        ],
      ),
    );
  }
}

class _PrimaryLevelPageState extends State<PrimaryLevelPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final Color themeColor = const Color.fromARGB(255, 47, 161, 150);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        backgroundColor: themeColor,
        elevation: 4,
        leading: _selectedIndex == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  FocusScope.of(context)
                      .unfocus(); // Dismiss keyboard when back is pressed
                  setState(() {
                    _selectedIndex = 0;
                    _pageController.jumpToPage(0);
                  });
                },
              ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // Main Grade List page
          Scaffold(
            body: _buildGradeList(),
          ),
          // Search page
          const SearchPage(),
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
              Icons.search,
              color: _selectedIndex == 1 ? themeColor : Colors.grey,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
              color: _selectedIndex == 2 ? themeColor : Colors.grey,
            ),
            label: 'My Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: _selectedIndex == 3 ? themeColor : Colors.grey,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: _selectedIndex == 4 ? themeColor : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Primary Level';
      case 1:
        return 'Search';
      case 2:
        return 'My Learning';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'Primary Level';
    }
  }

  Widget _buildGradeList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: PrimaryLevelPage.gradeSubjects.keys.length,
        itemBuilder: (context, index) {
          String grade = PrimaryLevelPage.gradeSubjects.keys.elementAt(index);
          return Column(
            children: [
              buildGradeTile(context, grade),
              if (index < PrimaryLevelPage.gradeSubjects.keys.length - 1)
                Divider(color: Colors.grey[300]),
            ],
          );
        },
      ),
    );
  }

  Widget buildGradeTile(BuildContext context, String grade) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GradeSubjectsPage(
                grade: grade, subjects: PrimaryLevelPage.gradeSubjects[grade]!),
          ),
        );
      },
      child: PrimaryLevelPage.buildCard(grade),
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
          _buildProfileOption(Icons.person, 'My Profile'), // View/Edit Profile
          _buildProfileOption(
              Icons.history, 'Session History'), // View past sessions
          _buildProfileOption(
              Icons.star_border, 'My Mentors'), // View mentees' mentors
          _buildProfileOption(
              Icons.payment, 'Payment History'), // Payment history
          _buildProfileOption(Icons.settings, 'Settings'), // App Settings
          const SizedBox(height: 20),
          _buildLogoutButton(), // Logout
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      onTap: () {
        // Handle the option tap based on title or add routes here
      },
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
}

class GradeSubjectsPage extends StatefulWidget {
  final String grade;
  final List<String> subjects;

  const GradeSubjectsPage(
      {required this.grade, required this.subjects, super.key});

  @override
  State<GradeSubjectsPage> createState() => _GradeSubjectsPageState();
}

class _GradeSubjectsPageState extends State<GradeSubjectsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.grade} Subjects'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.subjects.length,
          itemBuilder: (context, index) {
            String subject = widget.subjects[index];
            return Column(
              children: [
                buildSubjectTile(context, subject),
                if (index < widget.subjects.length - 1)
                  Divider(color: Colors.grey[300]),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, color: Colors.grey),
            label: 'My Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.grey),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildSubjectTile(BuildContext context, String subject) {
    return GestureDetector(
      onTap: () {
        if (subject == 'Mathematics') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MathsPage()));
        }
      },
      child: PrimaryLevelPage.buildCard(subject),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSearch(),
    );
  }

  Widget _buildSearch() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search, color: Colors.teal),
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
    );
  }
}

Widget _buildBlankPage() {
  return const Center(
    child: Text(
      'This page is under development.',
      style: TextStyle(fontSize: 18, color: Colors.teal),
    ),
  );
}
