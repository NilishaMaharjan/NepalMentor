import 'package:flutter/material.dart';
import 'package:nepalmentors/screens/dashboard.dart';
import 'mathsavail.dart';
import 'session_history.dart'; // Import the session_history.dart page
import 'my_mentors.dart'; // Import the my_mentors.dart page
import 'profile_edit.dart'; // Import the profile_edit.dart page

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
          //My Communities page
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
              color: _selectedIndex == 1 ? themeColor : Colors.grey,
            ),
            label: 'My Community',
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
        return 'My Community';
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
  final PageController _pageController = PageController();
  final Color themeColor = const Color.fromARGB(255, 47, 161, 150);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getAppBarTitle(_selectedIndex)),
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
          // Grade subjects list page
          _buildGradeSubjectList(),
          // My Communities page
          Scaffold(
            body: _buildBlankPage(),
          ),
          // My Learning page placeholder
          _buildBlankPage(),
          // Notifications page placeholder
          _buildBlankPage(),
          // Profile page
          _buildProfile(),
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
            icon: Icon(Icons.home, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups,
              color: _selectedIndex == 1 ? themeColor : Colors.grey,
            ),
            label: 'My Communiy',
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

  String getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '${widget.grade} Subjects';
      case 1:
        return 'My Community';
      case 2:
        return 'My Learning';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return '${widget.grade} Subjects';
    }
  }

  Widget _buildGradeSubjectList() {
    return Padding(
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

Widget _buildBlankPage() {
  return const Center(
    child: Text(
      'This page is under development.',
      style: TextStyle(fontSize: 18, color: Colors.teal),
    ),
  );
}
