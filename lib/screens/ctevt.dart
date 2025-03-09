import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'mentor_search_page.dart';
import 'session_history.dart';
import 'my_mentors.dart';
import 'menteeprofile_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CTEVTLevelPage extends StatefulWidget {
  const CTEVTLevelPage({super.key});

  /// Updated subject mapping for CTEVT (Nepal context)
  static const gradeSubjects = {
    'Level 1': [
      'English',
      'Mathematics',
      'ICT Basics',
      'Workshop Practices',
      'Technical Drawing'
    ],
    'Level 2': [
      'English',
      'Mathematics',
      'Electrical Fundamentals',
      'Basic Electronics',
      'Mechanics & Machines'
    ],
    'Level 3': [
      'English',
      'Mathematics',
      'Advanced Mechanics',
      'Automation & Control',
      'Project Management'
    ]
  };

  @override
  State<CTEVTLevelPage> createState() => _CTEVTLevelPageState();

  // Reusable card widget.
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

class _CTEVTLevelPageState extends State<CTEVTLevelPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final Color themeColor = const Color.fromARGB(255, 47, 161, 150);

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("Retrieved userId: $userId");
    return userId;
  }

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
                  FocusScope.of(context).unfocus();
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
          // Grade list page
          Scaffold(
            body: _buildGradeList(),
          ),
          // My Community placeholder
          Scaffold(
            body: _buildBlankPage(),
          ),
          // Notifications placeholder
          Scaffold(
            body: _buildBlankPage(),
          ),
          // Profile page
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
              icon: Icon(Icons.home, color: Colors.grey), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups,
                color: _selectedIndex == 1 ? themeColor : Colors.grey),
            label: 'My Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,
                color: _selectedIndex == 3 ? themeColor : Colors.grey),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,
                color: _selectedIndex == 4 ? themeColor : Colors.grey),
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
        return 'CTEVT Level';
      case 1:
        return 'My Community';
      case 2:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'CTEVT Level';
    }
  }

  Widget _buildGradeList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: CTEVTLevelPage.gradeSubjects.keys.length,
        itemBuilder: (context, index) {
          String grade = CTEVTLevelPage.gradeSubjects.keys.elementAt(index);
          return Column(
            children: [
              buildGradeTile(context, grade),
              if (index < CTEVTLevelPage.gradeSubjects.keys.length - 1)
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
            builder: (context) => CTEVTGradeSubjectsPage(
              grade: grade,
              subjects: CTEVTLevelPage.gradeSubjects[grade]!,
            ),
          ),
        );
      },
      child: CTEVTLevelPage.buildCard(grade),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildProfileOption(Icons.person, 'My Profile', () async {
            String? userId =
                await getUserId(); // Retrieve the userId dynamically.
            if (userId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(userId: userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User ID not found.")),
              );
            }
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
            // Add payment history functionality.
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

class CTEVTGradeSubjectsPage extends StatefulWidget {
  final String grade;
  final List<String> subjects;

  const CTEVTGradeSubjectsPage({
    required this.grade,
    required this.subjects,
    super.key,
  });

  @override
  State<CTEVTGradeSubjectsPage> createState() => _CTEVTGradeSubjectsPageState();
}

class _CTEVTGradeSubjectsPageState extends State<CTEVTGradeSubjectsPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final Color themeColor = const Color.fromARGB(255, 47, 161, 150);

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("Retrieved userId: $userId");
    return userId;
  }

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
                  FocusScope.of(context).unfocus();
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
          // Placeholders for additional pages:
          Scaffold(body: _buildBlankPage()),
          _buildBlankPage(),
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
              icon: Icon(Icons.home, color: Colors.grey), label: ''),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups,
              color: _selectedIndex == 1 ? themeColor : Colors.grey,
            ),
            label: 'My Community',
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
        return 'Notifications';
      case 3:
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
        // Navigate to MentorSearchPage with the appropriate parameters.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MentorSearchPage(
              category: "CTEVT",
              classLevel:
                  subject, // Passing subject as classLevel (if needed, adjust accordingly)
              subject: subject,
            ),
          ),
        );
      },
      child: CTEVTLevelPage.buildCard(subject),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildProfileOption(Icons.person, 'My Profile', () async {
            String? userId =
                await getUserId(); // Retrieve the userId dynamically.
            if (userId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(userId: userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User ID not found.")),
              );
            }
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
            // Add payment history functionality.
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
