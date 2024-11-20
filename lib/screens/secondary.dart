import 'package:flutter/material.dart';
import 'package:nepalmentors/screens/dashboard.dart';
import 'mathsavail.dart';

class SecondaryLevelPage extends StatefulWidget {
  const SecondaryLevelPage({super.key});

  static const gradeSubjects = {
    'Grade 9': [
      'English',
      'Mathematics',
      'Science',
      'Social Studies',
      'Nepali',
      'Computer',
      'Optional Mathematics',
      'Account',
      'Biology',
      'Physics'
    ],
    'Grade 10': [
      'English',
      'Mathematics',
      'Science',
      'Social Studies',
      'Nepali',
      'Computer',
      'Optional Mathematics',
      'Account',
      'Biology',
      'Physics'
    ],
    'Grade 11': [
      'English',
      'Mathematics',
      'Science',
      'Nepali',
      'Computer',
      'Optional Mathematics',
      'Account',
      'Economics',
      'Political Science',
      'Business Studies'
    ],
    'Grade 12': [
      'English',
      'Mathematics',
      'Science',
      'Nepali',
      'Computer',
      'Optional Mathematics',
      'Account',
      'Economics',
      'Political Science',
      'Business Studies'
    ]
  };

  @override
  State<SecondaryLevelPage> createState() => _SecondaryLevelPageState();
}

class _SecondaryLevelPageState extends State<SecondaryLevelPage> {
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
        return 'Secondary Level';
      case 1:
        return 'Search';
      case 2:
        return 'My Learning';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'Secondary Level';
    }
  }

  Widget _buildGradeList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: SecondaryLevelPage.gradeSubjects.keys.length,
        itemBuilder: (context, index) {
          String grade = SecondaryLevelPage.gradeSubjects.keys.elementAt(index);
          return Column(
            children: [
              buildGradeTile(context, grade),
              if (index < SecondaryLevelPage.gradeSubjects.keys.length - 1)
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
                grade: grade,
                subjects: SecondaryLevelPage.gradeSubjects[grade]!),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              grade,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.teal),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.teal),
          ],
        ),
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

  Widget _buildBlankPage() {
    return const Center(
      child: Text(
        'This page is under development.',
        style: TextStyle(fontSize: 18, color: Colors.teal),
      ),
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
          // Search page
          const SearchPage(),
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

  String getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '${widget.grade} Subjects';
      case 1:
        return 'Search';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subject,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.teal),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.teal),
          ],
        ),
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

  Widget _buildBlankPage() {
    return const Center(
      child: Text(
        'This page is under development.',
        style: TextStyle(fontSize: 18, color: Colors.teal),
      ),
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
