import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'mentor_search_page.dart'; // This file should include the updated MentorSearchPage accepting fieldOfStudy.
import 'session_history.dart';
import 'my_mentors.dart';
import 'menteeprofile_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BachelorLevelPage extends StatefulWidget {
  const BachelorLevelPage({super.key});

  /// Updated data structure for Bachelor level.
  static const bachelorPrograms = {
    'Computer Engineering': {
      'Semester 1': [
        "Programming Basics",
        "Mathematics",
        "Physics",
        "Engineering Drawing",
        "Basic Electronics"
      ],
      'Semester 2': [
        "Data Structures",
        "Algorithms",
        "Electronics",
        "Discrete Mathematics",
        "Digital Logic"
      ],
      'Semester 3': [
        "Operating Systems",
        "Database Systems",
        "Networks",
        "Object-Oriented Programming",
        "Linear Algebra"
      ],
      'Semester 4': [
        "Computer Architecture",
        "Software Engineering",
        "Computer Networks",
        "Microprocessors",
        "Database Management Systems"
      ],
      'Semester 5': [
        "Web Development",
        "Data Structures and Algorithms",
        "Software Development",
        "Networking Protocols",
        "Computer Graphics"
      ],
      'Semester 6': [
        "Artificial Intelligence",
        "Information Security",
        "Software Testing",
        "Mobile Computing",
        "Cloud Computing"
      ],
      'Semester 7': [
        "Machine Learning",
        "Computer Vision",
        "Embedded Systems",
        "Data Science",
        "Big Data"
      ],
      'Semester 8': [
        "Project Work",
        "Internship",
        "Ethical Hacking",
        "Cyber Security",
        "Data Analytics"
      ]
    },
    'Civil Engineering': {
      'Semester 1': [
        "Engineering Drawing",
        "Mathematics",
        "Physics",
        "Chemistry",
        "Surveying"
      ],
      'Semester 2': [
        "Mechanics",
        "Surveying",
        "Material Science",
        "Fluid Mechanics",
        "Strength of Materials"
      ],
      'Semester 3': [
        "Geotechnical Engineering",
        "Building Materials",
        "Structural Analysis",
        "Concrete Technology",
        "Soil Mechanics"
      ],
      'Semester 4': [
        "Transportation Engineering",
        "Hydrology",
        "Construction Management",
        "Reinforced Concrete Structures",
        "Structural Design"
      ],
      'Semester 5': [
        "Building Construction",
        "Environmental Engineering",
        "Earthquake Engineering",
        "Foundation Engineering",
        "Advanced Surveying"
      ],
      'Semester 6': [
        "Advanced Structural Analysis",
        "Water Resources Engineering",
        "Pavement Design",
        "Bridge Engineering",
        "Geotechnical Engineering"
      ],
      'Semester 7': [
        "Urban Planning",
        "Transportation Systems",
        "Project Management",
        "Hydraulic Structures",
        "Coastal Engineering"
      ],
      'Semester 8': [
        "Project Work",
        "Internship",
        "Construction Planning",
        "Sustainable Development",
        "Disaster Management"
      ]
    },
    'MBBS': {
      'Year 1': [
        "Anatomy",
        "Physiology",
        "Biochemistry",
        "Histology",
        "Microbiology"
      ],
      'Year 2': [
        "Pathology",
        "Pharmacology",
        "Microbiology",
        "Forensic Medicine",
        "Community Medicine"
      ],
      'Year 3': [
        "Surgery",
        "Internal Medicine",
        "Pediatrics",
        "Obstetrics and Gynecology",
        "Ophthalmology"
      ],
      'Year 4': [
        "Orthopedics",
        "Anesthesia",
        "Emergency Medicine",
        "Radiology",
        "Dermatology"
      ],
      'Year 5': [
        "Psychiatry",
        "Neurology",
        "Pediatrics Surgery",
        "Cardiology",
        "Gastroenterology"
      ]
    },
    'Architecture': {
      'Year 1': [
        "Design Basics",
        "History of Architecture",
        "Construction Technology",
        "Environmental Design",
        "Graphics and Drawing"
      ],
      'Year 2': [
        "Urban Planning",
        "Building Materials",
        "Structural Design",
        "Construction Management",
        "Theory of Architecture"
      ],
      'Year 3': [
        "Building Construction",
        "Sustainability in Architecture",
        "Architectural Design",
        "Structures for Architecture",
        "Interior Design"
      ],
      'Year 4': [
        "Building Systems",
        "Lighting Design",
        "Public Buildings",
        "Landscape Design",
        "Smart Cities"
      ],
      'Year 5': [
        "Professional Practice",
        "Architectural Theory",
        "Construction Documentation",
        "Urban Design",
        "Final Project"
      ]
    },
  };

  @override
  State<BachelorLevelPage> createState() => BachelorLevelPageState();

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

