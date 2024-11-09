import 'package:flutter/material.dart';
import 'mathsavail.dart'; // Import the MathsPage class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SecondaryLevelPage(),
    );
  }
}

class SecondaryLevelPage extends StatelessWidget {
  const SecondaryLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secondary Level'),
        backgroundColor: Colors.teal,
        elevation: 4, // Slight elevation for a refined look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildGradeTile(context, 'Grade 9'),
            const SizedBox(height: 20),
            buildGradeTile(context, 'Grade 10'),
            const SizedBox(height: 20),
            buildGradeTile(context, 'Grade 11'),
            const SizedBox(height: 20),
            buildGradeTile(context, 'Grade 12'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget buildGradeTile(BuildContext context, String grade) {
    return GestureDetector(
      onTap: () {
        if (grade == 'Grade 9') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Grade9SubjectsPage()),
          );
        } else if (grade == 'Grade 10') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Grade10SubjectsPage()),
          );
        } else if (grade == 'Grade 11') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Grade11SubjectsPage()),
          );
        } else if (grade == 'Grade 12') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Grade12SubjectsPage()),
          );
        }
      },
      child: Card(
        elevation: 10, // Increased elevation for a more pronounced shadow
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Rounded corners for a modern look
        ),
        color: Colors.white,
        shadowColor:
            Colors.teal.withOpacity(0.4), // Soft shadow for a softer effect
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Spacious padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                grade,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold, // Bold for emphasis
                  color: Colors.teal,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }
}

class Grade9SubjectsPage extends StatelessWidget {
  const Grade9SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 9 Subjects'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSubjectTile(context, 'English'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Mathematics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Science'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Social Studies'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Nepali'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Computer Science'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Optional Mathematics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Account'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  static Widget buildSubjectTile(BuildContext context, String subject) {
    return GestureDetector(
      onTap: () {
        if (subject == 'Mathematics') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MathsPage()),
          );
        }
        // Add navigation for other subjects if needed
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        shadowColor: Colors.teal.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }
}

class Grade10SubjectsPage extends StatelessWidget {
  const Grade10SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 10 Subjects'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSubjectTile(context, 'English'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Mathematics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Science'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Social Studies'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Nepali'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Computer Science'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Optional Mathematics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Account'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  static Widget buildSubjectTile(BuildContext context, String subject) {
    return GestureDetector(
      onTap: () {
        if (subject == 'Mathematics') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MathsPage()),
          );
        }
        // Add navigation for other subjects if needed
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        shadowColor: Colors.teal.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }
}

class Grade11SubjectsPage extends StatelessWidget {
  const Grade11SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 11 Subjects'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSubjectTile(context, 'English'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Mathematics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Physics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Chemistry'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Nepali'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Biology'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Social Studies'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  static Widget buildSubjectTile(BuildContext context, String subject) {
    return GestureDetector(
      onTap: () {
        if (subject == 'Mathematics') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MathsPage()),
          );
        }
        // Add navigation for other subjects if needed
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        shadowColor: Colors.teal.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }
}

class Grade12SubjectsPage extends StatelessWidget {
  const Grade12SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 12 Subjects'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSubjectTile(context, 'English'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Mathematics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Physics'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Chemistry'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Nepali'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Computer Science'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  static Widget buildSubjectTile(BuildContext context, String subject) {
    return GestureDetector(
      onTap: () {
        if (subject == 'Mathematics') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MathsPage()),
          );
        }
        // Add navigation for other subjects if needed
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        shadowColor: Colors.teal.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }
}
