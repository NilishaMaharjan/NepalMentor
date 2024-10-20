import 'package:flutter/material.dart';
import 'mathsavail.dart'; // Import the MathsPage class

class PrimaryLevelPage extends StatelessWidget {
  const PrimaryLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primary Level'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildGradeTile(context, 'Grade 7'),
            const SizedBox(height: 20), // Increased spacing between tiles
            buildGradeTile(context, 'Grade 8'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'My Learning'),
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
        if (grade == 'Grade 7') {
          // Navigate to the Grade 7 Subjects Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Grade7SubjectsPage()),
          );
        }
        // Add navigation for Grade 8 if needed
      },
      child: Card(
        elevation: 8, // Increased elevation for a more pronounced shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        color: Colors.white,
        shadowColor: Colors.teal.withOpacity(0.5), // Shadow color matching the theme
        child: Padding(
          padding: const EdgeInsets.all(20.0), // More padding for spaciousness
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                grade,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600, // Bold weight for emphasis
                  color: Colors.teal, // Consistent text color
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

class Grade7SubjectsPage extends StatelessWidget {
  const Grade7SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 7 Subjects'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSubjectTile(context, 'Science'),
            const SizedBox(height: 20), // Increased spacing between subject tiles
            buildSubjectTile(context, 'Maths'),
            const SizedBox(height: 20),
            buildSubjectTile(context, 'Computer Science'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'My Learning'),
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
        if (subject == 'Maths') {
          // Navigate to the Maths Page when 'Maths' is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MathsPage()),
          );
        }
      },
      child: Card(
        elevation: 8, // Increased elevation for a more pronounced shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        color: Colors.white,
        shadowColor: Colors.teal.withOpacity(0.5), // Shadow color matching the theme
        child: Padding(
          padding: const EdgeInsets.all(20.0), // More padding for spaciousness
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600, // Medium weight for subjects
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
