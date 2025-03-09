import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'mentor_search_page.dart';
import 'session_history.dart';
import 'my_mentors.dart';
import 'menteeprofile_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Top-level Masters page that shows a list of Masters programs.
class MastersLevelPage extends StatefulWidget {
  const MastersLevelPage({super.key});

  /// Data structure for Masters level.
  static const mastersPrograms = {
    "Computer Science": {
      "Year 1": ["Machine Learning", "Artificial Intelligence", "Data Mining"],
      "Year 2": ["Big Data Analytics", "Cloud Computing"]
    },
    "Medicine": {
      "Year 1": ["Clinical Practice", "Pharmacology", "Pathophysiology"],
      "Year 2": ["Medical Ethics", "Community Medicine"]
    },
    "Law": {
      "Year 1": ["Judicial Review", "International Law", "Legal Theory"],
      "Year 2": ["Constitutional Rights", "Human Rights Law"]
    },
    "Psychology": {
      "Year 1": ["Behavioral Therapy", "Cognitive Science", "Psychopathology"],
      "Year 2": ["Clinical Neuropsychology", "Psychological Assessment"]
    },
  };

  /// Reusable card widget.
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

  @override
  State<MastersLevelPage> createState() => _MastersLevelPageState();
}

class _MastersLevelPageState extends State<MastersLevelPage> {
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
          // Masters Program List page
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
            // Navigate back to Dashboard
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
        return 'Masters Level';
      case 1:
        return 'My Community';
      case 2:
        return 'Notifications';
      case 3:
        return 'Profile';
      default:
        return 'Masters Level';
    }
  }

  Widget _buildProgramList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: MastersLevelPage.mastersPrograms.keys.length,
        itemBuilder: (context, index) {
          String program =
              MastersLevelPage.mastersPrograms.keys.elementAt(index);
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to the program's academic years page.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MastersProgramPage(
                        program: program,
                        years: MastersLevelPage.mastersPrograms[program]!,
                      ),
                    ),
                  );
                },
                child: MastersLevelPage.buildCard(program),
              ),
              if (index < MastersLevelPage.mastersPrograms.keys.length - 1)
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
            // Add payment history functionality here.
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
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}

/// This page displays the academic years for a selected Masters program.
class MastersProgramPage extends StatefulWidget {
  final String program;
  final Map<String, List<String>> years;

  const MastersProgramPage({
    required this.program,
    required this.years,
    super.key,
  });

  @override
  State<MastersProgramPage> createState() => _MastersProgramPageState();
}

class _MastersProgramPageState extends State<MastersProgramPage> {
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
          // Academic Years list page
          Scaffold(
            body: _buildYearsList(),
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
        return '${widget.program} - Academic Years';
      case 1:
        return 'My Community';
      case 2:
        return 'Notifications';
      case 3:
        return 'Profile';
      default:
        return '${widget.program} - Academic Years';
    }
  }

  Widget _buildYearsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.years.keys.length,
        itemBuilder: (context, index) {
          String year = widget.years.keys.elementAt(index);
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to the subjects page for the selected year.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MastersYearSubjectsPage(
                        program: widget.program,
                        year: year,
                        subjects: widget.years[year]!,
                      ),
                    ),
                  );
                },
                child: MastersLevelPage.buildCard(year),
              ),
              if (index < widget.years.keys.length - 1)
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

  // Inside the _buildProfile() method of MastersLevelPage:

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
            // Add payment history functionality here.
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

/// This page displays the subjects for a selected academic year in a Masters program.
class MastersYearSubjectsPage extends StatefulWidget {
  final String program;
  final String year;
  final List<String> subjects;

  const MastersYearSubjectsPage({
    required this.program,
    required this.year,
    required this.subjects,
    super.key,
  });

  @override
  State<MastersYearSubjectsPage> createState() =>
      _MastersYearSubjectsPageState();
}

class _MastersYearSubjectsPageState extends State<MastersYearSubjectsPage> {
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
          // Subjects list page
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
        return '${widget.year} Subjects';
      case 1:
        return 'My Community';
      case 2:
        return 'Notifications';
      case 3:
        return 'Profile';
      default:
        return '${widget.year} Subjects';
    }
  }

  Widget _buildSubjectList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: widget.subjects.length,
        itemBuilder: (context, index) {
          String subject = widget.subjects[index];
          // Use "Masters" as the classLevel for API purposes.
          String apiClassLevel = "Masters";

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MentorSearchPage(
                        category: widget
                            .program, // Using the program name dynamically.
                        classLevel:
                            apiClassLevel, // Pass only "Masters" as class level.
                        subject: subject, // Pass the subject.
                      ),
                    ),
                  );
                },
                child: MastersLevelPage.buildCard(subject),
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

  // Inside the _buildProfile() method of MastersLevelPage:

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
            // Add payment history functionality here.
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