class BachelorLevelPageState extends State<BachelorLevelPage> {
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
          // Program list page
          Scaffold(
            body: _buildProgramList(),
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
              label: 'My Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: _selectedIndex == 3 ? themeColor : Colors.grey),
              label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  color: _selectedIndex == 4 ? themeColor : Colors.grey),
              label: 'Profile'),
        ],
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Bachelor Level';
      case 1:
        return 'My Community';
      case 2:
        return 'Notifications';
      case 3:
        return 'Profile';
      default:
        return 'Bachelor Level';
    }
  }

  Widget _buildProgramList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: BachelorLevelPage.bachelorPrograms.keys.length,
        itemBuilder: (context, index) {
          String program =
              BachelorLevelPage.bachelorPrograms.keys.elementAt(index);
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BachelorProgramPage(
                        program: program,
                        semesters: BachelorLevelPage.bachelorPrograms[program]!,
                      ),
                    ),
                  );
                },
                child: BachelorLevelPage.buildCard(program),
              ),
              if (index < BachelorLevelPage.bachelorPrograms.keys.length - 1)
                Divider(color: Colors.grey[300]),
            ],
          );
        },
      ),
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
            // Payment history functionality.
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

/// This page displays the semesters (or years) for a given Bachelor program.
class BachelorProgramPage extends StatefulWidget {
  final String program;
  final Map<String, List<String>> semesters;

  const BachelorProgramPage(
      {required this.program, required this.semesters, super.key});

  @override
  State<BachelorProgramPage> createState() => _BachelorProgramPageState();
}

class _BachelorProgramPageState extends State<BachelorProgramPage> {
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
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
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
          // Semester list page
          Scaffold(
            body: _buildSemesterList(),
          ),
          // My Community placeholder
          Scaffold(body: _buildBlankPage()),
          // Notifications placeholder
          Scaffold(body: _buildBlankPage()),
          // Profile page
          Scaffold(body: _buildProfile()),
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
              label: 'My Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: _selectedIndex == 3 ? themeColor : Colors.grey),
              label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  color: _selectedIndex == 4 ? themeColor : Colors.grey),
              label: 'Profile'),
        ],
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '${widget.program} - Semesters';
      case 1:
        return 'My Community';
      case 2:
        return 'Notifications';
      case 3:
        return 'Profile';
      default:
        return '${widget.program} - Semesters';
    }
  }

  Widget _buildSemesterList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.semesters.keys.length,
        itemBuilder: (context, index) {
          String semester = widget.semesters.keys.elementAt(index);
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BachelorSemesterSubjectsPage(
                        program: widget.program,
                        semester: semester,
                        subjects: widget.semesters[semester]!,
                      ),
                    ),
                  );
                },
                child: BachelorLevelPage.buildCard(semester),
              ),
              if (index < widget.semesters.keys.length - 1)
                Divider(color: Colors.grey[300]),
            ],
          );
        },
      ),
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
            // Payment history functionality.
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

/// This page displays the subjects for a selected semester (or year) in a Bachelor program.
class BachelorSemesterSubjectsPage extends StatefulWidget {
  final String program;
  final String semester;
  final List<String> subjects;

  const BachelorSemesterSubjectsPage(
      {required this.program,
      required this.semester,
      required this.subjects,
      super.key});

  @override
  State<BachelorSemesterSubjectsPage> createState() =>
      _BachelorSemesterSubjectsPageState();
}

class _BachelorSemesterSubjectsPageState
    extends State<BachelorSemesterSubjectsPage> {
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
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
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
          // Subject list page
          Scaffold(
            body: _buildSubjectList(),
          ),
          // My Community placeholder
          Scaffold(body: _buildBlankPage()),
          // Notifications placeholder
          Scaffold(body: _buildBlankPage()),
          // Profile page
          Scaffold(body: _buildProfile()),
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
              label: 'My Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: _selectedIndex == 3 ? themeColor : Colors.grey),
              label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                  color: _selectedIndex == 4 ? themeColor : Colors.grey),
              label: 'Profile'),
        ],
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '${widget.semester} Subjects';
      case 1:
        return 'My Community';
      case 2:
        return 'My Learning';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return '${widget.semester} Subjects';
    }
  }

  Widget _buildSubjectList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.subjects.length,
        itemBuilder: (context, index) {
          String subject = widget.subjects[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  // When a subject is tapped in a Bachelor program, pass:
                  // category: 'Bachelors'
                  // fieldOfStudy: widget.program (e.g. "Computer Engineering")
                  // classLevel: widget.semester (e.g. "Semester 1")
                  // subject: the tapped subject.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MentorSearchPage(
                        category: 'Bachelors',
                        fieldOfStudy: widget.program,
                        classLevel: widget.semester,
                        subject: subject,
                      ),
                    ),
                  );
                },
                child: BachelorLevelPage.buildCard(subject),
              ),
              if (index < widget.subjects.length - 1)
                Divider(color: Colors.grey[300]),
            ],
          );
        },
      ),
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
            // Payment history functionality.
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
